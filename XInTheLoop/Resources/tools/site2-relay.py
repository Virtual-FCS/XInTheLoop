# site2 relay outgoing UDP to CAN and incoming CAN to UDP
# Copyright (c) 2024 SINTEF

import can
import cantools
from pathlib import Path
from site2 import site2
from stashh.outgoing import OutgoingCanService

if __name__ == "__main__":
  with can.Bus(interface='pcan', channel='PCAN_USBBUS1', bitrate=500000, receive_own_messages=True) as bus, site2.socket() as s:
    s.connect((site2.host, site2.cfg[1].port))
    db = cantools.database.load_file(
      Path(__file__).with_name('STASHH_FCCU_VCU_communication_20221123_v02.dbc')
    )

    print("Create StasHH outgoing CAN service...")
    canService = OutgoingCanService(bus, db, tscale=100)  # TODO: tscale=8
    canService.notifier()

    def receivedUDP(package: bytes, values: list) -> None:
      """Site2 outgoing UDP message has payload in values[4:6] (1 int, 1 float)"""
      control_bits = values[4]
      canService.dict_encode({
        "MG1IC_Setpoint_Mode_Req": control_bits & 0x1f,
        "MG1IC_Setpoint_Req": values[5],
        "HVESSC1_PowerDown_Command": (control_bits >> 5) & 0x3,
        "HVBI_Driveline_Availability": (control_bits >> 7) & 0xf,
      })
      if not canService.started():
        print("Start StasHH outgoing CAN service...")
        canService.start()
      signals = canService.received_signals
      vector = []
      try:  # Collecting vector to send back as incoming UDP
        vector = [(signals["MG1IMF1_Setpoint_Mode"] & 0x1f) | (signals["MG1IMF1_HVIL_Status"] << 5)]
        vector.extend(signals[n] for n in (
          "MG1IR1_Reference_Power", "MG1IR2_Reference_Current", "MG1IR2_Reference_Voltage",
          "MG1ILAP_DC_power_output_max", "MG1ILAP_DC_power_output_min",
          "MG1IS1_DC_current_output", "MG1IS1_DC_voltage_output"
        ))
      except KeyError:
        print("Not all incoming signals are available yet")
        return  # Wait for all incoming signals to become available
      print("Send incoming UDP")
      site2.send_message(s, 1, vector)

    print("Start Site2 outgoing UDP recieve loop...")
    site2.receive_loop(index=0, callback=receivedUDP)
