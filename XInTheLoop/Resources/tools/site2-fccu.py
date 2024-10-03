# Simulate FCCU sending incoming CAN and receive outgoing CAN
# Copyright (c) 2024 SINTEF

import can
import cantools
import keyboard
from pathlib import Path
from timeit import default_timer as timer
from stashh.incoming import IncomingCanService

if __name__ == "__main__":
  with can.Bus(interface='pcan', channel='PCAN_USBBUS2', bitrate=500000, receive_own_messages=False) as bus:
    db = cantools.database.load_file(
      Path(__file__).with_name('STASHH_FCCU_VCU_communication_20221123_v02-edit2.dbc')
    )

    print("Create StasHH incoming CAN service...")
    canService = IncomingCanService(bus, db, tscale=1)

    prev = 0
    t0 = 0

    def translate_mode(req: int) -> int:
      """Simulate returned mode from requested setpoint mode"""
      global prev
      global t0
      deviation = {  # Simulate the deviation from requested to returned setpoint mode
        10: 18,
        21: 20,
      }
      if req != prev:  # New mode requested?
        t0 = timer()
        prev = req
      if req == 10 and (timer() - t0) > 20:  # Simulate starting takes 20 seconds
        req = 0
      if req == 21 and (timer() - t0) > 40:  # Simulate stopping takes 40 seconds
        req = 2
      return deviation.get(req, req)

    def received(msg: can.Message) -> None:
      """Received CAN message, but don't print it"""
      # Simulate incoming values based on outgoing requests.
      canService.dict_encode({
        "MG1IMF1_Setpoint_Mode": translate_mode(canService.received_signals.get("MG1IC_Setpoint_Mode_Req", 0)),
        "MG1IMF1_HVIL_Status": canService.received_signals.get("HVBI_Driveline_Availability", 0) == 1,
        "MG1IS1_DC_current_output": canService.received_signals.get("MG1IC_Setpoint_Req", 0),
        "MG1IS1_DC_voltage_output": canService.received_signals.get("MG1IC_Setpoint_Req", 0),
      })

    canService.notifier([received])
    canService.initialize_signals(0)
    canService.start()

    keyboard.wait("q")
