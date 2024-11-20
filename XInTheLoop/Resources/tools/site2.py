# Receive or send Site2 protocol messages via UDP
# Copyright (c) 2021-2024 Virtual-FCS H2020
# Current Site2 outgoing protocol message (out from Modelica) contains:
# - Magic number as 4 bytes
# - Version number as 4 bytes unsigned integer
# - Sequence number as 2 bytes unsigned integer (expected to increment for each message)
# - Sequence number from last message in reverse direction as 2 bytes unsigned integer
# - 1x unsigned 4 bytes integer: Control flags requested (Setpoint_mode)
# - 1x 32 bit float: Setpoint_request ([A], [V], or [W])
# Current Site2 incoming protocol message (in to Modelica) contains:
# - Magic number as 4 bytes
# - Version number as 4 bytes unsigned integer
# - Sequence number as 2 bytes unsigned integer (expected to increment for each message)
# - Sequence number from last message in reverse direction as 2 bytes unsigned integer
# - 1x unsigned 4 bytes integer : Status bits (FCM_state, HVIL_status)
# - 7x 32 bit float: 
# All values in little-endian

# Usage to receive incoming messages:  python3 site2-protocol.py
# Usage to receive outgoing messages:  python3 site2-protocol.py out
# Usage to send one incoming message:  python3 site2-protocol.py in {1x uint32} {7x float}
# Usage to send 10 outgoing messages:  python3 site2-protocol.py out {1x uint32} {1x float} 10 {delta vector}
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
