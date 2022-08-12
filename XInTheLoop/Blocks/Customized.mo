within XInTheLoop.Blocks;

package Customized
  "Customized versions of blocks from other libraries"
  extends Modelica.Icons.Package;

  block IntegerTable
    "An extension of Modelica.Blocks.Sources.IntegerTable that also shows the table parameter value"
    extends Modelica.Blocks.Sources.IntegerTable;
    annotation(
      Icon(graphics = {Text(extent={{-200,-110},{200,-140}}, textString="%table")}));
  end IntegerTable;

  block UDPSendTrig "An extension of Modelica_DeviceDrivers.Blocks.Communication.UDPSend that also triggers an output for each message sent"
    extends Modelica_DeviceDrivers.Blocks.Communication.UDPSend;
    Modelica.Blocks.Interfaces.BooleanInput outputTrigger "Activated for each message sent" annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  equation
    outputTrigger = pkgIn.trigger;
  end UDPSendTrig;

  annotation(
    Icon(graphics = {Text(origin = {3, -2}, lineColor = {128, 128, 128}, extent = {{-103, 102}, {97, -98}}, textString = "C")}, coordinateSystem(initialScale = 0.1)));
end Customized;
