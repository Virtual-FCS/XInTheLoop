# StasHH outgoing CAN messages

import can
from cantools.database.can.database import Database
from .message import CrcMessageOut, CrcRule, MessageOut, Service

class Mg1ic(CrcMessageOut):
  def __init__(self, db: Database):
    super().__init__(db, "MG1IC", CrcRule.B)

  def encode(self, setpoint_mode: int, setpoint: float, counter: int = None, crc: int = None) -> None:
    super().dict_encode({
      "MG1IC_CRC": crc or 0,
      "MG1IC_Counter": self.get_counter(counter),
      "MG1IC_Setpoint_Mode_Req": setpoint_mode,
      "MG1IC_Setpoint_Req": setpoint
    }, crc)

class Hvessc1(CrcMessageOut):
  def __init__(self, db: Database):
    super().__init__(db, "HVESSC1", CrcRule.A)

  def encode(self, power_down_command: int, counter: int = None, crc: int = None) -> None:
    super().dict_encode({
      "HVESSC1_PowerDown_Command": power_down_command,
      "HVESSC1_Control_1_Counter": self.get_counter(counter),
      "HVESSC1_Control_1_CRC": crc or 0
    }, crc)

class Hvbi(MessageOut):
  def __init__(self, db: Database):
    super().__init__(db, "HVBI")

  def encode(self, driveline_availability: int) -> None:
    super().dict_encode({
      "HVBI_Driveline_Availability": driveline_availability,
    })

class OutService(Service):

  def __init__(self, bus: can.BusABC, db: Database, tscale: float = 1):
    super().__init__(bus, db, tscale)
    self.send_messages.extend(m(db) for m in (Mg1ic, Hvessc1, Hvbi))
