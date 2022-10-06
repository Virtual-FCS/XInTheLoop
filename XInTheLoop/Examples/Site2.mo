within XInTheLoop.Examples;

package Site2 "Example Site 2 for Hardware-in-the-loop (HIL) simulation"
  extends Modelica.Icons.ExamplesPackage;

  model Test "Example model demonstrating sending an ASCII string to a TCP/IP service and receiving an answer"
    extends Modelica.Icons.Example;
    //constant String queries[:] = {"XqIDN?", "XqTagFull?", "XqNV($I)"} "Sequence of query strings";
    final constant String queries[:] = {"XrIDN=G17-1410", "XrTagFull=signal_in_anode_dewpoint_sensor@460@IN@signal_in_anode_dewpoint_sensor@DPM-411@NUM@0.00@\xb0C@0.00_100.00_2@;pressure_anode_cathode_diff@278@IN@pressure_anode_cathode_diff@Virtual@NUM@0.00@kPa@0.00_300.00_2@;system.state@176@IN/OUT@SystemState@Virtual@ENUM@0@RESET:-2,ESTOP:-1,OFF:0,INIT:2,SETUP:3,LB-CTRL:4@@;current_set@264@OUT@current_set@Virtual@NUM@0.00@A@0.00_800.00_2@"} "Sequence of query strings";
    String currentQuery;
    Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager annotation(
      Placement(visible = true, transformation(origin = {0, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddString addString(bufferSize = 200, data = currentQuery + "\r\n", nu = 1) annotation(
      Placement(visible = true, transformation(origin = {0, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    XInTheLoop.Blocks.Customized.TCPIP_Client_IO tCPIP_Client_IO(enableExternalTrigger = true, outputSendSize = Modelica.Utilities.Strings.length(addString.data), port = 4242) annotation(
      Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Sources.SampleTrigger sampleTrigger(period = 1, startTime = 1.5) annotation(
      Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetString getString(bufferSize = 80, nu = 1) annotation(
      Placement(visible = true, transformation(origin = {0, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    XInTheLoop.Blocks.Customized.ResetPointer resetPointer annotation(
      Placement(visible = true, transformation(origin = {0, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Integer receivedLength;
    XInTheLoop.Examples.Site2.Blocks.ProcessResponse processResponse(query = currentQuery, response = getString.data, enableExternalTrigger = true, nout = 2) annotation(
      Placement(visible = true, transformation(origin = {30, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.MathInteger.TriggeredAdd triggeredAdd(y_start = 1) annotation(
      Placement(visible = true, transformation(origin = {60, -60}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  equation
    currentQuery = queries[min(triggeredAdd.y, size(queries, 1))];
    receivedLength = Modelica.Utilities.Strings.length(getString.data);
    when resetPointer.outputTrigger then
/*getString.pkgOut[1].trigger*/
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
    connect(resetPointer.outputTrigger, processResponse.trigger) annotation(
      Line(points = {{12, -80}, {30, -80}, {30, -52}}, color = {255, 0, 255}));
    connect(resetPointer.outputTrigger, triggeredAdd.trigger) annotation(
      Line(points = {{12, -80}, {56, -80}, {56, -67}}, color = {255, 0, 255}));
    annotation(
      experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.02),
      Documentation(info = "<html><head></head><body>A simple service for testing this model is <b>echo-server</b> that can be installed with this command (assuming Python is already installed):<pre>pip install echo-server</pre><div>and started with this command:</div><pre>echo-server 4242</pre></body></html>"));
  end Test;

  package Blocks "Site2-Specific Blocks"
    extends Icons.BlocksPackage;

    block ProcessResponse
      extends Modelica.Blocks.Interfaces.MO;
      extends Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
      input String query "Last query" annotation(
        Dialog(enable = true));
      input String response "Query response to process" annotation(
        Dialog(enable = true));
      output String results[nout];
    equation
      y[1] = 0;
      y[2] = 0;
      when actTrigger then
        (results[1], results[2]) = XInTheLoop.Examples.Site2.Functions.scanResponse(query, response);
      end when;
    end ProcessResponse;
  end Blocks;

  package Functions
    extends Modelica.Icons.FunctionsPackage;

    function scanResponse
      extends Modelica.Icons.Function;
      //parameter String tags[:] = {""} "Tags to look for in the response";
      input String query "Last query";
      input String response "Query response to be scanned";
      output String responseId "ID left of equal sign";
      output String value "Value right of equal sign";
      //output String
    protected
      Integer pos;
      Integer count;
      //String temp;
    algorithm
      Modelica.Utilities.Streams.print("scanResponse('" + response + "')");
      pos := Modelica.Utilities.Strings.find(response, "=");
      Modelica.Utilities.Streams.print("scanResponse(): pos('=')=" + String(pos));
      if pos > 0 then
        responseId := Modelica.Utilities.Strings.substring(response, 1, pos);
        count := 1 + Modelica.Utilities.Strings.count(response, ";", pos + 1);
        Modelica.Utilities.Streams.print("scanResponse(): 1+count(';')=" + String(count));
        value := Modelica.Utilities.Strings.substring(response, pos + 1, Modelica.Utilities.Strings.length(response));
      else
        responseId := response;
        count := 0;
        value := "";
      end if;
//for i in 1:count loop
//end loop;
      Modelica.Utilities.Streams.print("scanResponse(): value='" + value + "'");
    end scanResponse;
  end Functions;
  annotation(
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This example implements a protocol to exchange values with an external system running an ASCII/ANSI based telnet-like TCP/IP service.</span></body></html>"));
end Site2;
