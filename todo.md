## Things to measure
* 258 Reading from Faults
* 262, Motor Current, Motor peak current
* 265, battery voltage, 32, Volts
* 266, Battery Current, Measured battery amperage
* 270, Throttle Voltage, Filtered throttle voltage, 4096
* 277, warnings, bit vector,
* 281 DSP Core Temperature

## Maybe:
* 260, vehicle speed, 256, km/hr
* 268, battery power, 1, Watts
* 269, last fault, bit vector,
* 273, raw controller temperature sensor voltage, 4096, Volts
* 277, warnings, bit vector,
* 328, instantaneous pedal speed, 64, RPM
* 334, motor input power, 1, W

## One of:
* 263, Motor RPM, Motor speed , 1
* 311, Wheel RPM (Speed Sensor Based), Calculated wheel speed based on wheel speed sensor, 16
* 312, Wheel RPM (Motor Based), Calculated wheel speed based on motor pole pairs, 16
* 313, Measured Wheel RPM, Measured wheel speed, 16


## DO
* 258 Reading from Faults
* 259, Controller Temperature, Base plate temperature, 1, deg Celsius
* 260, vehicle speed, 256, km/hr, 256, Km/hour
* 262, Motor Current, Motor peak current, 32, Amps
* 263, Motor RPM, Motor speed , 1, RPM
* 264, Motor Speed, Motor speed, 40.96, % of rated rpm
* 265, battery voltage, 32, Volts
* 266, Battery Current, Measured battery amperage, 32, Amps
* 267, Battery State of Charge, Remaining battery capacity, 32, %
* 268, Battery Power, Calculated battery output power, 1, Watts
* 269, Last Fault
* 270, Throttle Voltage, Filtered throttle voltage, 4096, Volts
* 277, warnings, bit vector,
* 334, motor input power, 1, W
