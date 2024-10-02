within XInTheLoop.Examples;

package Site2 "Example Site 2 for Hardware-in-the-loop (HIL) simulation"
  extends Modelica.Icons.ExamplesPackage;

  model Test "Example model demonstrating exchanging values with this HIL site using a simple pattern of time varying data as input"
    extends Modelica.Icons.Example;

    inner Modelica.StateGraph.StateGraphRoot stateGraphRoot annotation(
      Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.MathInteger.MultiSwitch modeRequest(expr = {0, 2, 10, 10, 21}, nu = 5, use_pre_as_default = true) annotation(
      Placement(visible = true, transformation(origin = {56, -26}, extent = {{-10, -10}, {30, 10}}, rotation = 0)));
    Modelica.StateGraph.InitialStepWithSignal idle(nOut = 1, nIn = 1) annotation(
      Placement(visible = true, transformation(origin = {-84, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.StateGraph.Transition toIdle(enableTimer = true, waitTime = 9)  annotation(
      Placement(visible = true, transformation(origin = {92, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.StateGraph.StepWithSignal stopping(nIn = 1, nOut = 1) annotation(
      Placement(visible = true, transformation(origin = {72, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.StateGraph.Transition toStopping(enableTimer = true, waitTime = 300)  annotation(
      Placement(visible = true, transformation(origin = {52, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.StateGraph.StepWithSignal running(nIn = 1, nOut = 1)  annotation(
      Placement(visible = true, transformation(origin = {34, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.StateGraph.Transition toRunning(enableTimer = true, waitTime = 60)  annotation(
      Placement(visible = true, transformation(origin = {14, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.StateGraph.StepWithSignal starting(nIn = 1, nOut = 1)  annotation(
      Placement(visible = true, transformation(origin = {-4, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.StateGraph.TransitionWithSignal toStarting(enableTimer = true, waitTime = 120)  annotation(
      Placement(visible = true, transformation(origin = {-24, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.StateGraph.StepWithSignal standby(nIn = 1, nOut = 1) annotation(
      Placement(visible = true, transformation(origin = {-44, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.StateGraph.Transition toStandby(enableTimer = true, waitTime = 3)  annotation(
      Placement(visible = true, transformation(origin = {-64, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.BooleanExpression alwaysTrue(y = true)  annotation(
      Placement(visible = true, transformation(origin = {-30, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    XInTheLoop.Examples.Site2.Blocks.Sync sync annotation(
      Placement(visible = true, transformation(origin = {10, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    XInTheLoop.Examples.Site2.Blocks.UnpackStatusBits unpackStatusBits annotation(
      Placement(visible = true, transformation(origin = {40, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    XInTheLoop.Examples.Site2.Blocks.PackControlBits packControlBits annotation(
      Placement(visible = true, transformation(origin = {-30, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.IntegerExpression HVESSC1_PowerDown_Command annotation(
      Placement(visible = true, transformation(origin = {-84, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.IntegerExpression HVBI_Driveline_Availability(y = 1)  annotation(
      Placement(visible = true, transformation(origin = {-84, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.RealExpression MG1IC_Setpoint_Req(y = 25.0)  annotation(
      Placement(visible = true, transformation(origin = {-50, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(alwaysTrue.y, toStarting.condition) annotation(
      Line(points = {{-18, -10}, {-12, -10}, {-12, 6}, {-24, 6}, {-24, 18}}, color = {255, 0, 255}));
    connect(toStandby.outPort, standby.inPort[1]) annotation(
      Line(points = {{-62.5, 30}, {-54.5, 30}}));
    connect(idle.outPort[1], toStandby.inPort) annotation(
      Line(points = {{-73.5, 30}, {-67.5, 30}}));
    connect(toStopping.outPort, stopping.inPort[1]) annotation(
      Line(points = {{53.5, 30}, {61.5, 30}}));
    connect(stopping.outPort[1], toIdle.inPort) annotation(
      Line(points = {{82.5, 30}, {88.5, 30}}));
    connect(toIdle.outPort, idle.inPort[1]) annotation(
      Line(points = {{93.5, 30}, {98, 30}, {98, 58}, {-98, 58}, {-98, 30}, {-95, 30}}));
    connect(standby.outPort[1], toStarting.inPort) annotation(
      Line(points = {{-33.5, 30}, {-27.5, 30}}));
    connect(toStarting.outPort, starting.inPort[1]) annotation(
      Line(points = {{-22.5, 30}, {-14.5, 30}}));
    connect(starting.outPort[1], toRunning.inPort) annotation(
      Line(points = {{6.5, 30}, {10.5, 30}}));
    connect(toRunning.outPort, running.inPort[1]) annotation(
      Line(points = {{15.5, 30}, {23.5, 30}}));
    connect(running.outPort[1], toStopping.inPort) annotation(
      Line(points = {{44.5, 30}, {48.5, 30}}));
    connect(idle.active, modeRequest.u[1]) annotation(
      Line(points = {{-84, 19}, {-84, -26}, {46, -26}}, color = {255, 0, 255}));
    connect(standby.active, modeRequest.u[2]) annotation(
      Line(points = {{-44, 19}, {-44, -26}, {46, -26}}, color = {255, 0, 255}));
    connect(starting.active, modeRequest.u[3]) annotation(
      Line(points = {{-4, 19}, {-4, -26}, {46, -26}}, color = {255, 0, 255}));
    connect(running.active, modeRequest.u[4]) annotation(
      Line(points = {{34, 19}, {34, -26}, {46, -26}}, color = {255, 0, 255}));
    connect(stopping.active, modeRequest.u[5]) annotation(
      Line(points = {{72, 19}, {72, -0.5}, {40, -0.5}, {40, -24.25}, {46, -24.25}, {46, -26}}, color = {255, 0, 255}));
    connect(sync.yStatusBits, unpackStatusBits.u) annotation(
      Line(points = {{14, -69}, {14, -59}, {28, -59}}, color = {255, 127, 0}));
    connect(packControlBits.y, sync.uControlBits) annotation(
      Line(points = {{-19, -70}, {-9.5, -70}, {-9.5, -74}, {-2, -74}}, color = {255, 127, 0}));
    connect(modeRequest.y, packControlBits.uSetpoint_Mode_Req) annotation(
      Line(points = {{88, -26}, {92, -26}, {92, -40}, {-50, -40}, {-50, -60}, {-42, -60}}, color = {255, 127, 0}));
    connect(HVESSC1_PowerDown_Command.y, packControlBits.uPowerDown_Command) annotation(
      Line(points = {{-72, -62}, {-60, -62}, {-60, -66}, {-42, -66}}, color = {255, 127, 0}));
    connect(HVBI_Driveline_Availability.y, packControlBits.uDriveline_Availability) annotation(
      Line(points = {{-72, -78}, {-60, -78}, {-60, -70}, {-42, -70}}, color = {255, 127, 0}));
    connect(MG1IC_Setpoint_Req.y, sync.uSetpoint_Req) annotation(
      Line(points = {{-38, -92}, {-10, -92}, {-10, -80}, {-2, -80}}, color = {0, 0, 127}));
  protected
    annotation(
      experiment(StartTime = 0, StopTime = 500, Tolerance = 1e-06, Interval = 0.1),
      Documentation(info = "<html><head></head><body>
<p>A test model that creates a very&nbsp;simple input value sequence with a duration of 500 seconds that in a cycle sends request of these modes to the FCCU:</p>
<div><ul>
<li>Start-up (idle)</li><li>Standby</li>
<li>Starting</li><li>Running</li>
<li>Stopping</li></ul></div>
<p>It is used in the test procedures of <a href=\"modelica://XInTheLoop.Examples.Site2\">this site</a>.</p>
</body></html>"));
  end Test;

  package Blocks "Site1-Specific Blocks"
    extends Icons.BlocksPackage;

    block Sync "Example HIL block to exchange values with this site"
      extends Icons.HardwareInTheLoopBlock;
      import XInTheLoop.Functions.bitmask;
      Modelica.Blocks.Interfaces.IntegerInput uControlBits annotation(
        Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      XInTheLoop.Blocks.Protocol.UDPSync uDPSync(nFloatsIn = 7, nFloatsOut = 1, port_recv = 10004, port_send = 10003, real_time = true, vIn = 1, vOut = 1, mOut = 1213420627, mIn = 1752396915) annotation(
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
      XInTheLoop.Blocks.Bitwise.PackInt packInt(nu = 3, n_bits = {5, 2, 4}) annotation(
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
<p>
This example implements a UDP protocol to exchange values with an external system running a StasHH compatible fuel cell module (FCM) where a fuel cell control unit (FCCU) handle the StasHH Digital Interface via a CAN bus.</p>

<h4 id=\"tool\">Python Tools</h4>
<ul>
<li><tt>site2.py</tt> is the base Site2 protocol.</li>
<li><tt>site2-relay.py</tt> is the UDP-CAN relay service.</li>
<li><tt>site2-fccu.py</tt> is a simple simulator of the FCCU CAN messages.</li>
</ul>

<p>The two latter tools both assume a USB-CAN adapter of type Peak PCAN-USB is connected, but it's easy to switch to some other CAN adapter that is supported by <tt>python-can</tt> using different arguments for the <tt>can.Bus()</tt> call.</p>

<p>
In all the <a href=\"#dry\">Dry Run</a>, <a href=\"#moist\">Moist Run</a>,  and the <a href=\"#wet\">Wet Run</a> sections below, a selection of these Python tools are used. It is assumed your PC has Python (version 3 or above) installed. If not, it can be installed from the Microsoft Store App.</p><p>

Except for the <b>Dry Run</b> (which only uses the base Site2 protocol), a USB-CAN adapter (or two such adapters for the <b>Moist Run</b>) must be connected and these Python packages need to be installed in the python environment in use:
</p><ul>
<li><tt>cantools</tt></li>
<li><tt>python-can</tt> (automatically installed as a dependency of <tt>cantools</tt>, but check that the installed version is &ge; v4.3.0)</li>
<li><tt>crcmod</tt></li>
<li><tt>keyboard</tt> (only needed by <tt>site2-fccu.py</tt> used in the Moist Run)</li>
</ul>
<p>Command to install the packages above:</p>

<pre style=\"font-size: 12px;\">pip install cantools crcmod keyboard</pre>

<p>
The Python files&nbsp;<tt>site2*.py</tt>&nbsp;are located in the <tt>XInTheLoop/Resources/tools/</tt> folder - where <a href=\"modelica://XInTheLoop\">this library</a> is installed or cloned from github.
</p>

<h4 id=\"dry\">Dry Run</h4>
To only test the UDP protocol without a real hardware I/O application present, use the basic <a href=\"#tool\">Python tool included in the tools folder</a>.

<ol>
<li>Open a command shell window, and change to the tools&nbsp;folder. The Python file should now be shown if executing a <tt>dir</tt> command.</li>

<li>To capture and dump the outgoing values sent to the external system, execute

<pre style=\"font-size: 12px;\">python site2.py out</pre>

</li><li>Open a second command shell window, and change to the tools&nbsp;folder. This preparation step should be done before starting simulation to reduce time usage during simulation.</li>

<li>Start simulation of the <a href=\"modelica://XInTheLoop.Examples.Site2.Test\">Test</a> model.</li>

<li>When the compilation is finished and the simulation has started, execute e.g.

<pre style=\"font-size: 12px;\">python site2.py in 2 3 4 5 6 7 8 9 300</pre>

in the second shell window to send a series of 300 incoming messages while the simulation is running. In the command line example above, the first message will contain a payload vector of the specified dummy values, and then for each of the 300 repetitions, all values in the payload vector are incremented before sending the next message after a one second delay.</li>

<li>When the simulation has ended, select e.g. the variables <tt>packControlBits.uSetpoint_Mode_Req</tt>, <tt>sync.yDC_current_output</tt>, <tt>sync.yDC_voltage_output</tt> and <tt>unpackStatusBits.ySetpoint_Mode</tt> to plot these received values in a graph of the simulation.</li>

</ol>

<img src=\"modelica://XInTheLoop/Resources/Images/site2-test-plot.png\">

<h4 id=\"moist\">Moist Run</h4>
<p>To test the model without a real Fuel Cell Module present, but with two interconnected USB-CAN adapters used by the UDP-CAN relay and FCCU simulater processes, use the <a href=\"#tool\">Python tools included in the tools folder</a>.</p>

<ol>
<li>Open a command shell window, and change to the tools&nbsp;folder. The Python file should now be shown if executing a <tt>dir</tt> command.</li>

<li>To start the UDP-CAN relay service, execute

<pre style=\"font-size: 12px;\">python site2-relay.py</pre>

</li><li>Open a second command shell window, and change to the tools&nbsp;folder. This preparation step should be done before starting simulation to reduce time usage during simulation.</li>

<li>Start simulation of the <a href=\"modelica://XInTheLoop.Examples.Site2.Test\">Test</a> model.</li>

<li>When the compilation is finished and the simulation has started, execute

<pre style=\"font-size: 12px;\">python site2-fccu.py</pre>

in the second shell window to simulate the CAN messages of and FCCU.</li>

<li>When the simulation has ended, select e.g. the variables <tt>packControlBits.uSetpoint_Mode_Req</tt>,  <tt>sync.yDC_current_output</tt>, <tt>sync.yDC_voltage_output</tt> and <tt>unpackStatusBits.ySetpoint_Mode</tt> to plot these received values in a graph of the simulation.</li>

</ol>

<h4 id=\"wet\">Wet Run</h4>
<p>To test the model against a real StasHH FCCU hardware, the procedure is quite similar to the <a href=\"#moist\">Moist Run</a> described above, except only a single USB-CAN adapter must be connected from the PC to the FCCU CAN bus, instead of using two interconnected USB-CAN adapters. The steps are:</p>

<ol>
<li>Open a command shell window, and change to the tools&nbsp;folder. The Python file should now be shown if executing a <tt>dir</tt> command.</li>

<li>To start the UDP-CAN relay service, execute

<pre style=\"font-size: 12px;\">python site2-relay.py</pre>

</li><li>Start simulation of the <a href=\"modelica://XInTheLoop.Examples.Site2.Test\">Test</a> model.</li>

<li>When the simulation has ended, select e.g. the variables <tt>packControlBits.uSetpoint_Mode_Req</tt>, <tt>sync.yDC_current_output</tt>, <tt>sync.yDC_voltage_output</tt> and <tt>unpackStatusBits.ySetpoint_Mode</tt> to plot these received values in a graph of the simulation. All variables with a leading <tt>y</tt> from the <tt>sync</tt> and <tt>unpackStatusBits</tt> blocks are received from the FCCU.</li>

</ol>

<h4>Protocol Packet Details</h4>
<div>In each UDP packet sent in this protocol there is a leading header:</div>
<div><ol><li>A constant 32-bit \"magic\" integer number to reduce the risk of interpreting a random missent packet from another application as a valid packet in this protocol.</li><li>A 32-bit integer version number that should be increased when the packet format is changed in a way that is not backward compatible. If only appending new values to the packet payload format, then the version number normally does not need to change because extra content at the end should be ignored by the receiver.</li><li>A 16-bit integer packet sequence number incremented by the sender for each packet. The counter is independent for each direction. When a counter value exceeds 16 bits, it wraps around to zero again.</li><li>A 16-bit integer received packet sequence number containing a copy of the packet sequence number from the last received packet in the reverse direction. In the Python script of this example, the last packet in each direction is written to temporary files to remember these sequence numbers, but in a typical hardware/external I/O application, it normally is much easier to use internal variables instead.</li></ol></div>
<div>followed by a payload:</div>
<div><ol>
<li>A vector of 32-bit integer values.</li>
<li>A vector of 32-bit float values.</li>
</ol></div>
<p>All values are stored as little endian. A protocol implementation for one particular external system will need a fixed packet format in each direction. For each direction, all of these must be defined:</p>
<div><ul>
<li>Address/IP (in this example, localhost is assumed) and port of the receiving end.</li>
<li>Header version number.</li>
<li>Payload vector sizes.</li>
<li>Meta information for each value in the payload vectors.</li>
</ul></div>
</body></html>"));
end Site2;
