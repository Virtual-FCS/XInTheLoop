within XInTheLoop.Blocks;

package Bitwise "Bitwise integer operation blocks"
  extends Modelica.Icons.Package;
  import XInTheLoop.Functions;

  block AndInts "Output bitwise AND between input 32 bit integers"
    extends Modelica.Blocks.Interfaces.PartialIntegerMISO;
    extends Icons.Bitwise;
    extends Icons.Par_b;
    parameter Integer b = -1 "32 bit integer to bitwise AND with input";
  algorithm
    y := b;
    for i in 1:nu loop
      y := Functions.and_ints(u[i], y);
    end for;
    annotation(
      Icon(graphics = {Text(origin = {-123, 66}, extent = {{21, -26}, {225, -106}}, textString = "AND")}),
  Documentation(info = "<html><head></head><body>
Output bitwise AND between input 32 bit integers.
</body></html>"));
  end AndInts;

  block OrInts "Output bitwise OR between input 32 bit integers"
    extends Modelica.Blocks.Interfaces.PartialIntegerMISO;
    extends Icons.Bitwise;
    extends Icons.Par_b;
    parameter Integer b = 0 "32 bit integer to bitwise OR with input";
  algorithm
    y := b;
    for i in 1:nu loop
      y := Functions.or_ints(u[i], y);
    end for;
    annotation(
      Icon(graphics = {Text(origin = {-123, 66}, extent = {{21, -26}, {225, -106}}, textString = "OR")}),
      Documentation(info = "<html><head></head><body>
Output bitwise OR between input 32 bit integers.
</body></html>"));
  end OrInts;

  block LeftShiftInt "Output bitwise LEFT SHIFT of input 32 bit integer"
    extends Modelica.Blocks.Interfaces.PartialIntegerSISO;
    extends Icons.Bitwise;
    parameter Integer b(min = 0) = 0 "Number of bits to shift";
  algorithm
    y := Functions.lshift_int(u, b);
    annotation(
      Icon(graphics = {Text(origin = {-123, 66}, extent = {{21, -26}, {225, -106}}, textString = "<<%b")}),
      Documentation(info = "<html><head></head><body>
Output bitwise LEFT SHIFT of input 32 bit integer.
</body></html>"));
  end LeftShiftInt;

  block RightShiftInt "Output bitwise RIGHT SHIFT of input signed 32 bit integer"
    extends Modelica.Blocks.Interfaces.PartialIntegerSISO;
    extends Icons.Bitwise;
    parameter Integer b(min = 0) = 0 "Number of bits to shift";
  algorithm
    y := Functions.rshift_int(u, b);
    annotation(
      Icon(graphics = {Text(origin = {-123, 66}, extent = {{21, -26}, {225, -106}}, textString = "s>>%b")}),
      Documentation(info = "<html><head></head><body>
Output bitwise RIGHT SHIFT of input signed 32 bit integer.
</body></html>"));
  end RightShiftInt;

  block RightShiftUInt "Output bitwise RIGHT SHIFT of input unsigned 32 bit integer"
    extends Modelica.Blocks.Interfaces.PartialIntegerSISO;
    extends Icons.Bitwise;
    parameter Integer b(min = 0) = 0 "Number of bits to shift";
  algorithm
    y := Functions.rshift_uint(u, b);
    annotation(
      Icon(graphics = {Text(origin = {-123, 66}, extent = {{21, -26}, {225, -106}}, textString = "u>>%b")}),
      Documentation(info = "<html><head></head><body>
Output bitwise RIGHT SHIFT of input unsigned 32 bit integer.
</body></html>"));
  end RightShiftUInt;

  block PackInt "Pack specified number of bits into densely packed bits of 32 bit integer output"
    extends Modelica.Blocks.Interfaces.PartialIntegerMISO;
    extends Icons.BitPack;
    extends Icons.Par_n_bits;
    parameter Integer n_bits[nu](each min = 1, each max = 32) = {32} "Number of bits to pack from each input unpacked integer";
    import ModelicaReference.Operators.'assert()';
    import XInTheLoop.Functions.and_bitmask;
    import XInTheLoop.Functions.lshift_int;
  algorithm
    assert(min(n_bits) > 0 and max(n_bits) <= 32, "Each number of bits must be in the range 1..32");
    assert(sum(n_bits) <= 32, "The total number of bits does not fit in the 32 bit integer output");
    y := 0;
//  Loop through inputs from highest to lowest index
//  For each step: Shift accumulated y left and fill the gap with input bits
    for i in nu:(-1):1 loop
      y := lshift_int(y, n_bits[i]) + and_bitmask(u[i], n_bits[i]);
    end for;
  annotation(
      Documentation(info = "<html><head></head><body>
Pack specified number of bits from input integer vector into densely packed bits of 32 bit integer output.
</body></html>"));
end PackInt;

  block UnpackInt "Unpack specified number of bits from densely packed bits of 32 bit integer input"
    extends Modelica.Blocks.Icons.IntegerBlock;
    extends Icons.BitUnpack;
    extends Icons.Par_n_bits;
    parameter Integer n_bits[:](each min = 1, each max = 32) = {32} "Number of bits to unpack into each output unpacked integer";
    Modelica.Blocks.Interfaces.IntegerInput u annotation(
      Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Interfaces.IntegerOutput y[size(n_bits, 1)] annotation(
      Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    import ModelicaReference.Operators.'assert()';
    Integer temp;
  algorithm
    assert(min(n_bits) > 0 and max(n_bits) <= 32, "Each number of bits must be in the range 1..32");
    assert(sum(n_bits) <= 32, "The total number of bits does not fit in the 32 bit integer input");
    temp := u;
//  Loop through inputs from lowest to highest index
//  For each step: Output the bits and shift remaining input right
    for i in 1:size(n_bits, 1) loop
      y[i] := Functions.and_bitmask(temp, n_bits[i]);
      temp := Functions.rshift_uint(temp, n_bits[i]);
    end for;
  annotation(
      Documentation(info = "<html><head></head><body>
Unpack specified number of bits from densely packed bits of 32 bit integer input into output integer vector.
</body></html>"));
end UnpackInt;

  block UnpackInt2Bools "Unpack specified number of booleans from densely packed bits of 32 bit integer input"
    extends Modelica.Blocks.Icons.IntegerBlock;
    extends Icons.BitUnpack;
    extends Icons.Par_b;
    parameter Integer b(min = 1, max = 32) = 1 "Number of bits to unpack into separate output booleans";
    Modelica.Blocks.Interfaces.IntegerInput u annotation(
      Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    UnpackInt unpackInt(n_bits = fill(1, b)) annotation(
      Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.BooleanOutput y[b] annotation(
      Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(u, unpackInt.u) annotation(
      Line(points = {{-120, 0}, {-14, 0}, {-14, 0}, {-12, 0}}, color = {255, 127, 0}));
    for i in 1:b loop
//    Discarded alternative (how C would do it): y[i] = not (unpackInt.y[i] == 0);
      y[i] = unpackInt.y[i] >= 1;
    end for;
  annotation(
      Documentation(info = "<html><head></head><body>
Unpack specified number of booleans from densely packed bits of 32 bit integer input into output boolean vector.
</body></html>"));
end UnpackInt2Bools;

  package Icons "Partial blocks with icon annotations for bitwise integer operation blocks"
    extends Modelica.Icons.IconsPackage;

    partial block Bitwise "String of bits to indicate bitwise integer operation block"
      annotation(
        Icon(graphics = {Text(origin = {-104, 64}, extent = {{-16, 20}, {224, -8}}, textString = "01011")}, coordinateSystem(initialScale = 0.1)));
    end Bitwise;

    partial block Par_n_bits "Show value of parameter n_bits below block"
      annotation(
        Icon(graphics = {Text(extent = {{-200, -110}, {200, -140}}, textString = "%n_bits")}));
    end Par_n_bits;

    partial block Par_b "Show value of parameter b below block"
      annotation(
        Icon(graphics = {Text(extent = {{-200, -110}, {200, -140}}, textString = "%b")}));
    end Par_b;

    partial block BitPacking "Separated bit strings below packed bits to indicate bitwise packing operation block"
      extends Bitwise;
      // Might work in future OMEdit versions: constant Color arrowColor = {255, 127, 0} "Color of arrow in icon";
      annotation(
        Icon(graphics = {Text(origin = {-104, -56}, extent = {{-16, 20}, {224, -8}}, textString = "01 | 0 | 1 | 1"), Rectangle(origin = {0, 5}, lineColor = {255, 127, 0}, fillColor = {255, 127, 0}, fillPattern = FillPattern.Solid, extent = {{-20, 35}, {20, -25}})}, coordinateSystem(initialScale = 0.1)));
    end BitPacking;

    partial block BitPack "Up arrow (from separated to packed bits) to indicate bit pack operation block"
      extends BitPacking;
      annotation(
        Icon(graphics = {Polygon(origin = {0, 46}, lineColor = {255, 127, 0}, fillColor = {255, 127, 0}, fillPattern = FillPattern.Solid, points = {{0, 6}, {40, -16}, {-40, -16}, {0, 6}})}));
    end BitPack;

    partial block BitUnpack "Down arrow (from packed to separated bits) to indicate bit unpack operation block"
      extends BitPacking;
      annotation(
        Icon(graphics = {Polygon(origin = {0, 6}, lineColor = {255, 127, 0}, fillColor = {255, 127, 0}, fillPattern = FillPattern.Solid, points = {{0, -36}, {40, -16}, {-40, -16}, {0, -36}})}));
    end BitUnpack;
  end Icons;
  annotation(
    Icon(graphics = {Text(origin = {3, -2}, lineColor = {128, 128, 128}, extent = {{-103, 102}, {97, -98}}, textString = "B")}, coordinateSystem(initialScale = 0.1)));
end Bitwise;
