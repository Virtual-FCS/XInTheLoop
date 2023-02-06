package XInTheLoop "Components for X-in-the-Loop functionality"
  extends Modelica.Icons.Package;
  extends Icons.XInTheLoop;
    annotation(
      preferredView="info",
      version="0.2.0-dev",
      uses(Modelica(version="4.0.0"), Modelica_DeviceDrivers(version="2.1.0")),
  Documentation(info = "<html><head></head><body>This package enables an external system in the loop while simulating your model. A typical use case is to exchange the needed set of values between a high-level controller model and a low level hardware controller process.<div><br></div>
<div>In our <a href=\"modelica://XInTheLoop.Examples.Site1\">main example</a>, the hardware is a Fuel Cell System (FCS) that consists of a Fuel Cell, a DC-DC-converter, a battery, and a variable load. The UDP protocol between the model and the low-level hardware controller is adapted to this, but any user can make customized versions to support other external systems by reusing a set of generic blocks.
<h4>Development</h4>
<div>This package has been developed as part of the Virtual-FCS project. The main packet <a href=\"modelica://VirtualFCS\">VirtualFCS</a>&nbsp;can be used to build advanced FCS models, and then combined with this packet to include an external system in the loop.</div>
<h4>Contact</h4>
<div><a href=\"https://www.virtual-fcs.eu\">www.virtual-fcs.eu</a></div>
<h4>Funding</h4>
<div>This project has received funding from the European Union's Horizon 2020 research and innovation programme under grant agreement No 875087.</div>
<div>Programme: H2020-EU.3.4.6.1. - Reduce the production cost of fuel cell systems to be used in transportation applications, while increasing their lifetime to levels which can compete with conventional technologies.</div>
<div>Topic: FCH-01-3-2019 - Cyber-physical platform for hybrid Fuel Cell Systems.</div>
</div></body></html>", revisions = "<html><head></head><body>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\"><tbody>
<tr><td>Future version</td><td>Not yet released</td><td>Enhanced documentation, and support <a href=\"modelica://Modelica\">Modelica</a> v4.</td></tr>
<tr><td>Version 0.1.0-beta</td><td>2022-11-29</td><td>Initial public release.</td></tr>
</tbody></table>
</body></html>"));
end XInTheLoop;
