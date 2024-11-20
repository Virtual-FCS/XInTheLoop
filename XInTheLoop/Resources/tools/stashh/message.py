# StasHH generic CAN messages
# Copyright (c) 2024 SINTEF

import can
from cantools.database.can.database import Database
import crcmod
from enum import Enum

CrcRule = Enum('CrcRule', ['A', 'B'])
CRC8H2F = crcmod.mkCrcFun(0x12F, initCrc=0x00, rev=False, xorOut=0xFF)

def crc_calc(msg: can.message.Message, rule: CrcRule, store: bool = False) -> bool:
  """Compute CRC according to rule and store or verify CRC byte in msg."""
  c, d = (0, 1) if rule == CrcRule.B else (7, 0)  # Indices of CRC and first data byte
  crc = CRC8H2F(msg.data[d:d+7] + msg.arbitration_id.to_bytes(byteorder='little', length=4))
  if not store:
    return msg.data[c] == crc
  msg.data[c] = crc
  return True

class CanMessage:
  """StasHH CAN message"""

  def __init__(self, db: Database, name: str):
    # Not (yet) needed: self.db = db
    self.name = name
    self.message = db.get_message_by_name(name)
    self.msg = None
    self.task = None

  def signal_names(self) -> list:
    return [s.name for s in self.message.signals]

  def dict_encode(self, signals: dict) -> None:
    """Encode signals from dict"""
    #DEBUG print(f"encode({signals})")
    msg = can.Message(arbitration_id=self.message.frame_id, data=self.message.encode(signals))
    # TODO: self.task.modify(msg) ?
    if type(msg) == type(self.msg):
      assert self.msg.arbitration_id == msg.arbitration_id
      assert self.msg.is_extended_id == msg.is_extended_id
      assert self.msg.dlc == msg.dlc
      self.msg.timestamp = msg.timestamp
      for i in range(msg.dlc):
        self.msg.data[i] = msg.data[i]  # Avoid creating a new object
    else:
      self.msg = msg  # Initial assignment

  def nc_filter_encode(self, signals: dict) -> None:
    """Encode own non-counter signals only, ignore others"""
    self.filter_encode({k: v for k,v in signals.items() if not k.endswith("_Counter")})

  def filter_encode(self, signals: dict) -> None:
    """Encode own signals only, ignore others"""
    self.dict_encode({k: v for k,v in signals.items() if k.startswith(self.name + "_")})

  def send_periodic(self, bus: can.BusABC, tscale: float = 1) -> None:
    self.task = bus.send_periodic(self.msg, tscale * self.message.cycle_time / 1000.0)
    if not isinstance(self.task, can.ModifiableCyclicTaskABC):
      print("This interface doesn't seem to support modification")
      self.task.stop()
      quit()

class CrcCanMessage(CanMessage):
  """StasHH CAN message with a one-byte CRC and 4-bit counter"""

  def __init__(self, db: Database, name: str, crc_rule: CrcRule):
    super().__init__(db, name)
    self.crc_rule = crc_rule
    self.counter = 0

  def get_counter(self, counter: int = None) -> int:
    if counter is None:
        counter = (self.counter + 1) & 0xf
    self.counter = counter
    return counter

  def dict_encode(self, signals: dict, crc: int = None) -> None:
    super().dict_encode(signals)
    assert crc_calc(self.msg, self.crc_rule, crc is None)
    #DEBUG print(f"CRC={self.msg.data[0 if self.crc_rule == CrcRule.B else 7]}")

  def filter_encode(self, signals: dict) -> None:
    for s in self.message.signals:
      if s.name.endswith("_Counter"):
        signals[s.name] = self.get_counter(signals.get(s.name))
      elif s.name.endswith("_CRC"):
        signals[s.name] = 0
    super().filter_encode(signals)

class CanService:
  def __init__(self, bus: can.BusABC, db: Database, tscale: float = 1):
    self.bus = bus
    self.db = db
    self.tscale = tscale
    self.send_messages = []
    self.received_signals = {}

  def send_signal_names(self) -> list:
    return sum((m.signal_names() for m in self.send_messages), [])

  def ready2send(self) -> bool:
    return all(m.msg for m in self.send_messages)

  def started(self) -> bool:
    return all(m.task for m in self.send_messages)

  def dict_encode(self, signals: dict) -> None:
    for m in self.send_messages:
      m.filter_encode(signals)

  def initialize_signals(self, value = 0) -> None:
    self.dict_encode({sn: value for sn in self.send_signal_names() if not sn.endswith("_Counter")})

  def notifier(self, callback = can.Printer()) -> None:

    def received(msg: can.Message) -> None:
      """Received CAN message"""
      try:
        signals = self.db.decode_message(msg.arbitration_id, msg.data, decode_choices=False)
        self.received_signals.update(signals)
        # TODO: Increment counter of msg in self.send_messages if any
        print(signals)
      except KeyError:
        print(f"Ignoring unexpected ID={msg.arbitration_id}  started={self.started()}")

    can.Notifier(self.bus, [callback, received])

  def start(self) -> None:
    assert self.ready2send()
    # Start periodic sending all messages
    for m in self.send_messages:
      m.send_periodic(self.bus, self.tscale)

  def stop(self) -> None:
    assert self.started()
    for m in self.send_messages:
      m.task.stop()

  def restart(self) -> None:
    assert self.ready2send()
    assert self.started()
    for m in self.send_messages:
      m.task.start()
