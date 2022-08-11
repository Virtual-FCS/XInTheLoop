within XInTheLoop;

package Functions
  "Helper functions and extern \"C\" function wrappers with implementations in Resources/Include folder"
  extends Modelica.Icons.FunctionsPackage;

  function int2hex "Convert integer value to hexadecimal string"
    extends Modelica.Icons.Function;
    input Integer value "Integer value";
    input Integer n_digits(min = 0) = 8 "Number of hexadecimal digits";
    output String hex "Fixed size hexadecimal string";
    external "C" hex=int2hex(value, n_digits);
    annotation(Include = "#include \"int2hex.c\"");
  end int2hex;

  function bitmask "Bitmask that contains a number of consecutive least significant 1-bits"
    extends Modelica.Icons.Function;
    input Integer b(min=0, max=32) "Number of bits in bitmask";
    output Integer mask "Bitmask with b number of least significat bits equal one";
  algorithm
    mask := lshift_int(1, b) - 1;
  end bitmask;

  function and_bitmask "Bitwise AND between 32 bit integer and a bitmask"
    extends Modelica.Icons.Function;
    input Integer a "Left integer";
    input Integer b "Number of bits in bitmask";
    output Integer y "Result integer";
  algorithm
    y := and_ints(a, bitmask(b));
  end and_bitmask;

  function and_ints "Bitwise AND between two 32 bit integers"
    extends Modelica.Icons.Function;
    input Integer a "Left integer";
    input Integer b "Right integer";
    output Integer y "Result integer";
    external "C" y=and_ints(a, b);
    annotation(Include = "#include \"and_ints.c\"");
  end and_ints;

  function or_ints "Bitwise OR between two 32 bit integers"
    extends Modelica.Icons.Function;
    input Integer a "Left integer";
    input Integer b "Right integer";
    output Integer y "Result integer";
    external "C" y=or_ints(a, b);
    annotation(Include = "#include \"or_ints.c\"");
  end or_ints;

  function lshift_int "Bitwise LEFT SHIFT of 32 bit integer"
    extends Modelica.Icons.Function;
    input Integer a "Input integer";
    input Integer b "Number of bits to shift";
    output Integer y "Result integer";
    external "C" y=lshift_int(a, b);
    annotation(Include = "#include \"lshift_int.c\"");
  end lshift_int;

  function rshift_int "Bitwise RIGHT SHIFT of signed 32 bit integer"
    extends Modelica.Icons.Function;
    input Integer a "Input integer";
    input Integer b "Number of bits to shift";
    output Integer y "Result integer";
    external "C" y=rshift_int(a, b);
    annotation(Include = "#include \"rshift_int.c\"");
  end rshift_int;

  function rshift_uint "Bitwise RIGHT SHIFT of unsigned 32 bit integer"
    extends Modelica.Icons.Function;
    input Integer a "Input integer";
    input Integer b "Number of bits to shift";
    output Integer y "Result integer";
    external "C" y=rshift_uint(a, b);
    annotation(Include = "#include \"rshift_uint.c\"");
  end rshift_uint;

end Functions;
