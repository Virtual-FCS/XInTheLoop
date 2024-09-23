# XInTheLoop Library

XInTheLoop is a Modelica library for interfacing a model with an external system for continuous interaction during simulation of the model. The external system in this case is a software tightly coupled with e.g. a physical process hardware, some user interface, another model simulation, a computational service, or some other software service.

A generic UDP based protocol is developed to exchange values between the Modelica model and the external system in both directions at regular intervals.

Together with a set of generic support blocks, it should be easy to implement your own blocks for interfacing one particular external system.

The external system can be developed in any language/framework that support UDP communication. An [included Python script](XInTheLoop/Resources/tools/site1-protocol.py) for debugging the UDP communication can be used as inspiration.

## Site1 Example

The Site1 example is a test model and interfacing blocks for one particular external FCS system containing a fuel cell, a DC-to-DC-converter, a battery, and a variable load.

## Dependencies

- Modelica v4.0.0
- Modelica_DeviceDrivers v2.1.1

## Known Issue

Due to a [bug in OMEdit v1.20 for Windows](https://github.com/OpenModelica/OpenModelica/issues/10132), models using this library from that OMEdit version need to add `-lws2_32` to the _C/C++ Compiler Flags (Optional)_ in the _General_ tab of _Simulation Setup_ to compensate for the bug as described in https://github.com/modelica-3rdparty/Modelica_DeviceDrivers/issues/369.
