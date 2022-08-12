within XInTheLoop.Blocks.Protocol;

block CreateHead
  "Create valid head of outgoing UDP X-in-the-loop protocol message"
  extends Icons.ProtocolHeadBlock;
  final constant Integer n = 2 "Protocol message head vector size";
  Modelica.Blocks.Interfaces.IntegerOutput y[n]
    "Connector of protocol message head vector output" annotation (
      Placement(transformation(extent={{100,-10},{120,10}})));
  parameter Integer magicNumber = 1396917846;
  parameter Integer version = 1;
equation
  y[1] = magicNumber;
  y[2] = version;
end CreateHead;
