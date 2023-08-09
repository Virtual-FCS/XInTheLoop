# Receive or send Site1 protocol messages via UDP
# Copyright (c) 2021-2023 Virtual-FCS H2020
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

from pathlib import Path
from socket import socket, AF_INET, SOCK_DGRAM
from struct import pack, unpack
from sys import argv
from time import sleep

HOST = 'localhost'

# Tuple of outgoing (index=0) and incoming (index=1) values
PORT = (10002, 10001)
FORMAT = ('<2L2H1L3f', '<2L2H2B1H22f')
MAGIC = (0x53434656, 0x73636676)  # Little endian (b'VFCS', b'vfcs')
VER = (3, 3)
TYPES = ((int,) + 3*(float,), 3*(int,) + 22*(float,))

fname = Path(argv[0])
fname = fname.parent / ('_' + fname.name)

def savefile(direction : int, send_or_receive : int) -> Path:
  """Return Path object storing the last package."""
  return fname.with_suffix(f'.${direction}{send_or_receive}')

def savefile_seq(direction : int, send_or_receive : int) -> int:
  """Return sequence number of the last package or 0 if none."""
  try:
    return unpack(FORMAT[direction], savefile(direction, send_or_receive).read_bytes())[2]
  except:
    return 0

direction = argv[1] if len(argv) > 1 else 'i'
if not direction in ('i', 'in', 'o', 'out'):
  raise Exception(f'Usage: python3 {argv[0]} [[in|out] [payload vector [count [delta vector]]]]')
index = 1 if direction[0] == 'i' else 0

if len(argv) < 3:
  # Receiving packets
  with socket(AF_INET, SOCK_DGRAM) as s:
    s.bind((HOST, PORT[index]))
    while True:
      print(f"Listening for UDP package at {HOST}:{PORT[index]}")
      package, address = s.recvfrom(1024)
      print(f"Received {package.hex()} from {':'.join(str(e) for e in address)}")
      values = unpack(FORMAT[index], package)
      print(f"Unpacked values {values}")
      if values[0] == MAGIC[index] and values[1] == VER[index]:
        savefile(index, 1).write_bytes(package)
        print(f"seq=({values[2]}, {values[3]}), {values[4:]}")
      else:
        print("Error: Unknown magic number and/or version in header received!")

# Sending packets

values = tuple(t(argv[2+i] if 2+i < len(argv) else 1) for i, t in enumerate(TYPES[index] + (int,) + TYPES[index]))
median = len(values) // 2
n = values[median]
delta = values[median + 1:]
values = values[:median]
with socket(AF_INET, SOCK_DGRAM) as s:
  s.connect((HOST, PORT[index]))
  for i in range(n):
    vector = tuple(v + i * d for v, d in zip(values, delta))
    seq = 1 + savefile_seq(index, 0)  # Last sent seq in same direction.
    seq_rev = savefile_seq(1 - index, 1)  # Last received seq in reverse direction.
    package = pack(FORMAT[index], MAGIC[index], VER[index], seq, seq_rev, *vector)
    print(f'Sending({seq}, {seq_rev}) {vector} as {package.hex()} to {HOST}:{PORT[index]}')
    s.sendall(package)
    savefile(index, 0).write_bytes(package)
    sleep(1)
