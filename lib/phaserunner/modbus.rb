require 'rmodbus'
require 'json'
require 'asi_bod'

module Phaserunner
  # Methods for communicating with the Modbus interface to the Phaserunner
  class Modbus

    # Returns the path to the default BODm.json file
    def self.default_file_path
      AsiBod::Bod.default_file_path
    end

    DEFAULTS = {
      tty: '/dev/ttyUSB0',
      baudrate: 115200,
      slave_id: 1,
      dictionary_file: default_file_path,
      loop_count: :forever,
      quiet: false,
      no_scale: false,
      registers_start_address: 258,
      registers_count: 13,
      registers_misc: [277,325,334]
    }

    attr_reader :tty
    attr_reader :baudrate
    attr_reader :slave_id
    attr_reader :dictionary_file
    attr_reader :loop_count
    attr_reader :quiet

    # If set, the read_register will not apply the scale to the raw register data
    attr_reader :no_scale

    # The registers of interest for logging
    # First a range
    attr_reader :registers_start_address
    attr_reader :registers_count
    # Sparse Registers of interest
    attr_reader :registers_misc

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

    def convert_to_signed_binary(binary)
      binary_int = binary.to_i
      if binary_int >= 2**15
        binary_int - 2**16
      else
        binary_int
      end
    end

    # Read a range of registers from the Phaserunner modbus
    #   Ensures that it wraps the signed 16bit register values to a proper signed Ruby Integer
    #   Obeys the no_scale parameter set in the initializer.
    # @param start_address [Integer] the starting address of register[s] to read
    # @param count [Integer] number of contiguous registers to read. Defaults to 1
    # @return [Array] 
    def read_registers(start_address, count=1)
      cl = ::ModBus::RTUClient.new(tty, baudrate)
      cl.with_slave(slave_id) do |slave|
        slave.read_holding_registers(start_address, count).map.with_index do |register, idx|
          binary_register = convert_to_signed_binary(register)
          unless no_scale
            address = start_address + idx
            begin
              scale = FLOAT(dict[address][:scale])
              binary_register / scale
            rescue
              binary_register
            end
          else
            binary_register
          end
        end
      end
    end

    def range_address_header(start_address, count)
      end_address = start_address + count 
      (start_address...end_address).map do |address|
        "#{dict[address][:name]} (#{dict[address][:units]})"
      end
    end

    def read_addresses(addresses)
      addresses.map do |address|
        read_registers(address, 1)
      end
    end

    def bulk_addresses_header(addresses)
      addresses.map do |address|
        "#{dict[address][:name]} (#{dict[address][:units]})"
      end
    end

    # More optimized data fetch. Gets an address range + misc individual addresses
    # @param start_address [Integer] Initial address of the range. Optional, has a default
    # @param count [Integer] Count of addresses in range. Optional, has a default
    # @param misc_addresses [Array<Integer>] List of misc individual addresses. Optional, has a default
    # @return [Array<Integer>] List of the register values in the order requested
    def bulk_log_data(start_address = registers_start_address,
                      count = registers_count,
                      misc_addresses = registers_misc)
      read_registers(start_address, count) + read_addresses(misc_addresses)
    end

    # Get the headers for the bulk_log data
    # @param start_address [Integer] Initial address of the range. Optional, has a default
    # @param count [Integer] Count of addresses in range. Optional, has a default
    # @param misc_addresses [Array<Integer>] List of misc individual addresses.  Optional, has a default
    # @return [Array<String>] Array of the headers
    def bulk_log_header(start_address = registers_start_address,
                        count = registers_count,
                        misc_addresses = registers_misc)
      range_address_header(start_address, count) +
        bulk_addresses_header(misc_addresses)
    end
  end
end
