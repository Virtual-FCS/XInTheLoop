within XInTheLoop.Examples;

model TestBitwise
  "Test the basic bitwise integer operations"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.SawTooth sawTooth(amplitude = 512, offset = -256, period = 2) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.RealToInteger realToInteger annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathInteger.Product product(nu = 1) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y = 240) annotation(
    Placement(visible = true, transformation(origin = {10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  XInTheLoop.Blocks.Bitwise.AndInts andInts(nu = 2) annotation(
    Placement(visible = true, transformation(origin = {70, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  XInTheLoop.Blocks.Bitwise.OrInts orInts(nu = 2) annotation(
    Placement(visible = true, transformation(origin = {70, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  XInTheLoop.Blocks.Bitwise.LeftShiftInt leftShiftInt(b = 1) annotation(
    Placement(visible = true, transformation(origin = {70, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  XInTheLoop.Blocks.Bitwise.RightShiftInt rightShiftInt(b = 1) annotation(
    Placement(visible = true, transformation(origin = {70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  XInTheLoop.Blocks.Bitwise.RightShiftUInt rightShiftUInt(b = 1) annotation(
    Placement(visible = true, transformation(origin = {70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Bitwise.XorInts xorInts(nu = 2)  annotation(
    Placement(transformation(origin = {70, 80}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(sawTooth.y, realToInteger.u) annotation(
    Line(points = {{-59, 0}, {-42, 0}}, color = {0, 0, 127}));
  connect(realToInteger.y, product.u[1]) annotation(
    Line(points = {{-19, 0}, {0, 0}}, color = {255, 127, 0}));
  connect(product.y, andInts.u[1]) annotation(
    Line(points = {{21.5, 0}, {40, 0}, {40, 50}, {60, 50}}, color = {255, 127, 0}));
  connect(product.y, orInts.u[1]) annotation(
    Line(points = {{21.5, 0}, {40, 0}, {40, 20}, {60, 20}}, color = {255, 127, 0}));
  connect(product.y, leftShiftInt.u) annotation(
    Line(points = {{21.5, 0}, {40, 0}, {40, -10}, {56, -10}}, color = {255, 127, 0}));
  connect(product.y, rightShiftInt.u) annotation(
    Line(points = {{21.5, 0}, {40, 0}, {40, -40}, {56, -40}}, color = {255, 127, 0}));
  connect(product.y, rightShiftUInt.u) annotation(
    Line(points = {{21.5, 0}, {40, 0}, {40, -70}, {56, -70}}, color = {255, 127, 0}));
  connect(integerExpression.y, andInts.u[2]) annotation(
    Line(points = {{21, 40}, {48, 40}, {48, 46}, {60, 46}, {60, 50}}, color = {255, 127, 0}));
  connect(integerExpression.y, orInts.u[2]) annotation(
    Line(points = {{21, 40}, {48, 40}, {48, 24}, {60, 24}, {60, 20}}, color = {255, 127, 0}));
  connect(product.y, xorInts.u[1]) annotation(
    Line(points = {{22, 0}, {40, 0}, {40, 80}, {60, 80}}, color = {255, 127, 0}));
  connect(integerExpression.y, xorInts.u[2]) annotation(
    Line(points = {{22, 40}, {48, 40}, {48, 76}, {60, 76}, {60, 80}}, color = {255, 127, 0}));
protected
  annotation(
    experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-06, Interval = 0.004),
    Documentation(info = "<html><head></head><body>
Test the basic bitwise integer operations.
</body></html>"));
end TestBitwise;
