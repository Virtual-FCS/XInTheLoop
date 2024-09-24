# Simulate FCCM sending incoming CAN and receive outgoing CAN
# Copyright (c) 2024 SINTEF

import can
import cantools
import keyboard
from pathlib import Path
from stashh.incoming import IncomingCanService

if __name__ == "__main__":
  with can.Bus(interface='pcan', channel='PCAN_USBBUS2', bitrate=500000, receive_own_messages=False) as bus:
    db = cantools.database.load_file(
      Path(__file__).with_name('STASHH_FCCU_VCU_communication_20221123_v02.dbc')
    )

    print("Create StasHH incoming CAN service...")
    canService = IncomingCanService(bus, db, tscale=100)

    def received(msg: can.Message) -> None:
      """Received CAN message, but don't print it"""
      pass

    canService.notifier([received])
    canService.initialize_signals(0)
    canService.start()

    # TODO: Change some signal values for test purposes
    # TODO: Simulate state machines, e.g. using canService.received_signals["MG1IC_Setpoint_Mode_Req"] and canService.send_signals["MG1IC_Setpoint_Mode_Req"]
    keyboard.wait("q")
