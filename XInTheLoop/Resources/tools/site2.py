# -*- coding: utf-8 -*-
# Receive or send Site2 protocol messages via UDP
# Copyright (c) 2021-2024 SINTEF
# Current Site2 outgoing protocol message (out from Modelica) contains:
# - Magic number as 4 bytes
# - Version number as 4 bytes unsigned integer
# - Sequence number as 2 bytes unsigned integer (expected to increment for each message)
# - Sequence number from last message in reverse direction as 2 bytes unsigned integer
# - 1x unsigned 4 bytes integer: Control flags requested
#    - MG1IC_Setpoint_Mode_Req [5-bit] {9728:10162},
#    - HVESSC1_PowerDown_Command [2-bit] {6912:8124},
#    - HVBI_Driveline_Availability [4-bit] {64363:20802},
# - 1x 32 bit float:
#    - MG1IC_Setpoint_Req [%] {9728:10163} (% of MG1IR1_Reference_Power, MG1IR2_Reference_Current, or MG1IR2_Reference_Voltage)
# Current Site2 incoming protocol message (in to Modelica) contains:
# - Magic number as 4 bytes
# - Version number as 4 bytes unsigned integer
# - Sequence number as 2 bytes unsigned integer (expected to increment for each message)
# - Sequence number from last message in reverse direction as 2 bytes unsigned integer
# - 1x unsigned 4 bytes integer : Status flags
#    - MG1IMF1_Setpoint_Mode [5-bit] {61825:10167},
#    - MG1IMF1_HVIL_Status [2-bit] {61825:9103},
# - 7x 32 bit float:
#    - MG1IR1_Reference_Power [kW] {64373:10172},
#    - MG1IR2_Reference_Current [A] {64371:10202}, MG1IR2_Reference_Voltage [V] {64371:10203},
#    - MG1ILAP_DC_power_output_max [%] {61826:10186}, MG1ILAP_DC_power_output_min [%] {61826:10187}, (% of MG1IR1_Reference_Power)
#    - MG1IS1_DC_current_output [%] {64372:10175}, MG1IS1_DC_voltage_output [%] {64372:9101},
# - Future additions?
#    - MG1IMT_Temperature_1 [°C] {64369:9059}, MG1IMT_Temperature_2 [°C] {64369:10220},
#    - MG1IMT_Temperature_3 [°C] {64369:10221}, MG1IMT_Temperature_4 [°C] {64369:10222},
# All values in little-endian

# Usage to receive incoming messages:  python3 site2.py
# Usage to receive outgoing messages:  python3 site2.py out
# Usage to send one incoming message:  python3 site2.py in {1x uint32} {7x float}
# Usage to send 10 outgoing messages:  python3 site2.py out {1x uint32} {1x float} 10 {delta vector}
#  Optional: Vector of delta values between each message in a series (default +1)
# Any missing values in the vectors are assumed to be 1 (default value)

from xil.common import Config, Protocol

site2 = Protocol(
  oconfig = Config(
    port = 10003,
    magic = 0x48535453, # Little endian b'STSH'
    ver = 1,
    format = '1L1f',
    types = 1*(int,) + 1*(float,),
  ),
  iconfig = Config(
    port = 10004,
    magic = 0x68737473, # Little endian b'stsh'
    ver = 1,
    format = '1L7f',
    types = 1*(int,) + 7*(float,)
  ),
)

if __name__ == "__main__":
  site2.run()
