within XInTheLoop.Blocks.Protocol;

block DecodeHead
  "Decode and validate head of incoming UDP X-in-the-loop protocol message"
  import ModelicaReference.Operators.'assert()';
  extends Icons.ProtocolHeadBlock;
  final constant Integer n = CreateHead.n "Protocol message head vector size";
  Modelica.Blocks.Interfaces.IntegerInput u[n]
    "Connector of protocol message head vector input"
    annotation (Placement(transformation(extent={{-130,-20},{-100,20}})));
  parameter Integer magicNumber = 1935894134;
  parameter Integer version = 1;
equation
  if not (u[1] == 0 and u[2] == 0) then
    assert(u[1] == magicNumber, "Unrecognized leading magic number");
    assert(u[2] == version, "Unrecognized version number");
  end if;
end DecodeHead;
