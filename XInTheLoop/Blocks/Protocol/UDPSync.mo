within XInTheLoop.Blocks.Protocol;

model UDPSync
  "Generic UDP based protocol to exchange values with an external system"
  extends Modelica.Blocks.Icons.Block;
  import SI = Modelica.Units.SI;
  parameter Boolean real_time=true
   "true, if real-time synchronization is enabled, otherwise it is disabled!"
   annotation(choices(checkBox=true));
  parameter SI.Period sampleTime=0.1 "Sample period of UDP sync packets";
  parameter Integer wSeq=16 "Number of bits in packet sequence numbers";
  parameter String IPAddress="127.0.0.1" "IP address of the remote UDP server"
    annotation (Dialog(group="Outgoing data"));
  parameter Integer port_send=10002 "Target port of the receiving UDP server"
    annotation (Dialog(group="Outgoing data"));
  parameter Integer vOut=2 "Packet header version out from Modelica"
    annotation (Dialog(group="Outgoing data"));
  parameter Integer nIntsOut=1 "Number of integer values out from Modelica"
    annotation (Dialog(group="Outgoing data"));
  parameter Integer nFloatsOut=2 "Number of float values out from Modelica"
    annotation (Dialog(group="Outgoing data"));
  parameter Integer port_recv=10001
    "Listening port number of the server. Must be unique on the system"
    annotation (Dialog(group="Incoming data"));
  parameter Integer vIn=2 "Packet header version in to Modelica"
    annotation (Dialog(group="Incoming data"));
  parameter Integer nIntsIn = 1 "Number of integer values in to Modelica"
    annotation (Dialog(group="Incoming data"));
  parameter Integer nFloatsIn=1 "Number of float values in to Modelica"
    annotation (Dialog(group="Incoming data"));
  Modelica.Blocks.Interfaces.IntegerInput uIntegers[nIntsOut] annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uFloats[nFloatsOut] annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  CreateHead createHead(version = vOut) annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerExpression increment(y = 1) annotation(
    Placement(visible = true, transformation(origin = {-90, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathInteger.TriggeredAdd triggeredAdd annotation(
    Placement(visible = true, transformation(origin = {-66, 40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager annotation(
    Placement(visible = true, transformation(origin = {-10, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddInteger addHead(n = createHead.n, nu = 1) annotation(
    Placement(visible = true, transformation(origin = {-40, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.PackUnsignedInteger packSeq(nu = 1, width = wSeq) annotation(
    Placement(visible = true, transformation(origin = {-40, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.PackUnsignedInteger packSeqReverse(nu = 1, width = wSeq) annotation(
    Placement(visible = true, transformation(origin = {-40, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddInteger addInteger(n = nIntsOut, nu = 1)  annotation(
    Placement(visible = true, transformation(origin = {-40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat(n = nFloatsOut, nu = 1) annotation(
    Placement(visible = true, transformation(origin = {-40, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Customized.UDPSendTrig uDPSend(IPAddress = IPAddress, autoBufferSize = true, port_send = port_send, sampleTime = sampleTime)  annotation(
    Placement(visible = true, transformation(origin = {-20, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.Blocks.OperatingSystem.RealtimeSynchronize realtimeSynchronize(enable = real_time)  annotation(
    Placement(visible = true, transformation(origin = {0, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.Blocks.Communication.UDPReceive uDPReceive(autoBufferSize = true, port_recv = port_recv, sampleTime = sampleTime, useRecvThread = true)  annotation(
    Placement(visible = true, transformation(origin = {20, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetInteger getHead(n = decodeHead.n, nu = 1) annotation(
    Placement(visible = true, transformation(origin = {50, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger unpackSeq(nu = 1, width = wSeq) annotation(
    Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger unpackSeqReverse(nu = 1, width = wSeq) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetInteger getInteger(n = nIntsIn, nu = 1)  annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetFloat getFloat(n = nFloatsIn) annotation(
    Placement(visible = true, transformation(origin = {50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DecodeHead decodeHead(version = vIn) annotation(
    Placement(visible = true, transformation(origin = {80, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput ySeqOut "Outgoing packet sequence number to be sent" annotation(
    Placement(visible = true, transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput ySeqIn "Last received incoming packet sequence number" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput ySeqRev "Last received packet sequence number at the other end" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput yIntegers[nIntsIn] annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput yFloats[nFloatsIn] annotation(
    Placement(visible = true, transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(packager.pkgOut, addHead.pkgIn) annotation(
    Line(points = {{-21, 90}, {-40, 90}, {-40, 81}}));
  connect(addHead.pkgOut[1], packSeq.pkgIn) annotation(
    Line(points = {{-40, 59}, {-40, 51}}));
  connect(packSeq.pkgOut[1], packSeqReverse.pkgIn) annotation(
    Line(points = {{-40, 29}, {-40, 21}}));
  connect(packSeqReverse.pkgOut[1], addInteger.pkgIn) annotation(
    Line(points = {{-40, 0}, {-40, 0}, {-40, -20}, {-40, -20}}));
  connect(addInteger.pkgOut[1], addFloat.pkgIn) annotation(
    Line(points = {{-40, -40}, {-40, -40}, {-40, -50}, {-40, -50}}));
  connect(addFloat.pkgOut[1], uDPSend.pkgIn) annotation(
    Line(points = {{-40, -71}, {-40, -90}, {-31, -90}}));
  connect(uDPReceive.pkgOut, getHead.pkgIn) annotation(
    Line(points = {{31, 90}, {50, 90}, {50, 81}}));
  connect(getHead.pkgOut[1], unpackSeq.pkgIn) annotation(
    Line(points = {{50, 59}, {50, 51}}));
  connect(unpackSeq.pkgOut[1], unpackSeqReverse.pkgIn) annotation(
    Line(points = {{50, 29}, {50, 11}}));
  connect(unpackSeqReverse.pkgOut[1], getInteger.pkgIn) annotation(
    Line(points = {{50, -11}, {50, -29}}));
  connect(getInteger.pkgOut[1], getFloat.pkgIn) annotation(
    Line(points = {{50, -51}, {50, -69}}));
  connect(createHead.y, addHead.u) annotation(
    Line(points = {{-59, 70}, {-52, 70}}, color = {255, 127, 0}, thickness = 0.5));
  connect(getHead.y, decodeHead.u) annotation(
    Line(points = {{61, 70}, {68.5, 70}}, color = {255, 127, 0}, thickness = 0.5));
  connect(increment.y, triggeredAdd.u) annotation(
    Line(points = {{-79, 40}, {-74, 40}}, color = {255, 127, 0}));
  connect(triggeredAdd.y, ySeqOut) annotation(
    Line(points = {{-58, 40}, {-56, 40}, {-56, 54}, {94, 54}, {94, 80}, {110, 80}, {110, 80}}, color = {255, 127, 0}));
  connect(triggeredAdd.y, packSeq.u) annotation(
    Line(points = {{-59, 40}, {-52, 40}}, color = {255, 127, 0}));
  connect(unpackSeq.y, ySeqIn) annotation(
    Line(points = {{62, 40}, {110, 40}}, color = {255, 127, 0}));
  connect(unpackSeq.y, packSeqReverse.u) annotation(
    Line(points = {{61, 40}, {70.75, 40}, {70.75, 24}, {-60, 24}, {-60, 10}, {-52, 10}}, color = {255, 127, 0}));
  connect(unpackSeqReverse.y, ySeqRev) annotation(
    Line(points = {{61, 0}, {110, 0}}, color = {255, 127, 0}));
  connect(uIntegers, addInteger.u) annotation(
    Line(points = {{-120, 0}, {-80, 0}, {-80, -30}, {-52, -30}}, color = {255, 127, 0}));
  connect(getInteger.y, yIntegers) annotation(
    Line(points = {{61, -40}, {110, -40}}, color = {255, 127, 0}));
  connect(uFloats, addFloat.u) annotation(
    Line(points = {{-120, -60}, {-52, -60}}, color = {0, 0, 127}));
  connect(getFloat.y, yFloats) annotation(
    Line(points = {{61, -80}, {110, -80}}, color = {0, 0, 127}));
  connect(uDPSend.outputTrigger, triggeredAdd.trigger) annotation(
    Line(points = {{-8, -90}, {-2, -90}, {-2, -12}, {-70, -12}, {-70, 33}}, color = {255, 0, 255}));
annotation(
    Icon(graphics = {Text(origin = {-29, 1}, extent = {{-67, 9}, {29, -11}}, textString = "%nIntsOut i", horizontalAlignment = TextAlignment.Left), Text(origin = {-29, -59}, extent = {{-67, 9}, {29, -11}}, textString = "%nFloatsOut f", horizontalAlignment = TextAlignment.Left), Text(origin = {71, -39}, extent = {{-71, 9}, {25, -11}}, textString = "%nIntsIn i", horizontalAlignment = TextAlignment.Right), Text(origin = {71, -79}, extent = {{-71, 9}, {25, -11}}, textString = "%nFloatsIn f", horizontalAlignment = TextAlignment.Right), Text(origin = {71, 81}, extent = {{-167, 15}, {25, -11}}, textString = "v%vOut   →", horizontalAlignment = TextAlignment.Right), Text(origin = {71, 41}, extent = {{-167, 15}, {25, -11}}, textString = "v%vIn   ←", horizontalAlignment = TextAlignment.Right), Text(origin = {71, 1}, extent = {{-69, 15}, {25, -11}}, textString = "↔", horizontalAlignment = TextAlignment.Right)}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">Sync outgoing values to and incoming values from an external system using a binary UDP protocol with constant headers and incrementing sequence numbers. Specify the number of payload </span><span style=\"font-size: 12px;\">integers and floats in both directions as parameters.</span></body></html>"));
end UDPSync;
