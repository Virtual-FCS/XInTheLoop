# StasHH incoming CAN messages
# Copyright (c) 2024 SINTEF

import can
from cantools.database.can.database import Database
from .message import CanService, CrcCanMessage, CrcRule

class Mg1imf1(CrcCanMessage):
  def __init__(self, db: Database):
    super().__init__(db, "MG1IMF1", CrcRule.B)

  def encode(self, setpoint_mode: int, hvil_status: int, counter: int = None, crc: int = None) -> None:
    super().dict_encode({
      "MG1IMF1_CRC": crc or 0,
      "MG1IMF1_Counter": self.get_counter(counter),
      "MG1IMF1_Setpoint_Mode": setpoint_mode,
      "MG1IMF1_HVIL_Status": hvil_status,
    }, crc)

class Mg1ir1(CrcCanMessage):
  def __init__(self, db: Database):
    super().__init__(db, "MG1IR1", CrcRule.B)

  def encode(self, reference_power: float, counter: int = None, crc: int = None) -> None:
    super().dict_encode({
      "MG1IR1_CRC": crc or 0,
      "MG1IR1_Counter": self.get_counter(counter),
      "MG1IR1_Reference_Power": reference_power,
    }, crc)

class Mg1ir2(CrcCanMessage):
  def __init__(self, db: Database):
    super().__init__(db, "MG1IR2", CrcRule.B)

  def encode(self, reference_current: float, reference_voltage: float, counter: int = None, crc: int = None) -> None:
    super().dict_encode({
      "MG1IR2_CRC": crc or 0,
      "MG1IR2_Counter": self.get_counter(counter),
      "MG1IR2_Reference_Current": reference_current,
      "MG1IR2_Reference_Voltage": reference_voltage,
    }, crc)

class Mg1is1(CrcCanMessage):
  def __init__(self, db: Database):
    super().__init__(db, "MG1IS1", CrcRule.B)

  def encode(self, current: float, voltage: float, counter: int = None, crc: int = None) -> None:
    super().dict_encode({
      "MG1IS1_CRC": crc or 0,
      "MG1IS1_Counter": self.get_counter(counter),
      "MG1IS1_DC_current_output": current,
      "MG1IS1_DC_voltage_output": voltage,
    }, crc)

class Mg1ilap(CrcCanMessage):
  def __init__(self, db: Database):
    super().__init__(db, "MG1ILAP", CrcRule.B)

  def encode(self, power_output_max: float, power_output_min: float, counter: int = None, crc: int = None) -> None:
    super().dict_encode({
      "MG1ILAP_CRC": crc or 0,
      "MG1ILAP_Counter": self.get_counter(counter),
      "MG1ILAP_DC_power_output_max": power_output_max,
      "MG1ILAP_DC_power_output_min": power_output_min,
    }, crc)

class IncomingCanService(CanService):

  def __init__(self, bus: can.BusABC, db: Database, tscale: float = 1):
    super().__init__(bus, db, tscale)
    self.send_messages.extend(m(db) for m in (Mg1imf1, Mg1ir1, Mg1ir2, Mg1is1, Mg1ilap))

  def obsolete_receive_loop(self) -> None:
    for msg in self.bus:
      try:
        message = self.db.get_message_by_frame_id(msg.arbitration_id)
        print(self.db.decode_message(msg.arbitration_id, msg.data, decode_choices=False))
      except KeyError:
        print(f"Ignoring unknown frame id {msg.arbitration_id} (0x{msg.arbitration_id:x})")
      else:
        print(f"Received message: {msg} is a {message}")
