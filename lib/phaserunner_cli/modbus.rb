require "rmodbus"
require "json"

module RmodbusCli
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

      @dict = clean_dict(JSON.parse(File.read(dictionary_file)))
    end

    # Make the Dictionary an pleasant hash with Integer top keys (addresses) and
    # symbols for other keys
    # @params [Hash<String, Hash>] original_dict The Dictionary as it came from JSON
    def clean_dict(original_dict)
      original_dict.each_with_object({}) do |(k, v), memo|
        memo[k.to_i] = clean_node(v)
      end
    end

    def clean_node(node)
      node.each_with_object({}) do |(k, v), memo|
        memo[k.to_sym] = v
      end
    end

    def read_value(start_address, count)
      puts("Reading from #{dict[start_address][:name]} scale: #{dict[start_address][:scale]} units: #{dict[start_address][:units]}")
      cl = ::ModBus::RTUClient.new(tty, baudrate)
      cl.with_slave(slave_id) do |slave|
        puts "Foo #{slave.read_holding_registers(start_address, count).inspect}"
      end
    end
  end
end

