within XInTheLoop.Blocks;

package Customized "Customized versions of blocks from other libraries"
  extends Modelica.Icons.Package;

  block IntegerTable "An extension of Modelica.Blocks.Sources.IntegerTable that also shows the table parameter value"
    extends Modelica.Blocks.Sources.IntegerTable;
    annotation(
      Icon(graphics = {Text(extent = {{-200, -110}, {200, -140}}, textString = "%table")}));
  end IntegerTable;

  block ResetPointer "An extension of Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.ResetPointer that also triggers an output for each message sent by a block earlier in the package connection chain"
    extends Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.ResetPointer;
    Modelica.Blocks.Interfaces.BooleanInput outputTrigger "Activated for each message sent" annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  equation
    outputTrigger = pkgIn.trigger;
  end ResetPointer;

  block UDPSendTrig "An extension of Modelica_DeviceDrivers.Blocks.Communication.UDPSend that also triggers an output for each message sent"
    extends Modelica_DeviceDrivers.Blocks.Communication.UDPSend;
    Modelica.Blocks.Interfaces.BooleanInput outputTrigger "Activated for each message sent" annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  equation
    outputTrigger = pkgIn.trigger;
  end UDPSendTrig;

  block TCPIP_Client_IO "A custom version of Modelica_DeviceDrivers.Blocks.Communication.TCPIP_Client_IO that allows limiting send size"
    import Modelica_DeviceDrivers;
    import Modelica_DeviceDrivers.Blocks.Interfaces;
    extends Modelica_DeviceDrivers.Utilities.Icons.BaseIcon;
    extends Modelica_DeviceDrivers.Utilities.Icons.TCPIPconnection;
    extends
      Modelica_DeviceDrivers.Blocks.Communication.Internal.PartialSampleTrigger;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Communication.TCPIPSocketClient;

    parameter String IPAddress="127.0.0.1" "IP address of remote TCP/IP server";
    parameter Integer port=10002 "Port of the TCP/IP server";
    parameter Integer outputBufferSize=16*1024
      "Buffer size of message data in bytes." annotation(Dialog(group="Outgoing data"));
    parameter Integer inputBufferSize=16*1024
      "Buffer size of message data in bytes." annotation(Dialog(group="Incoming data"));
    Interfaces.PackageIn pkgIn annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={-108,0})));
    Interfaces.PackageOut pkgOut(pkg = SerialPackager(inputBufferSize), dummy(start=0, fixed=true))
                                       annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={108,0})));
    Integer outputSendSize(min=0, max=outputBufferSize)=outputBufferSize
      "Send size of message data in bytes." annotation(Dialog(group="Outgoing data"));
  protected
    TCPIPSocketClient socket = TCPIPSocketClient();
    Boolean isConnected(start=false, fixed=true);
  equation
    when initial() then
      pkgIn.userPkgBitSize = outputBufferSize*8;
      pkgIn.autoPkgBitSize = 0;
      isConnected = Modelica_DeviceDrivers.Communication.TCPIPSocketClient_.connect_(socket, IPAddress, port);
    end when;
    pkgIn.backwardTrigger = actTrigger "using inherited trigger";
    pkgOut.trigger = pkgIn.backwardTrigger;
    when pkgIn.backwardTrigger then
      if isConnected then
        pkgOut.dummy = Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.readTCPIPServer(
          socket,
          pkgOut.pkg,
          inputBufferSize,
          Modelica_DeviceDrivers.Blocks.Communication.Internal.DummyFunctions.sendToTCPIPServer(
            socket,
            pkgIn.pkg,
            outputSendSize,
            pkgIn.dummy));
      else
        pkgOut.dummy = pkgIn.dummy;
      end if;
    end when;
    annotation (preferredView="info",
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Text(extent={{-150,136},{150,96}},
              textString="%name")}), Documentation(info="<html>
  <p>Supports sending/receiving of packets to/from a server over TCP/IP.</p>
  </html>"));
  end TCPIP_Client_IO;

  annotation(
    Icon(graphics = {Text(origin = {3, -2}, lineColor = {128, 128, 128}, extent = {{-103, 102}, {97, -98}}, textString = "C")}, coordinateSystem(initialScale = 0.1)));
end Customized;
