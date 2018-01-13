require 'rmodbus'
require 'json'
require 'asi_bod'

module Phaserunner
  # Methods for communicating with the Modbus interface to the Phaserunner
  class Modbus
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

    # Returns the path to the default BODm.json file
    def self.default_file_path
      AsiBod::Bod.default_file_path
    end

    # New Modbus
    #  Converts the opts hash into Class Instance Variables (attr_readers)
    #  Reads the JSON Grin Phaserunner Modbus Dictionary into a Hash
    # @params opts [Hash] comes from the CLI
    def initialize(opts)
      # Converts each key of the opts hash from the CLI into individual class attr_readers.
      # So they are now available to the rest of this Class as instance variables.
      # The key of the hash becomes the name of the instance variable.
      # They are available to all the methods of this class
      # See https://stackoverflow.com/a/7527916/38841
      opts.each_pair do |name, value|
        self.class.send(:attr_accessor, name)
        instance_variable_set("@#{name}", value)
      end

      @bod = AsiBod::Bod.new(bod_file: dictionary_file)
      @dict = @bod.hash_data
    end

    def read_raw_range(start_address, count)
      #puts("Reading from #{dict[start_address][:name]} scale: #{dict[start_address][:scale]} units: #{dict[start_address][:units]}")
      cl = ::ModBus::RTUClient.new(tty, baudrate)
      cl.with_slave(slave_id) do |slave|
        slave.read_holding_registers(start_address, count)
      end
    end

    def read_range(start_address, count)

    end
    def range_address_header(start_address, count)
      end_address = start_address + count 
      (start_address...end_address).map do |address|
        "#{dict[address][:name]} (#{dict[address][:units]})"
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

    # More optimized data fetch. Gets an address range + misc individual addresses
    # @param start_address [Integer] Initial address of the range
    # @param count [Integer] Count of addresses in range
    # @param misc_addresses [Array<Integer>] List of misc individual addresses
    # @return [Array<Integer>] List of the register values in the order requested
    def bulk_log_data(start_address, count, misc_addresses)
      read_range(start_address, count) +
        read_addresses(misc_addresses)
    end

    # Get the headers for the bulk_log data
    # @param start_address [Integer] Initial address of the range
    # @param count [Integer] Count of addresses in range
    # @param misc_addresses [Array<Integer>] List of misc individual addresses
    # @return [Array<String>] Array of the headers
    def bulk_log_header(start_address, count, misc_addresses)
      range_address_header(start_address, count) +
        bulk_addresses_header(misc_addresses)
    end
  end
end

