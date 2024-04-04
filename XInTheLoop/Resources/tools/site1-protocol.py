# Receive or send Site1 protocol messages via UDP
# Copyright (c) 2021-2024 Virtual-FCS H2020
# Current Site1 outgoing protocol message (out from Modelica) contains:
# - Magic number as 4 bytes
# - Version number as 4 bytes unsigned integer
# - Sequence number as 2 bytes unsigned integer (expected to increment for each message)
# - Sequence number from last message in reverse direction as 2 bytes unsigned integer
# - 1x unsigned 4 bytes integer: Control flags requested (RemoteControl, KeyOn, StartButton, LoadSequence, ExternalEms)
# - 3x 32 bit float: DcDc_SP_add [A], Load_SP_req [W], DcDc_SP_ems [A]
# Current Site1 incoming protocol message (in to Modelica) contains:
# - Magic number as 4 bytes
# - Version number as 4 bytes unsigned integer
# - Sequence number as 2 bytes unsigned integer (expected to increment for each message)
# - Sequence number from last message in reverse direction as 2 bytes unsigned integer
# - 2x unsigned bytes: Mode_DcDc, Mode_FCM
# - 1x unsigned 2 bytes integer : Status flags (including control flags actually in use)
#   (RemoteControl, KeyOn, StartButton, LoadSequence, Ready, H2Supply, FMCHeartbeat,
#    DcDcOk, Warning, Alarm, BatteryRelay, DcDcRelay, ModelicaHeartbeat, ExternalEms)
# - 22x 32 bit float: DcDc_SP [A], Load_SP [W], (both are SP actually in use)
#                     V_Stack [V], I_Stack [A], T_Stack_In [C], T_Stack_Out [C],
#                     V_Batt [V], I_Batt [A], SOC [1], T_Batt [C],
#                     V_In_DcDc [V], I_In_DcDc [A], V_Out_DcDc [V], I_Out_DcDc [A],
#                     V_Load [V], I_Load [A],
#                     P_StackFuel_In [Pa], P_StackAir_In [Pa], P_0 [Pa], (all as absolute pressure)
#                     H2_Mass [kg], H2_Flow [kg/s],
#                     P_H2_Supply [Pa], (as absolute pressure)
# All values in little-endian

# Usage to receive incoming messages:  python3 site1-protocol.py
# Usage to receive outgoing messages:  python3 site1-protocol.py out
# Usage to send one incoming message:  python3 site1-protocol.py in {2x uint8} {1x uint16} {22x float}
# Usage to send 10 outgoing messages:  python3 site1-protocol.py out {1x uint} {3x float} 10 {delta vector}
#  Optional: Vector of delta values between each message in a series (default +1)
# Any missing values in the vectors are assumed to be 1 (default value)

from xil.common import Config, Protocol

site1 = Protocol(
  oconfig = Config(
    port = 10002,
    magic = 0x53434656, # Little endian b'VFCS'
    ver = 3,
    format = '1L3f',
    types = (int,) + 3*(float,),
  ),
  iconfig = Config(
    port = 10001,
    magic = 0x73636676, # Little endian b'vfcs'
    ver = 3,
    format = '2B1H22f',
    types = 3*(int,) + 22*(float,)
  ),
)

site1.run()
