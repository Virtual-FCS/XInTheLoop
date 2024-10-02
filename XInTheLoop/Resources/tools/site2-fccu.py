# Simulate FCCU sending incoming CAN and receive outgoing CAN
# Copyright (c) 2024 SINTEF

import can
import cantools
import keyboard
from pathlib import Path
from stashh.incoming import IncomingCanService

if __name__ == "__main__":
  with can.Bus(interface='pcan', channel='PCAN_USBBUS2', bitrate=500000, receive_own_messages=False) as bus:
    db = cantools.database.load_file(
      Path(__file__).with_name('STASHH_FCCU_VCU_communication_20221123_v02-edit2.dbc')
    )

    print("Create StasHH incoming CAN service...")
    canService = IncomingCanService(bus, db, tscale=1)

    def received(msg: can.Message) -> None:
      """Received CAN message, but don't print it"""
      # Simulate incoming values based on outgoing requests.
      canService.dict_encode({
        "MG1IMF1_Setpoint_Mode": canService.received_signals.get("MG1IC_Setpoint_Mode_Req", 0),
        "MG1IMF1_HVIL_Status": canService.received_signals.get("HVBI_Driveline_Availability", 0) == 1,
        "MG1IS1_DC_current_output": canService.received_signals.get("MG1IC_Setpoint_Req", 0),
        "MG1IS1_DC_voltage_output": canService.received_signals.get("MG1IC_Setpoint_Req", 0),
      })

    canService.notifier([received])
    canService.initialize_signals(0)
    canService.start()

    keyboard.wait("q")
