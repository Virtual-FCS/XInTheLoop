# Common code for XInTheLoop protocol messages via UDP
# Copyright (c) 2021-2024 Virtual-FCS H2020
# Current common outgoing protocol message (out from Modelica) contains:
# - Magic number as 4 bytes
# - Version number as 4 bytes unsigned integer
# - Sequence number as 2 bytes unsigned integer (expected to increment for each message)
# - Sequence number from last message in reverse direction as 2 bytes unsigned integer
# - A number of unsigned 4 bytes integers
# - A number of 32 bit floats
# Current common incoming protocol message (in to Modelica) contains:
# - Magic number as 4 bytes
# - Version number as 4 bytes unsigned integer
# - Sequence number as 2 bytes unsigned integer (expected to increment for each message)
# - Sequence number from last message in reverse direction as 2 bytes unsigned integer
# - A number of unsigned 4 bytes integers
# - A number of 32 bit floats
# All values in little-endian

# Usage to receive incoming messages:  python3 siteX-protocol.py
# Usage to receive outgoing messages:  python3 siteX-protocol.py out
# Usage to send one incoming message:  python3 siteX-protocol.py in {?x uint32} {?x float}
# Usage to send 10 outgoing messages:  python3 siteX-protocol.py out {?x uint32} {?x float} 10 {delta vector}
#  Optional: Vector of delta values between each message in a series (default +1)
# Any missing values in the vectors are assumed to be 1 (default value)

from pathlib import Path
from socket import socket, AF_INET, SOCK_DGRAM
from struct import pack, unpack
from sys import argv
from time import sleep

class Config:
  """Configuration of outgoing or incoming messages."""
  def __init__(self, port: int, magic: int, ver: int, format: str, types: tuple):
    self.port = port
    self.magic = magic
    self.ver = ver
    self.format = '<2L2H' + format  # Initial little-endian, magic, ver, 2*seq
    self.types = types

class Protocol:
  """XIntheLoop protocol with a pair of outgoing and incoming message configurations."""
  def __init__(self, oconfig: Config, iconfig: Config):
    fname = Path(argv[0])
    self.fname = fname.parent / ('_' + fname.name)

    self.host = 'localhost'  # The only host supported for now

    # Tuple of outgoing (index=0) and incoming (index=1) values
    self.cfg = (oconfig, iconfig)

  def savefile(self, direction: int, send_or_receive: int) -> Path:
    """Return Path object storing the last package."""
    return self.fname.with_suffix(f'.${direction}{send_or_receive}')

  def savefile_seq(self, direction: int, send_or_receive: int) -> int:
    """Return sequence number of the last package or 0 if none."""
    try:
      return unpack(self.cfg[direction].format, self.savefile(direction, send_or_receive).read_bytes())[2]
    except:
      return 0

  def run(self):
    """Run one end (send or receive) of incoming/outgoing protocol"""
    direction = argv[1] if len(argv) > 1 else 'i'
    if not direction in ('i', 'in', 'o', 'out'):
      raise Exception(f'Usage: python3 {argv[0]} [[in|out] [payload vector [count [delta vector]]]]')
    index = 1 if direction[0] == 'i' else 0

    if len(argv) < 3:
      # Receiving packets
      with socket(AF_INET, SOCK_DGRAM) as s:
        s.bind((self.host, self.cfg[index].port))
        while True:
          print(f"Listening for UDP package at {self.host}:{self.cfg[index].port}")
          package, address = s.recvfrom(1024)
          print(f"Received {package.hex()} from {':'.join(str(e) for e in address)}")
          values = unpack(self.cfg[index].format, package)
          print(f"Unpacked values {values}")
          if values[0] == self.cfg[index].magic and values[1] == self.cfg[index].ver:
            self.savefile(index, 1).write_bytes(package)
            print(f"seq=({values[2]}, {values[3]}), {values[4:]}")
          else:
            print("Error: Unknown magic number and/or version in header received!")

    # Sending packets
    values = tuple(
      t(argv[2+i] if 2+i < len(argv) else 1)
      for i, t in enumerate(
        self.cfg[index].types + (int,) + self.cfg[index].types
      )
    )
    median = len(values) // 2
    n = values[median]
    delta = values[median + 1:]
    values = values[:median]
    with socket(AF_INET, SOCK_DGRAM) as s:
      s.connect((self.host, self.cfg[index].port))
      for i in range(n):
        vector = tuple(v + i * d for v, d in zip(values, delta))
        seq = 1 + self.savefile_seq(index, 0)  # Last sent seq in same direction.
        seq_rev = self.savefile_seq(1 - index, 1)  # Last received seq in reverse direction.
        package = pack(self.cfg[index].format, self.cfg[index].magic, self.cfg[index].ver, seq, seq_rev, *vector)
        print(f'Sending({seq}, {seq_rev}) {vector} as {package.hex()} to {self.host}:{self.cfg[index].port}')
        s.sendall(package)
        self.savefile(index, 0).write_bytes(package)
        sleep(1)
