within XInTheLoop.Examples;

model TestPack
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp ramp(duration = 1, height = 66000, offset = -33000) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.RealToInteger realToInteger annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  XInTheLoop.Blocks.Bitwise.UnpackInt unpackInt(n_bits = {31, 1}) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  XInTheLoop.Blocks.Bitwise.PackInt packInt(n_bits = unpackInt.n_bits, nu = size(unpackInt.y, 1)) annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathInteger.Sum sum(nu = 2, k = {-1, 1}) annotation(
    Placement(visible = true, transformation(origin = {80, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  import ModelicaReference.Operators.'assert()';
  import XInTheLoop.Functions.int2hex;
equation
  connect(ramp.y, realToInteger.u) annotation(
    Line(points = {{-69, 0}, {-52, 0}}, color = {0, 0, 127}));
  connect(realToInteger.y, unpackInt.u) annotation(
    Line(points = {{-29, 0}, {-12, 0}}, color = {255, 127, 0}));
  connect(unpackInt.y, packInt.u) annotation(
    Line(points = {{11, 0}, {30, 0}}, color = {255, 127, 0}));
  connect(realToInteger.y, sum.u[1]) annotation(
    Line(points = {{-28, 0}, {-20, 0}, {-20, -32}, {70, -32}, {70, -30}}, color = {255, 127, 0}));
  connect(packInt.y, sum.u[2]) annotation(
    Line(points = {{52, 0}, {60, 0}, {60, -26}, {70, -26}, {70, -30}}, color = {255, 127, 0}));
  for i in 1:packInt.nu loop
    assert(unpackInt.y[i] == packInt.u[i], "Connected vectors are not equal i=" + String(i));
  end for;
  assert(unpackInt.u == packInt.y, "TestPack: " + int2hex(unpackInt.u) + "->Unpack->Pack->" + int2hex(packInt.y));
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.0151515),
    Documentation(info = "<html><head></head><body>
Test the basic bitwise integer pack and unpack operations. A set of integer values are first unpacked into a vector, then packed into an integer again (using the same n_bits configuration), and finally compute the difference between the input and output integer value. This difference should be zero for all input integer values.
</body></html>"));
end TestPack;
