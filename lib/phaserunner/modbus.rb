require 'rmodbus'
require 'json'
require 'asi_bod'

# Add mechanism to convert Integers from modbus into signed integers
class Integer
  def to_signed(bits)
    mask = (1 << (bits - 1))
    (self & ~mask) - (self & mask)
  end
end

module Phaserunner
  # Methods for communicating with the Modbus interface to the Phaserunner
  class Modbus

    # Struct to represent a run length encode set of registers
    RegistersRunLength = Struct.new(:start, :count)

    # Returns the path to the default BODm.json file
    def self.default_file_path
      AsiBod::Bod.default_file_path
    end

    # Build up an array of RegistersRunLength structs that represent the ranges
    # of registers to log
    register_list = [RegistersRunLength.new(258, 18)]
    register_list << RegistersRunLength.new(276, 2)
    register_list << RegistersRunLength.new(282, 6)
    register_list << RegistersRunLength.new(334, 4)

    DEFAULTS = {
      tty: '/dev/ttyUSB0',
      baudrate: 115200,
      slave_id: 1,
      dictionary_file: default_file_path,
      loop_count: :forever,
      quiet: false,
      register_list: register_list
    }

    attr_reader :tty
    attr_reader :baudrate
    attr_reader :slave_id
    attr_reader :dictionary_file
    attr_reader :loop_count
    attr_reader :quiet

    # The registers of interest for logging
    # @paramds [Array<RegistersRunLength>] register_list
    # @option register_list [Integer] :start Starting register Index
    # @option register_list [Integer] :count Number of registers to return
    attr_reader :register_list

    # Contains the Grin Phaesrunner Modbus Dictionary
    # @params [Hash<Integer, Hash>] dict The Dictionary with a key for each register address
    # @option dict [String] :name Name of the register
    # @option dict [Integer] :address Address of register
    # @option dict [Integer] :accessLevel Access Level of register
    # @option dict [Boolean] :read If the register can be read
    # @option dict [Boolean] :write If the register can be written
    # @option dict [Boolean] :saved If the register has been saved
    # @option dict [Integer,Float,String] :scale How to scale the raw value
    # @option dict [String] :units The units for the value
    # @option dict [Stirng] :type Further info on how to interpret the value
    attr_reader :dict

    attr_reader :bod

    # New Modbus
    #  Converts the opts hash into Class Instance Variables (attr_readers)
    #  Reads the JSON Grin Phaserunner Modbus Dictionary into a Hash
    # @params opts [Hash] comes from the CLI
    def initialize(opts)
      # Start with defaults and allow input args to override them
      final_opts = DEFAULTS.merge opts

      # Converts each key of the opts hash from the CLI into individual class attr_readers.
      # So they are now available to the rest of this Class as instance variables.
      # The key of the hash becomes the name of the instance variable.
      # They are available to all the methods of this class
      # See https://stackoverflow.com/a/7527916/38841
      final_opts.each_pair do |name, value|
        self.class.send(:attr_accessor, name)
        instance_variable_set("@#{name}", value)
      end

      # A few other Instance Variables
      @bod = AsiBod::Bod.new(bod_file: dictionary_file)
      @dict = @bod.hash_data
    end

    def read_raw_range(start_address, count)
      cl = ::ModBus::RTUClient.new(tty, baudrate)
      cl.with_slave(slave_id) do |slave|
        slave.read_holding_registers(start_address, count)
      end
    end

    def read_scaled_range(start_address, count)
      data = read_raw_range(start_address, count)
      data.map.with_index do |val, index| 
        address = index + start_address
        if dict[address][:type] == "independent"
          value = val.to_signed(16) / dict[address][:scale]
          value
        elsif dict[address][:type].downcase == "bit vector"
          value = val.to_s(2)
        else
          value = val
        end
        value
      end

    end
    def range_address_header(start_address, count)
      end_address = start_address + count 
      (start_address...end_address).map do |address|
        units = case dict[address][:type].downcase
                when "bit vector"
                  "Flags"
                when "enum"
                  "enum"
                when "dependent"
                  "Unscaled #{dict[address][:units]}"
                else
                  dict[address][:units]
                end
        "#{dict[address][:name]} (#{units})"
      end
    end

    def read_addresses(addresses)
      addresses.map do |address|
        read_raw_range(address, 1)
      end
    end

    def bulk_addresses_header(addresses)
      addresses.map do |address|
        "#{dict[address][:name]} (#{dict[address][:units]})"
      end
    end

    # More optimized data fetch. Gets an array of address range structs
    # @param register_list [Array<RegistersRunLength] Register ranges to log. Optional, has a default
    # @return [Array<Integer>] List of the register values in the order requested
    def bulk_log_data(registers = register_list)
      registers.map do |reg|
        read_scaled_range(reg.start, reg.count)
      end.flatten
    end

    # Get the headers for the bulk_log data
    # @param register_list [Array<RegistersRunLength] Register ranges to log. Optional, has a default
    # @return [Array<String>] Array of the headers
    def bulk_log_header(registers = register_list)
      registers.map do |reg|
        range_address_header(reg.start, reg.count)
      end.flatten
    end
  end
end
