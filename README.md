# phaserunner 

Read values from the Grin PhaseRunner Controller for logging

[![Gem Version Badge](https://badge.fury.io/rb/phaserunner.svg)](https://badge.fury.io/rb/phaserunner)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

* Ruby ~2.4 or ~2.5
* Bundler

Bundler / Gemspec automatically pulls in all the dependencies

### Installing for doing development

The usual Ruby install from github

```
git clone git@github.com:rberger/phaserunner.git
cd phaserunner
bundle install
```

### Usage

To get help:

```
bundle exec exe/phaserunner  help
NAME
    phaserunner - Read values from the Grin PhaseRunner Controller primarily for logging

SYNOPSIS
    phaserunner [global options] command [command options] [arguments...]

VERSION
    0.2.0

GLOBAL OPTIONS
    -t, --tty=arg             - Serial (USB) device (default: /dev/ttyUSB0)
    -b, --baudrate=arg        - Serial port baudrate (default: 115200)
    -s, --slave_id=arg        - Modbus slave ID (default: 1)
    -d, --dictionary_file=arg - Path to json file that contains Grin Modbus Dictionary (default:
                                /Users/rberger/.rvm/gems/ruby-2.4.1/gems/asi_bod-0.1.5/BODm.json)
    -l, --loop_count=arg      - Loop the command n times (default: forever)
    --version                 - Display the program version
    -q, --[no-]quiet          - Do not output to stdout
    --help                    - Show this message

COMMANDS
    help          - Shows a list of commands or help for one command
    read_register - Read a single or multiple adjacent registers from and address
    log           - Logs interesting Phaserunner registers to stdout and file
```

### Phaserunner Registers logged

At this time the scaling factors are __NOT__ applied to the log output. 

|Name|Index|Desc|Scale|Units|
|---|---|---|---|---|
|Timestamp | | ISO 8601 Timestamp| 1  | Time |
|Faults| 258 | Faults Bitmap|1|Bitmap
|Controller Temperature|259|Base plate temperature|1|deg Celsius|
|Vehicle Speed|260|Calculated vehicle speed|256|Km/hour|
|Motor Temperature|261|Motor temperature |1|deg Celsius|
|Motor Current|262|Motor peak current |32|Amps|
|Motor RPM|263|Motor speed |1|RPM|
|Motor Speed|264|Motor speed|40.96|% of rated rpm|
|Battery Voltage|265|Measured battery voltage|32|Volts|
|Battery Current|266|Measured battery amperage|32|Amps|
|Battery State of Charge|267|Remaining battery capacity|32|%|
|Battery Power|268|Calculated battery output power|1|Watts|
|Last Fault|269|Last Fault Bitmap|1|Bitmap|
|Throttle Voltage|270|Filtered throttle voltage|4096|Volts|
|Brake 1 Voltage|271|Filtered brake 1 voltage|4096|Volts|
|Brake 2 Voltage|272|Filtered brake 2 voltage|4096|Volts|
|Raw Controller Temperature Sensor Voltage|273|Unfiltered controller temperature sensor voltage|4096|Volts|
|Digital Inputs|276|Digital Inputs Bitmap|1|Bitmap|
|Warnings|277|Warnings Bitmap|1|Bitmap|
|Phase A Current|282|Measured motor phase A current|32|Amps|
|Phase B Current|283|Calculated motor phase B current|32|Amps|
|Phase C Current|284|Measured motor phase C current|32|Amps|
|Phase A Voltage|285|Measured instantaneous motor phase A voltage|32|Volts|
|Phase B Voltage|286|Measured instantaneous motor phase B voltage|32|Volts|
|Phase C Voltage|287|Measured instantaneous motor phase C voltage|32|Volts|
|Motor Input Power|334|Motor input power in Watts|1|W|
|Torque Command|335|Requested motor torque from sensors before rate limiting|4096|pu|
|Torque Reference|336|Requested motor torque after rate limiting|4096|pu|
|Speed (Ref/Limit) Command|337|Speed limit in local mode|4096|pu|

## Running the tests

Unfortunately there are no real tests (yet, Pull Requests Welcome!)

## Deployment

Deploy as usual. If you are not doing it from a git clone just want to install from Rubygems:

```
gem install phaserunner
```

## Built With

* [Ruby](https://www.ruby-lang.org/) - Language
* [Bundler](http://bundler.io) - Package / Dependency Management
* [asi_bod](https://rubygems.org/gems/asi_bod) - Grin Phaserunner / [Accelerated System](http://accelerated-systems.com) Register Defs
* [Grin Tech Phaserunner](http://www.ebikes.ca/product-info/phaserunner.html) - Controller were interfacing to

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rberger/rmodbus_cli.


### Code of Conduct in Contriubing

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the  [Contributor Code of Conduct](CODE_OF_CONDUCT.md).

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/rberger/phaserunner/tags). 

## Authors

* **[Robert Berger](https://github.com/rberger)**

## License and Copyright

This project is licensed under the MIT License - see the [LICENSE](LICENSE.txt) file for details

* Copyright (c) 2018 Robert J. Berger
