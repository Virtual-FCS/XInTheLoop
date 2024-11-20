within XInTheLoop.Examples;

package Site2 "Example Site 2 for Hardware-in-the-loop (HIL) simulation"
  extends Modelica.Icons.ExamplesPackage;

  model Test "Example model demonstrating exchanging values with this HIL site using a simple pattern of time varying data as input"
    extends Modelica.Icons.Example;
  XInTheLoop.Examples.Site2.Blocks.Sync sync annotation(
      Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  XInTheLoop.Examples.Site2.Blocks.UnpackStatusBits unpackStatusBits annotation(
      Placement(visible = true, transformation(origin = {40, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  XInTheLoop.Examples.Site2.Blocks.PackControlBits packControlBits annotation(
      Placement(visible = true, transformation(origin = {-30, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(sync.yStatusBits, unpackStatusBits.u) annotation(
      Line(points = {{14, 12}, {14, 22}, {28, 22}}, color = {255, 127, 0}));
    connect(packControlBits.y, sync.uControlBits) annotation(
      Line(points = {{-19, 10}, {-9.5, 10}, {-9.5, 6}, {-2, 6}}, color = {255, 127, 0}));
  protected
    annotation(
      experiment(StartTime = 0, StopTime = 60, Tolerance = 1e-06, Interval = 0.1),
      Documentation(info = "<html><head></head><body>
A test model that creates a very&nbsp;simple input value sequence with a duration of 60 seconds that sends request of these modes to the FCM:
<div><ul>
<li>Start-up (idle)</li><li>Standby</li>
<li>Starting</li><li>Running</li>
<li>Stopping</li></ul>
<div>It is used in the <b>Dry Run</b> test procedure of <a href=\"modelica://XInTheLoop.Examples.Site1\">this site</a>.</div></div>
</body></html>"));
  end Test;

  package Blocks "Site1-Specific Blocks"
    extends Icons.BlocksPackage;

    block Sync "Example HIL block to exchange values with this site"
      extends Icons.HardwareInTheLoopBlock;
      import XInTheLoop.Functions.bitmask;
      Modelica.Blocks.Interfaces.IntegerInput uControlBits annotation(
        Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      XInTheLoop.Blocks.Protocol.UDPSync uDPSync(nFloatsIn = 7, nFloatsOut = 1, port_recv = 10004, port_send = 10003, real_time = true, vIn = 1, vOut = 1) annotation(
        Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.MathInteger.Sum sum(k = {1, -1}, nu = 2) annotation(
        Placement(visible = true, transformation(origin = {10, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      XInTheLoop.Blocks.Bitwise.AndInts andBitmask(b = bitmask(uDPSync.wSeq), nu = 1) annotation(
        Placement(visible = true, transformation(origin = {10, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Modelica.Blocks.Interfaces.IntegerOutput ySeqOutAhead "Difference between the sequence number to be sent and the last reverse sequence number received" annotation(
        Placement(visible = true, transformation(origin = {10, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {10, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Modelica.Blocks.Interfaces.RealInput uSetpoint_Req annotation(
        Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.IntegerOutput yStatusBits annotation(
        Placement(visible = true, transformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Modelica.Blocks.Interfaces.RealOutput yReference_Power annotation(
        Placement(visible = true, transformation(origin = {110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput yReference_Current annotation(
        Placement(visible = true, transformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput yReference_Voltage annotation(
        Placement(visible = true, transformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput yDC_power_output_max annotation(
        Placement(visible = true, transformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput yDC_power_output_min annotation(
        Placement(visible = true, transformation(origin = {110, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput yDC_current_output annotation(
        Placement(visible = true, transformation(origin = {110, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput yDC_voltage_output annotation(
        Placement(visible = true, transformation(origin = {110, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(uControlBits, uDPSync.uIntegers[1]) annotation(
        Line(points = {{-120, 60}, {-60, 60}, {-60, 0}, {-52, 0}}, color = {255, 127, 0}));
      connect(uSetpoint_Req, uDPSync.uFloats[1]) annotation(
        Line(points = {{-120, 0}, {-70, 0}, {-70, -6}, {-52, -6}}, color = {0, 0, 127}));
      connect(uDPSync.ySeqOut, sum.u[1]) annotation(
        Line(points = {{-29, 8}, {6, 8}, {6, 20}, {10, 20}}, color = {255, 127, 0}));
      connect(uDPSync.ySeqRev, sum.u[2]) annotation(
        Line(points = {{-29, 0}, {14, 0}, {14, 20}, {10, 20}}, color = {255, 127, 0}));
      connect(sum.y, andBitmask.u[1]) annotation(
        Line(points = {{10, 42}, {10, 42}, {10, 60}, {10, 60}}, color = {255, 127, 0}));
      connect(andBitmask.y, ySeqOutAhead) annotation(
        Line(points = {{10, 82}, {10, 82}, {10, 110}, {10, 110}}, color = {255, 127, 0}));
      connect(uDPSync.yIntegers[1], yStatusBits) annotation(
        Line(points = {{-29, -4}, {40, -4}, {40, 110}}, color = {255, 127, 0}));
      connect(uDPSync.yFloats[1], yReference_Power) annotation(
        Line(points = {{-29, -8}, {80, -8}, {80, 90}, {110, 90}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[2], yReference_Current) annotation(
        Line(points = {{-29, -8}, {80, -8}, {80, 70}, {110, 70}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[3], yReference_Voltage) annotation(
        Line(points = {{-29, -8}, {80, -8}, {80, 50}, {110, 50}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[4], yDC_power_output_max) annotation(
        Line(points = {{-29, -8}, {80, -8}, {80, 30}, {110, 30}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[5], yDC_power_output_min) annotation(
        Line(points = {{-28, -8}, {80, -8}, {80, 10}, {110, 10}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[6], yDC_current_output) annotation(
        Line(points = {{-28, -8}, {80, -8}, {80, -10}, {110, -10}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[7], yDC_voltage_output) annotation(
        Line(points = {{-28, -8}, {80, -8}, {80, -32}, {110, -32}}, color = {0, 0, 127}));
      annotation(
        Documentation(info = "<html><head></head><body>Sync outgoing values to and incoming values from an example external Site 1 using a UDP protocol.</body></html>"));
    end Sync;

    block PackControlBits "Pack all control bits into an integer"
      extends Modelica.Blocks.Interfaces.IntegerSO;
      extends XInTheLoop.Blocks.Bitwise.Icons.BitPack;
      Modelica.Blocks.Interfaces.IntegerInput uSetpoint_Mode_Req(min=0, max=31) annotation(
        choices(choice=0 "Power On", choice=2 "Standby", choice=9 "Voltage Control",
        choice=10 "Current Control", choice=11 "Power Control", choice=20 "Stop", choice=21 "Power Down" ),
        Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 90}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.IntegerInput uPowerDown_Command(min=0, max=3) annotation(
        Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 44}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.IntegerInput uDriveline_Availability(min=0, max=15) annotation(
        Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      XInTheLoop.Blocks.Bitwise.PackInt packInt(nu = 5, n_bits = {5, 2, 4}) annotation(
        Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(uSetpoint_Mode_Req, packInt.u[1]) annotation(
        Line(points = {{-120, 80}, {-40, 80}, {-40, 4}, {-10, 4}, {-10, 0}}, color = {255, 127, 0}));
      connect(uPowerDown_Command, packInt.u[2]) annotation(
        Line(points = {{-120, 40}, {-60, 40}, {-60, 2}, {-10, 2}, {-10, 0}}, color = {255, 127, 0}));
      connect(uDriveline_Availability, packInt.u[3]) annotation(
        Line(points = {{-120, 0}, {-10, 0}}, color = {255, 127, 0}));
      connect(packInt.y, y) annotation(
        Line(points = {{12, 0}, {104, 0}, {104, 0}, {110, 0}}, color = {255, 127, 0}));
      annotation(
        Documentation(info = "<html><head></head><body>
Pack all control bits into an integer output.
</body></html>"));
    end PackControlBits;

    block UnpackStatusBits "Unpack all status bits from an integer"
      extends Modelica.Blocks.Icons.IntegerBlock;
      extends XInTheLoop.Blocks.Bitwise.Icons.BitUnpack;
      Modelica.Blocks.Interfaces.IntegerInput u annotation(
        Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      XInTheLoop.Blocks.Bitwise.UnpackInt unpackInt(n_bits = {5, 2}) annotation(
        Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput ySetpoint_Mode annotation(
        Placement(visible = true, transformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput yHVIL_Status annotation(
        Placement(visible = true, transformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(u, unpackInt.u) annotation(
        Line(points = {{-120, 0}, {-14, 0}, {-14, 0}, {-12, 0}}, color = {255, 127, 0}));
      connect(unpackInt.y[1], ySetpoint_Mode) annotation(
        Line(points = {{12, 0}, {60, 0}, {60, 50}, {110, 50}}, color = {255, 127, 0}));
      connect(unpackInt.y[2], yHVIL_Status) annotation(
        Line(points = {{12, 0}, {60, 0}, {60, -50}, {110, -50}}, color = {255, 127, 0}));
      annotation(
        Documentation(info = "<html><head></head><body>
Unpack all status bits from an integer input.
</body></html>"));
    end UnpackStatusBits;

    block SelectSetpointMode
      parameter Boolean useHeatPort=false annotation(choices(checkBox=true));
      parameter Integer selectSetpointMode(min=0, max=31) annotation(choices(
      choice=0 "Power On", choice=2 "Standby", choice=9 "Voltage Control", choice=10 "Current Control",
      choice=11 "Power Control", choice=20 "Stop", choice=21 "Power Down" ));
  Modelica.Blocks.Interfaces.IntegerOutput ySetpoint_Mode annotation(
        Placement(visible = true, transformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      ySetpoint_Mode = selectSetpointMode;
    end SelectSetpointMode;
  end Blocks;
  annotation(
    Documentation(info = "<html><head></head><body>
This example implements a UDP protocol to exchange values with an external system running a StasHH compatible fuel cell module (FCM).
<h4 id=\"tool\">Python Tool</h4>
In both the <a href=\"#dry\">Dry Run</a> and the <a href=\"#wet\">Wet Run</a> sections below, the same Python tool is used. It is assumed your PC has Python (version 3 or above) installed. If not, it can be installed from the Microsoft Store App.

The Python files&nbsp;<tt>site2*.py</tt>&nbsp;is located in the <tt>XInTheLoop/Resources/tools/</tt> folder - where <a href=\"modelica://XInTheLoop\">this library</a> is installed or cloned from github.

<h4 id=\"dry\">Dry Run</h4>
To test this without a real hardware I/O application present, use the <a href=\"#tool\">Python tool included in the tools folder</a>.

<ol>
<li>Open a command shell window, and change to the tools&nbsp;folder. The Python file should now be shown if executing a <tt>dir</tt> command.</li>

<li>To capture and dump the outgoing values sent to the external system, execute

<pre style=\"font-size: 12px;\">python3 site2.py out</pre>

</li><li>Open a second command shell window, and change to the tools&nbsp;folder. This preparation step should be done before starting simulation to reduce time usage during simulation.</li>

<li>Start simulation of the <a href=\"modelica://XInTheLoop.Examples.Site2.Test\">Test</a> model.</li>

<li>When the compilation is finished and the simulation has started, execute e.g.

<pre style=\"font-size: 12px;\">python3 site2.py in 2 3 4 5 6 7 8 9 50</pre>

in the second shell window to send a series of 50 incoming messages while the simulation is running. In the command line example above, the first message will contain a payload vector of the specified dummy values, and then for each of the 50 repetitions, all values in the payload vector are incremented before sending the next message after a one second delay.</li>

<li>When the simulation has ended, select e.g. the variables sync.yDC_current_output and sync.yDC_voltage_output to plot these received values in a graph of the simulation.</li>

</ol>

TODO: img src=\"modelica://XInTheLoop/Resources/Images/site2-test-plot.png\"

<h4 id=\"wet\">Wet Run</h4>
<div>To test this against a real StasHH FCM hardware, it must be connected to the same CAN bus as also available via a CAN adapter at the same PC as running OpenModelica and the site2-relay process that acts like a UDP service abstraction layer above the actual hardware or external system. The Python script implementation used for the dry run above is part of such a service.</div><div><br></div><div>TODO: Expand description.</div><div><br></div><ol>

</ol><h4>Protocol Packet Details</h4><div>In each UDP packet sent in this protocol there is a leading header:</div><div><ol><li>A constant 32-bit \"magic\" integer number to reduce the risk of interpreting a random missent packet from another application as a valid packet in this protocol.</li><li>A 32-bit integer version number that should be increased when the packet format is changed in a way that is not backward compatible. If only appending new values to the packet payload format, then the version number normally does not need to change because extra content at the end should be ignored by the receiver.</li><li>A 16-bit integer packet sequence number incremented by the sender for each packet. The counter is independent for each direction. When a counter value exceeds 16 bits, it wraps around to zero again.</li><li>A 16-bit integer received packet sequence number containing a copy of the packet sequence number from the last received packet in the reverse direction. In the Python script of this example, the last packet in each direction is written to temporary files to remember these sequence numbers, but in a typical hardware/external I/O application, it normally is much easier to use internal variables instead.</li></ol><div>followed by a payload:</div></div><div><ol><li>A vector of 32-bit integer values.</li><li>A vector of 32-bit float values.</li></ol><div>All values are stored as little endian. A protocol implementation for one particular external system will need a fixed packet format in each direction. For each direction, all of these must be defined:</div></div><div><ul><li>Address/IP (in this example, localhost is assumed) and port of the receiving end.</li><li>Header version number.</li><li>Payload vector sizes.</li><li>Meta information for each value in the payload vectors.</li></ul></div>
</body></html>"));
end Site2;
