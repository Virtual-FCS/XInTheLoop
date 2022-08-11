within XInTheLoop;

package Icons "Icons for XInTheLoop components"
  extends Modelica.Icons.IconsPackage;

  partial block Loop "Base control loop icon"
    annotation(
      Icon(graphics = {Rectangle(origin = {52, 19}, extent = {{-2, 11}, {14, -9}}), Rectangle(origin = {-6, -51}, extent = {{-2, 11}, {14, -9}}), Ellipse(origin = {-60, 20}, extent = {{-6, 6}, {6, -6}}, endAngle = 360), Line(origin = {-73, 20}, points = {{-7, 0}, {7, 0}}, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 6), Line(origin = {73.622, 20}, points = {{-7, 0}, {7, 0}}, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 6), Line(origin = {-73, 20}, points = {{-7, 0}, {7, 0}}, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 6), Line(origin = {-46.8756, 19.4976}, points = {{-7, 0}, {7, 0}}, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 6), Line(origin = {42.9761, 20}, points = {{-7, 0}, {7, 0}}, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 6), Line(origin = {41.4976, -29.6411}, points = {{28, 50}, {28, -20}, {-34, -20}}, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 6), Line(origin = {-76.488, -44.2105}, points = {{68, -6}, {16, -6}, {16, 58}}, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 6)}, coordinateSystem(initialScale = 0.1)));
  end Loop;

  partial block XInTheLoop "X-in-the-loop icon"
    extends Loop;
    annotation(
      Icon(graphics = {Text(origin = {4, 0}, extent = {{-44, 80}, {36, -40}}, textString = "X", textStyle = {TextStyle.Bold, TextStyle.Bold})}, coordinateSystem(initialScale = 0.1)));
  end XInTheLoop;

  partial block BlocksPackage
    extends Modelica.Icons.Package;
    annotation(
      Icon(graphics = {Line(origin = {-51.25, 0}, points = {{21.25, -35}, {-13.75, -35}, {-13.75, 35}, {20.25, 35}}, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 15), Line(origin = {51.25, 0}, points = {{-21.25, 35}, {13.75, 35}, {13.75, -35}, {-20.25, -35}}, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 15), Rectangle(origin = {0, 35.1488}, fillColor = {255, 255, 255}, extent = {{-30, -20.1488}, {30, 20.1488}}), Rectangle(origin = {0, -34.8512}, fillColor = {255, 255, 255}, extent = {{-30, -20.1488}, {30, 20.1488}})}));
  end BlocksPackage;
end Icons;
