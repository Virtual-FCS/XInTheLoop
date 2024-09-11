package XInTheLoop "Components for X-in-the-Loop functionality"
  extends Modelica.Icons.Package;
  extends Icons.XInTheLoop;
  annotation(
    preferredView = "info",
    version = "0.2.1-dev",
    uses(Modelica(version = "4.0.0"), Modelica_DeviceDrivers(version = "2.1.1")),
    Documentation(info = "<html><head></head><body>
<p>This library enables an external system in the loop while simulating a model. A typical use case is to exchange the needed set of values between a high-level controller model and a low level hardware controller process.</p>
<p>In our <a href=\"modelica://XInTheLoop.Examples.Site1\">main example</a>, the hardware is a Fuel Cell System (FCS) that consists of a Fuel Cell, a DC-DC-converter, a battery, and a variable load. The UDP protocol between the model and the low-level hardware controller is adapted to this, but any user can make customized versions to support other external systems by reusing a set of generic blocks.</p>
<h4>Known Issue</h4>
<p>Due to a <a href=\"https://github.com/OpenModelica/OpenModelica/issues/10132\">bug in OMEdit v1.20 for Windows</a>,
models using this library from that OMEdit version need to add <tt>-lws2_32</tt> to the <i>C/C++ Compiler Flags (Optional)</i> in the <i>General</i> tab of <i>Simulation Setup</i> to compensate for the bug as described in <a href=\"https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/369\">Modelica_DeviceDrivers#369</a>.</p>
<p>The bug is still present in OMEdit v1.23.1 for Windows.</p>
<h4>Development</h4>
<p>The base of this library has been developed as part of the Virtual-FCS project. The main library&nbsp;<a href=\"modelica://VirtualFCS\">VirtualFCS</a>&nbsp;can be used to build advanced FCS models, and then combined with this library to include an external system in the loop.</p>
<p>This library has been further developed as part of the StasHH project.</p>
<h4>Contact</h4>
<ul>
<li><a href=\"https://www.virtual-fcs.eu\">www.virtual-fcs.eu</a></li>
<li><a href=\"https://www.stashh.eu\">www.stashh.eu</a></li>
</ul>
<h4>Funding</h4>
<ul>
<li>The Virtual-FCS project has received funding from the Fuel Cells and Hydrogen 2 Joint Undertaking (now Clean Hydrogen Partnership) under Grant Agreement No. 875087.</li>
<li>The StasHH project has received funding from the same Joint Undertaking under Grant Agreement No. 101005934.</li>
<li>This Joint Undertaking receives support from the European Union's Horizon 2020 Research and Innovation Program, Hydrogen Europe and Hydrogen Europe Research.</li>
</ul>
<h4>License</h4>
This library is shared under an MIT license. For more information, please see the LICENSE file.
</body></html>", revisions = "<html><head></head><body>
<p>
<a href=\"https://doi.org/10.5281/zenodo.7697300\"><img src=\"https://zenodo.org/badge/DOI/10.5281/zenodo.7697300.svg\" alt=\"DOI 10.5281/zenodo.7697300\"></a>
is the DOI number to use when citing all (including future) versions of this library.
When clicking the DOI above, it will resolve to the DOI information of the currently latest version, and the same page also contains a section with DOI numbers to use for each released version when citing one particular version.
</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\"><tbody>
<tr><th>Version</th><th>Released</th><th>Description</th></tr>
<!-- DOI for the latest version is created AFTER the release, and is therefore not known when describing it here -->
<!--
<tr><td>Future version</td><td>Not yet released</td><td>Enhanced documentation?</td></tr>
-->
<tr><td>0.2.0-beta</td><td>2023-04-25</td>
<td>Live demonstration at M40 meeting - supporting external EMS and <a href=\"modelica://Modelica\">Modelica Standard Library</a> v4.0.0</td></tr>
<tr><td>0.1.1-beta</td><td>2022-11-29</td>
<td>Live demonstration at M36 meeting</td></tr>
<tr><td>0.1.0</td><td>2022-09-09</td>
<td>Initial release</td></tr>
</tbody></table>
</body></html>"));
end XInTheLoop;
