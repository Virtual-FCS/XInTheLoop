within XInTheLoop.Examples;

package Site2 "Example Site 2 for Hardware-in-the-loop (HIL) simulation"
  extends Modelica.Icons.ExamplesPackage;

  model Test "Example model demonstrating sending an ASCII string to a TCP/IP service and receiving an answer"
    extends Modelica.Icons.Example;
    Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager annotation(
      Placement(visible = true, transformation(origin = {0, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddString addString(bufferSize = 20, data = "XqIDN?\r\n", nu = 1) annotation(
      Placement(visible = true, transformation(origin = {0, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    XInTheLoop.Blocks.Customized.TCPIP_Client_IO tCPIP_Client_IO(enableExternalTrigger = true, outputSendSize = Modelica.Utilities.Strings.length(addString.data), port = 4242) annotation(
      Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Sources.SampleTrigger sampleTrigger(period = 1, startTime = 1.5) annotation(
      Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetString getString(bufferSize = 80, nu = 1) annotation(
      Placement(visible = true, transformation(origin = {0, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.ResetPointer resetPointer annotation(
      Placement(visible = true, transformation(origin = {0, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Integer receivedLength;
  equation
    receivedLength = Modelica.Utilities.Strings.length(getString.data);
    when getString.pkgOut[1].trigger then
      Modelica.Utilities.Streams.print("sent: '" + addString.data + "' and received: '" + getString.data + "' (" + String(receivedLength) + " bytes)");
    end when;
    connect(packager.pkgOut, addString.pkgIn) annotation(
      Line(points = {{0, 70}, {0, 70}, {0, 50}, {0, 50}}));
    connect(addString.pkgOut[1], tCPIP_Client_IO.pkgIn) annotation(
      Line(points = {{0, 30}, {0, 30}, {0, 10}, {0, 10}}));
    connect(sampleTrigger.y, tCPIP_Client_IO.trigger) annotation(
      Line(points = {{-38, 0}, {-12, 0}, {-12, 0}, {-12, 0}}, color = {255, 0, 255}));
    connect(tCPIP_Client_IO.pkgOut, getString.pkgIn) annotation(
      Line(points = {{0, -10}, {0, -10}, {0, -30}, {0, -30}}));
    connect(getString.pkgOut[1], resetPointer.pkgIn) annotation(
      Line(points = {{0, -50}, {0, -50}, {0, -70}, {0, -70}}));
    annotation(
      experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.02),
      Documentation(info = "<html><head></head><body>A simple service for testing this model is <b>echo-server</b> that can be installed with this command (assuming Python is already installed):<pre>pip install echo-server</pre><div>and started with this command:</div><pre>echo-server 4242</pre></body></html>"));
  end Test;

  annotation(
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This example implements a protocol to exchange values with an external system running an ASCII/ANSI based telnet-like TCP/IP service.</span></body></html>"));
end Site2;
