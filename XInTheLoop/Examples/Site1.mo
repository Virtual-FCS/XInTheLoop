within XInTheLoop.Examples;

package Site1 "Example Site 1 for Hardware-in-the-loop (HIL) simulation"
  extends Modelica.Icons.ExamplesPackage;

  model Test "Example model demonstrating exchanging values with this HIL site using a simple pattern of time varying data as input"
    extends Modelica.Icons.Example;
    Modelica.Blocks.Sources.IntegerExpression remoteControl(y = 1) annotation(
      Placement(visible = true, transformation(origin = {-80, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    XInTheLoop.Blocks.Customized.IntegerTable keyOn(table = [0, 0; 10, 1; 300, 0]) annotation(
      Placement(visible = true, transformation(origin = {-80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    XInTheLoop.Blocks.Customized.IntegerTable start(table = [0, 0; 15, 1; 290, 0]) annotation(
      Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.IntegerExpression loadSequence annotation(
      Placement(visible = true, transformation(origin = {-80, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    XInTheLoop.Examples.Site1.Blocks.PackControlBits packControlBits annotation(
      Placement(visible = true, transformation(origin = {-30, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.RealExpression dcdcSP annotation(
      Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.TimeTable loadSP(table = [0, 0; 180, 0; 190, 5000; 210, 6000; 270, 5500; 280, 0; 320, 0]) annotation(
      Placement(visible = true, transformation(origin = {-30, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    XInTheLoop.Examples.Site1.Blocks.Sync sync annotation(
      Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    XInTheLoop.Examples.Site1.Blocks.UnpackStatusBits unpackStatusBits annotation(
      Placement(visible = true, transformation(origin = {40, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(remoteControl.y, packControlBits.uRemoteControl) annotation(
      Line(points = {{-69, 80}, {-60, 80}, {-60, 44}, {-42, 44}, {-42, 45}}, color = {255, 127, 0}));
    connect(keyOn.y, packControlBits.uKeyOn) annotation(
      Line(points = {{-69, 40}, {-42, 40}, {-42, 39}}, color = {255, 127, 0}));
    connect(start.y, packControlBits.uStartButton) annotation(
      Line(points = {{-68, 0}, {-60, 0}, {-60, 32}, {-42, 32}, {-42, 33}}, color = {255, 127, 0}));
    connect(loadSequence.y, packControlBits.uLoadSequence) annotation(
      Line(points = {{-68, -40}, {-52, -40}, {-52, 27}, {-42, 27}}, color = {255, 127, 0}));
    connect(packControlBits.y, sync.uControlBits) annotation(
      Line(points = {{-19, 36}, {-10, 36}, {-10, 6}, {-2, 6}}, color = {255, 127, 0}));
    connect(dcdcSP.y, sync.uDcDc_SP_req) annotation(
      Line(points = {{-19, 0}, {-2, 0}}, color = {0, 0, 127}));
    connect(sync.yStatusBits, unpackStatusBits.u) annotation(
      Line(points = {{14, 11}, {14, 70}, {28, 70}}, color = {255, 127, 0}));
    connect(loadSP.y, sync.uLoad_SP_req) annotation(
      Line(points = {{-19, -30}, {-11, -30}, {-11, -6}, {-2, -6}}, color = {0, 0, 127}));
  protected
    annotation(
      experiment(StartTime = 0, StopTime = 60, Tolerance = 1e-06, Interval = 0.1));
  end Test;

  model LoadProfile "Example model demonstrating exchanging values with this site using a realistic load profile of a luggage transportation vehicle from a data file"
    extends Modelica.Icons.Example;
    XInTheLoop.Examples.Site1.Blocks.Sync sync annotation(
      Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.CombiTimeTable loadSP(fileName = Modelica.Utilities.Files.loadResource("modelica://XInTheLoop/Resources/Data/DriveProfile.mat"), shiftTime = -200, tableName = "X", tableOnFile = true) annotation(
      Placement(visible = true, transformation(origin = {-30, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.RealExpression dcdcSP annotation(
      Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    XInTheLoop.Examples.Site1.Blocks.PackControlBits packControlBits annotation(
      Placement(visible = true, transformation(origin = {-30, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    XInTheLoop.Examples.Site1.Blocks.UnpackStatusBits unpackStatusBits annotation(
      Placement(visible = true, transformation(origin = {50, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    XInTheLoop.Blocks.Customized.IntegerTable keyOn(table = [0, 0; 10, 1; 570, 0]) annotation(
      Placement(visible = true, transformation(origin = {-80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.IntegerExpression loadSequence annotation(
      Placement(visible = true, transformation(origin = {-80, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.IntegerExpression remoteControl(y = 1) annotation(
      Placement(visible = true, transformation(origin = {-80, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    XInTheLoop.Blocks.Customized.IntegerTable start(table = [0, 0; 50, 1; 560, 0]) annotation(
      Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Math.MultiProduct powerStack(nu = 2) annotation(
      Placement(visible = true, transformation(origin = {50, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Math.MultiProduct powerBatt(nu = 2) annotation(
      Placement(visible = true, transformation(origin = {50, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Math.MultiProduct powerDcDcIn(nu = 2) annotation(
      Placement(visible = true, transformation(origin = {50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Math.MultiProduct powerDcDcOut(nu = 2) annotation(
      Placement(visible = true, transformation(origin = {50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Math.MultiProduct powerLoad(nu = 2) annotation(
      Placement(visible = true, transformation(origin = {50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(keyOn.y, packControlBits.uKeyOn) annotation(
      Line(points = {{-69, 40}, {-42, 40}, {-42, 39}}, color = {255, 127, 0}));
    connect(loadSequence.y, packControlBits.uLoadSequence) annotation(
      Line(points = {{-68, -40}, {-52, -40}, {-52, 27}, {-42, 27}}, color = {255, 127, 0}));
    connect(dcdcSP.y, sync.uDcDc_SP_req) annotation(
      Line(points = {{-19, 0}, {-2, 0}}, color = {0, 0, 127}));
    connect(sync.yStatusBits, unpackStatusBits.u) annotation(
      Line(points = {{14, 11}, {14, 70}, {38, 70}}, color = {255, 127, 0}));
    connect(packControlBits.y, sync.uControlBits) annotation(
      Line(points = {{-19, 36}, {-10, 36}, {-10, 6}, {-2, 6}}, color = {255, 127, 0}));
    connect(start.y, packControlBits.uStartButton) annotation(
      Line(points = {{-68, 0}, {-60, 0}, {-60, 32}, {-42, 32}, {-42, 33}}, color = {255, 127, 0}));
    connect(remoteControl.y, packControlBits.uRemoteControl) annotation(
      Line(points = {{-69, 80}, {-60, 80}, {-60, 44}, {-42, 44}, {-42, 45}}, color = {255, 127, 0}));
    connect(loadSP.y[1], sync.uLoad_SP_req) annotation(
      Line(points = {{-18, -30}, {-10, -30}, {-10, -6}, {-2, -6}}, color = {0, 0, 127}));
    connect(sync.yV_Stack, powerStack.u[1]) annotation(
      Line(points = {{22, 10}, {28, 10}, {28, 36}, {40, 36}}, color = {0, 0, 127}));
    connect(sync.yI_Stack, powerStack.u[2]) annotation(
      Line(points = {{22, 8}, {30, 8}, {30, 34}, {40, 34}, {40, 36}}, color = {0, 0, 127}));
    connect(sync.yI_Batt, powerBatt.u[1]) annotation(
      Line(points = {{22, 2}, {40, 2}, {40, 6}}, color = {0, 0, 127}));
    connect(sync.yV_Batt, powerBatt.u[2]) annotation(
      Line(points = {{22, 4}, {40, 4}, {40, 6}, {40, 6}}, color = {0, 0, 127}));
    connect(sync.yV_In_DcDc, powerDcDcIn.u[1]) annotation(
      Line(points = {{22, -2}, {34, -2}, {34, -18}, {40, -18}, {40, -20}}, color = {0, 0, 127}));
    connect(sync.yI_In_DcDc, powerDcDcIn.u[2]) annotation(
      Line(points = {{22, -4}, {32, -4}, {32, -20}, {40, -20}}, color = {0, 0, 127}));
    connect(sync.yV_Out_DcDc, powerDcDcOut.u[1]) annotation(
      Line(points = {{22, -4}, {30, -4}, {30, -48}, {40, -48}, {40, -50}}, color = {0, 0, 127}));
    connect(sync.yI_Out_DcDc, powerDcDcOut.u[2]) annotation(
      Line(points = {{22, -6}, {28, -6}, {28, -50}, {40, -50}, {40, -50}}, color = {0, 0, 127}));
    connect(sync.yV_Load, powerLoad.u[1]) annotation(
      Line(points = {{22, -8}, {26, -8}, {26, -78}, {40, -78}, {40, -80}}, color = {0, 0, 127}));
    connect(sync.yI_Load, powerLoad.u[2]) annotation(
      Line(points = {{22, -10}, {24, -10}, {24, -80}, {40, -80}, {40, -80}}, color = {0, 0, 127}));
    annotation(
      experiment(StartTime = 0, StopTime = 580, Tolerance = 1e-06, Interval = 1),
      __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
      __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
  end LoadProfile;

  package Blocks "Site1-Specific Blocks"
    extends Icons.BlocksPackage;

    block Sync "Example HIL block to exchange values with this site"
      extends Icons.HardwareInTheLoopBlock;
      import XInTheLoop.Functions.bitmask;
      Modelica.Blocks.Interfaces.IntegerInput uControlBits annotation(
        Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      XInTheLoop.Blocks.Protocol.UDPSync uDPSync(nFloatsIn = 16, nFloatsOut = 2) annotation(
        Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.MathInteger.Sum sum(k = {1, -1}, nu = 2) annotation(
        Placement(visible = true, transformation(origin = {10, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      XInTheLoop.Blocks.Bitwise.AndInts andBitmask(b = bitmask(uDPSync.wSeq), nu = 1) annotation(
        Placement(visible = true, transformation(origin = {10, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Modelica.Blocks.Interfaces.IntegerOutput ySeqOutAhead "Difference between the sequence number to be sent and the last reverse sequence number received" annotation(
        Placement(visible = true, transformation(origin = {10, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {10, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Modelica.Blocks.Interfaces.RealInput uDcDc_SP_req annotation(
        Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput uLoad_SP_req annotation(
        Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.IntegerOutput yStatusBits annotation(
        Placement(visible = true, transformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Modelica.Blocks.Interfaces.RealOutput yDcDc_SP annotation(
        Placement(visible = true, transformation(origin = {60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Modelica.Blocks.Interfaces.RealOutput yLoad_SP annotation(
        Placement(visible = true, transformation(origin = {80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Modelica.Blocks.Interfaces.RealOutput yV_Stack annotation(
        Placement(visible = true, transformation(origin = {110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput yI_Stack annotation(
        Placement(visible = true, transformation(origin = {110, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput yT_Stack_In annotation(
        Placement(visible = true, transformation(origin = {110, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput yT_Stack_Out annotation(
        Placement(visible = true, transformation(origin = {110, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput yV_Batt annotation(
        Placement(visible = true, transformation(origin = {110, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput yI_Batt annotation(
        Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput ySOC annotation(
        Placement(visible = true, transformation(origin = {110, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput yT_Batt annotation(
        Placement(visible = true, transformation(origin = {110, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput yV_In_DcDc annotation(
        Placement(visible = true, transformation(origin = {110, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput yI_In_DcDc annotation(
        Placement(visible = true, transformation(origin = {110, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput yV_Out_DcDc annotation(
        Placement(visible = true, transformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput yI_Out_DcDc annotation(
        Placement(visible = true, transformation(origin = {110, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput yV_Load annotation(
        Placement(visible = true, transformation(origin = {110, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput yI_Load annotation(
        Placement(visible = true, transformation(origin = {110, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(uControlBits, uDPSync.uIntegers[1]) annotation(
        Line(points = {{-120, 60}, {-40, 60}, {-40, 0}, {-32, 0}}, color = {255, 127, 0}));
      connect(uDcDc_SP_req, uDPSync.uFloats[1]) annotation(
        Line(points = {{-120, 0}, {-60, 0}, {-60, -6}, {-32, -6}}, color = {0, 0, 127}));
      connect(uLoad_SP_req, uDPSync.uFloats[2]) annotation(
        Line(points = {{-120, -60}, {-60, -60}, {-60, -6}, {-32, -6}}, color = {0, 0, 127}));
      connect(uDPSync.ySeqOut, sum.u[1]) annotation(
        Line(points = {{-8, 8}, {6, 8}, {6, 20}, {10, 20}}, color = {255, 127, 0}));
      connect(uDPSync.ySeqRev, sum.u[2]) annotation(
        Line(points = {{-8, 0}, {14, 0}, {14, 20}, {10, 20}}, color = {255, 127, 0}));
      connect(sum.y, andBitmask.u[1]) annotation(
        Line(points = {{10, 42}, {10, 42}, {10, 60}, {10, 60}}, color = {255, 127, 0}));
      connect(andBitmask.y, ySeqOutAhead) annotation(
        Line(points = {{10, 82}, {10, 82}, {10, 110}, {10, 110}}, color = {255, 127, 0}));
      connect(uDPSync.yIntegers[1], yStatusBits) annotation(
        Line(points = {{-9, -4}, {40, -4}, {40, 110}}, color = {255, 127, 0}));
      connect(uDPSync.yFloats[1], yDcDc_SP) annotation(
        Line(points = {{-9, -8}, {60, -8}, {60, 110}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[2], yLoad_SP) annotation(
        Line(points = {{-9, -8}, {80, -8}, {80, 110}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[3], yV_Stack) annotation(
        Line(points = {{-9, -8}, {80, -8}, {80, 90}, {110, 90}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[4], yI_Stack) annotation(
        Line(points = {{-9, -8}, {80, -8}, {80, 76}, {110, 76}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[5], yT_Stack_In) annotation(
        Line(points = {{-9, -8}, {80, -8}, {80, 62}, {110, 62}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[6], yT_Stack_Out) annotation(
        Line(points = {{-9, -8}, {80, -8}, {80, 48}, {110, 48}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[7], yV_Batt) annotation(
        Line(points = {{-9, -8}, {80, -8}, {80, 34}, {110, 34}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[8], yI_Batt) annotation(
        Line(points = {{-9, -8}, {80, -8}, {80, 20}, {110, 20}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[9], ySOC) annotation(
        Line(points = {{-9, -8}, {80, -8}, {80, 6}, {110, 6}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[10], yT_Batt) annotation(
        Line(points = {{-9, -8}, {110, -8}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[11], yV_In_DcDc) annotation(
        Line(points = {{-9, -8}, {80, -8}, {80, -22}, {110, -22}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[12], yI_In_DcDc) annotation(
        Line(points = {{-9, -8}, {80, -8}, {80, -36}, {110, -36}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[13], yV_Out_DcDc) annotation(
        Line(points = {{-9, -8}, {80, -8}, {80, -50}, {110, -50}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[14], yI_Out_DcDc) annotation(
        Line(points = {{-9, -8}, {80, -8}, {80, -64}, {110, -64}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[15], yV_Load) annotation(
        Line(points = {{-9, -8}, {80, -8}, {80, -78}, {110, -78}}, color = {0, 0, 127}));
      connect(uDPSync.yFloats[16], yI_Load) annotation(
        Line(points = {{-9, -8}, {80, -8}, {80, -92}, {110, -92}}, color = {0, 0, 127}));
      annotation(
        Documentation(info = "<html><head></head><body>Sync outgoing values to and incoming values from an example external Site 1 using a UDP protocol.</body></html>"));
    end Sync;

    block PackControlBits "Pack all control bits into an integer"
      extends Modelica.Blocks.Interfaces.IntegerSO;
      extends XInTheLoop.Blocks.Bitwise.Icons.BitPack;
      Modelica.Blocks.Interfaces.IntegerInput uRemoteControl annotation(
        Placement(visible = true, transformation(origin = {-120, 90}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 90}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.IntegerInput uKeyOn annotation(
        Placement(visible = true, transformation(origin = {-120, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.IntegerInput uStartButton annotation(
        Placement(visible = true, transformation(origin = {-120, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Blocks.Interfaces.IntegerInput uLoadSequence annotation(
        Placement(visible = true, transformation(origin = {-120, -90}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -90}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      XInTheLoop.Blocks.Bitwise.PackInt packInt(nu = 4, n_bits = {1, 1, 1, 1}) annotation(
        Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(uRemoteControl, packInt.u[1]) annotation(
        Line(points = {{-120, 90}, {-40, 90}, {-40, 6}, {-10, 6}, {-10, 0}}, color = {255, 127, 0}));
      connect(uKeyOn, packInt.u[2]) annotation(
        Line(points = {{-120, 30}, {-60, 30}, {-60, 2}, {-10, 2}, {-10, 0}}, color = {255, 127, 0}));
      connect(uStartButton, packInt.u[3]) annotation(
        Line(points = {{-120, -30}, {-60, -30}, {-60, -2}, {-10, -2}, {-10, 0}}, color = {255, 127, 0}));
      connect(uLoadSequence, packInt.u[4]) annotation(
        Line(points = {{-120, -90}, {-40, -90}, {-40, -6}, {-10, -6}, {-10, 0}}, color = {255, 127, 0}));
      connect(packInt.y, y) annotation(
        Line(points = {{12, 0}, {104, 0}, {104, 0}, {110, 0}}, color = {255, 127, 0}));
    end PackControlBits;

    block UnpackStatusBits "Unpack all status bits from an integer"
      extends Modelica.Blocks.Icons.IntegerBlock;
      extends XInTheLoop.Blocks.Bitwise.Icons.BitUnpack;
      Modelica.Blocks.Interfaces.IntegerInput u annotation(
        Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      XInTheLoop.Blocks.Bitwise.UnpackInt unpackInt(n_bits = {8, 8, 16}) annotation(
        Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      XInTheLoop.Blocks.Bitwise.UnpackInt2Bools unpackInt2Bools(b = 13) annotation(
        Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.IntegerOutput yModeDcDc annotation(
        Placement(visible = true, transformation(origin = {30, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {30, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Modelica.Blocks.Interfaces.IntegerOutput yModeFCM annotation(
        Placement(visible = true, transformation(origin = {50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Modelica.Blocks.Interfaces.IntegerOutput yBoolBits "All Bool bits" annotation(
        Placement(visible = true, transformation(origin = {70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Modelica.Blocks.Interfaces.BooleanOutput yRemoteControl annotation(
        Placement(visible = true, transformation(origin = {110, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput yKeyOn annotation(
        Placement(visible = true, transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput yStartButton annotation(
        Placement(visible = true, transformation(origin = {110, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput yLoadSequence annotation(
        Placement(visible = true, transformation(origin = {110, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput yReady annotation(
        Placement(visible = true, transformation(origin = {110, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput yH2Supply annotation(
        Placement(visible = true, transformation(origin = {110, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput yFMCHeartbeat annotation(
        Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput yDcDcOk annotation(
        Placement(visible = true, transformation(origin = {110, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput yWarning annotation(
        Placement(visible = true, transformation(origin = {110, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput yAlarm annotation(
        Placement(visible = true, transformation(origin = {110, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput yBatteryRelay annotation(
        Placement(visible = true, transformation(origin = {110, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput yDcDcRelay annotation(
        Placement(visible = true, transformation(origin = {110, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput yModelicaHeartbeat annotation(
        Placement(visible = true, transformation(origin = {110, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(u, unpackInt.u) annotation(
        Line(points = {{-120, 0}, {-14, 0}, {-14, 0}, {-12, 0}}, color = {255, 127, 0}));
      connect(unpackInt.y[1], yModeDcDc) annotation(
        Line(points = {{12, 0}, {30, 0}, {30, -110}, {30, -110}}, color = {255, 127, 0}));
      connect(unpackInt.y[2], yModeFCM) annotation(
        Line(points = {{12, 0}, {30, 0}, {30, -80}, {50, -80}, {50, -110}, {50, -110}}, color = {255, 127, 0}));
      connect(unpackInt.y[3], yBoolBits) annotation(
        Line(points = {{12, 0}, {30, 0}, {30, -80}, {70, -80}, {70, -110}, {70, -110}}, color = {255, 127, 0}));
      connect(unpackInt.y[3], unpackInt2Bools.u) annotation(
        Line(points = {{12, 0}, {38, 0}, {38, 0}, {38, 0}}, color = {255, 127, 0}));
      connect(unpackInt2Bools.y[1], yRemoteControl) annotation(
        Line(points = {{62, 0}, {80, 0}, {80, 94}, {110, 94}}, color = {255, 0, 255}));
      connect(unpackInt2Bools.y[2], yKeyOn) annotation(
        Line(points = {{62, 0}, {80, 0}, {80, 80}, {110, 80}}, color = {255, 0, 255}));
      connect(unpackInt2Bools.y[3], yStartButton) annotation(
        Line(points = {{62, 0}, {80, 0}, {80, 64}, {110, 64}}, color = {255, 0, 255}));
      connect(unpackInt2Bools.y[4], yLoadSequence) annotation(
        Line(points = {{62, 0}, {80, 0}, {80, 48}, {110, 48}}, color = {255, 0, 255}));
      connect(unpackInt2Bools.y[5], yReady) annotation(
        Line(points = {{62, 0}, {80, 0}, {80, 32}, {110, 32}}, color = {255, 0, 255}));
      connect(unpackInt2Bools.y[6], yH2Supply) annotation(
        Line(points = {{62, 0}, {80, 0}, {80, 16}, {110, 16}}, color = {255, 0, 255}));
      connect(unpackInt2Bools.y[7], yFMCHeartbeat) annotation(
        Line(points = {{62, 0}, {110, 0}}, color = {255, 0, 255}));
      connect(unpackInt2Bools.y[8], yDcDcOk) annotation(
        Line(points = {{62, 0}, {80, 0}, {80, -16}, {110, -16}}, color = {255, 0, 255}));
      connect(unpackInt2Bools.y[9], yWarning) annotation(
        Line(points = {{62, 0}, {80, 0}, {80, -32}, {110, -32}}, color = {255, 0, 255}));
      connect(unpackInt2Bools.y[10], yAlarm) annotation(
        Line(points = {{62, 0}, {80, 0}, {80, -48}, {110, -48}}, color = {255, 0, 255}));
      connect(unpackInt2Bools.y[11], yBatteryRelay) annotation(
        Line(points = {{62, 0}, {80, 0}, {80, -64}, {110, -64}}, color = {255, 0, 255}));
      connect(unpackInt2Bools.y[12], yDcDcRelay) annotation(
        Line(points = {{62, 0}, {80, 0}, {80, -78}, {110, -78}}, color = {255, 0, 255}));
      connect(unpackInt2Bools.y[13], yModelicaHeartbeat) annotation(
        Line(points = {{62, 0}, {80, 0}, {80, -94}, {110, -94}}, color = {255, 0, 255}));
    end UnpackStatusBits;
  end Blocks;
  annotation(
    Documentation(info = "<html><head></head><body>
This example implements a UDP protocol to exchange values with an external system running a fuel cell, DC-DC-converter, battery, and a variable load - to enable&nbsp;Hardware-in-the-loop (HIL) simulations.
<h4 id=\"tool\">Python Tool</h4>
In both the <a href=\"#dry\">Dry Run</a> and the <a href=\"#wet\">Wet Run</a> sections below, the same Python tool is used. It is assumed your PC has Python (version 3 or above) installed. If not, it can be installed from the Microsoft Store App.

The Python file <tt>site1-protocol.py</tt> is located in the <tt>tools</tt> folder below the folder where <a href=\"modelica://XInTheLoop/\">this library</a> is installed or cloned from github.

<h4 id=\"dry\">Dry Run</h4>
To test this without a real hardware I/O application present, use the <a href=\"#tool\">Python tool included in the tools folder</a>.

<ol>
<li>Open a command shell window, and change to the tools&nbsp;folder. The Python file should now be shown if executing a <tt>dir</tt> command.</li>

<li>To capture and dump the outgoing values sent to the external system, execute

<pre style=\"font-size: 12px;\">python3 site1-protocol.py out</pre>

</li><li>Open a second command shell window, and change to the tools&nbsp;folder. This preparation step should be done before starting simulation to reduce time usage during simulation.</li>

<li>Start simulation of the Test model.</li>

<li>When the compilation is finished and the simulation has started, execute e.g.

<pre style=\"font-size: 12px;\">python3 site1-protocol.py in 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 50</pre>

in the second shell window to send a series of 50 incoming messages while the simulation is running. In the command line example above, the first message will contain a payload vector of the specified dummy values, and then for each of the 50 repetitions, all values in the payload vector are incremented before sending the next message after a one second delay.</li>

<li>When the simulation has ended, select e.g. the variables sync.yI_Load, sync.yI_Stack, and sync.yI_Batt to plot these received values in a graph of the simulation.</li>

</ol>

<img src=\"modelica://XInTheLoop/Resources/Images/site1-test-plot.png\">

<h4 id=\"wet\">Wet Run</h4><div>To test this against a real hardware or some other external system, the protocol implemented in this example must also be implemented in a hardware/external I/O application that acts like a UDP service abstraction layer above the actual hardware or external system. The Python script implementation used for the dry run above can be used as an inspiration, but other programming languages able to do UDP communication can also be used, e.g. C/C++ or LabView.</div><div><br></div><div>To develop a similar protocol tailored to your external system, a custom <b>sync</b> block is needed, and we recommend using the <a href=\"XInTheLoop.Examples.Site1.Blocks.Sync\">one in this example</a> as a base and adapt it to the custom set of input control values and output status/measurement values needed for your external system. If you also need some input control bits and/or output status bits packed as integer(s), then custom blocks for packing/unpacking these bits can be developed by using the blocks in this example as basis and adapt them to the set(s) of bits needed for your external system. We also recommend making a custom Python script for testing the protocol, and the one in this example can easily be adapted to a different set of values inside the protocol packets.</div><div><br></div><div>A check-list for executing such a simulation should typically include these items, but depending on the actual system, other items might also need to be added:</div>

<ol>
<li>Verify that the hardware I/O application is configured to communicate as expected by the <b>sync</b> block. In this example, the parameters of <b>XInTheLoop.Blocks.Protocol.UDPSync</b>&nbsp;expect the application to run at \"127.0.0.1\" (localhost = at the same machine as the Modelica model), listening for UDP packets&nbsp;at port 10002, each containing a v2-header, 1 int, and 2 floats. Further, the application is expected to send UDP packets to port 10001, each containing a v2-header, 1 int, and 16 floats. When making your own protocol for a new external system, these parameters will probably have other values.</li><li>Make sure the external hardware is activated and is ready to communicate with the&nbsp;hardware I/O application.</li><li>Make sure the&nbsp;hardware I/O application is running and has enabled communication with Modelica (if optional). In this example, this can be verified by executing the <a href=\"#tool\">Python tool</a> in a command shell window<pre style=\"font-size: 12px;\">python3 site1-protocol.py in</pre>

before starting the Modelica simulation. The output will then show packets sent from the hardware I/O application to Modelica. Remember to stop this Python script before starting the Modelica simulation.

</li><li>Make sure the external system is in a state that makes it ready to be observed (and optionally controlled) by Modelica. This typically include that the FCS has fuel and is ready to start, battery is connected and functional, a load is ready to be applied, no errors present, etc.</li><li>If remote control of the external system from Modelica is optional, it can be enabled now.</li><li>Execute the Modelica simulation now (or after the next step if the model assumes a running state from start).</li><li>If any start-up sequence is manual and not enabled for remote control, then execute such a sequence now.</li><li>If any shut-down sequence is manual and not enabled for remote control, then execute such a sequence after the simulation is finished.</li>

</ol><h4>Protocol Packet Details</h4><div>In each UDP packet sent in this protocol there is a leading header:</div><div><ol><li>A constant 32-bit \"magic\" integer number to reduce the risk of interpreting a random missent packet from another application as a valid packet in this protocol.</li><li>A 32-bit integer version number that should be increased when the packet format is changed in a way that is not backward compatible. If only appending new values to the packet payload format, then the version number normally does not need to change because extra content at the end should be ignored by the receiver.</li><li>A 16-bit integer packet sequence number incremented by the sender for each packet. The counter is independent for each direction. When a counter value exceeds 16 bits, it wraps around to zero again.</li><li>A 16-bit integer received packet sequence number containing a copy of the packet sequence number from the last received packet in the reverse direction. In the Python script of this example, the last packet in each direction is written to temporary files to remember these sequence numbers, but in a typical hardware/external I/O application, it normally is much easier to use internal variables instead.</li></ol><div>followed by a payload:</div></div><div><ol><li>A vector of 32-bit integer values.</li><li>A vector of 32-bit float values.</li></ol><div>All values are stored as little endian. A protocol implementation for one particular external system will need a fixed packet format in each direction. For each direction, all of these must be defined:</div></div><div><ul><li>Address/IP (in this example, localhost is assumed) and port of the receiving end.</li><li>Header version number.</li><li>Payload vector sizes.</li><li>Meta information for each value in the payload vectors.</li></ul></div>
</body></html>"));
end Site1;
