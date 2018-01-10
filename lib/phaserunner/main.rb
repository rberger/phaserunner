require 'gli'
require 'json'
require 'pp'

module Phaserunner

  class Cli
    attr_reader :modbus
    attr_reader :dict

    include GLI::App

    def main
      program_desc 'Read values from the Grin PhaseRunner Controller for logging'

      version Phaserunner::VERSION

      subcommand_option_handling :normal
      arguments :strict
      sort_help :manually

      desc 'Serial (USB) device'
      default_value '/dev/ttyUSB0'
      arg 'tty'
      flag [:t, :tty]

      desc 'Serial port baudrate'
      default_value 115200
      arg 'baudrate'
      flag [:b, :baudrate]

      desc 'Modbus slave ID'
      default_value 1
      arg 'slave_id'
      flag [:s, :slave_id]

      desc 'Path to json file that contains Grin Modbus Dictionary'
      default_value Modbus.default_file_path
      arg 'dictionary_file'
      flag [:d, :dictionary_file]

      desc 'Loop the command n times'
      default_value 10
      arg 'loop', :optional
      flag [:l, :loop]

      desc 'Read a single or multiple adjacent registers from and address'
      arg_name 'register_address'
      command :read_register do |read_register|
        read_register.desc 'Number of registers to read starting at the Arg Address'
        read_register.default_value 1
        read_register.flag [:c, :count]

        read_register.arg 'address'
        read_register.action do |global_options, options, args|
          address = args.first
          node = dict[address]
          puts "Address: #{address} #{node[:name]} scale: #{node[:scale]} Units: #{node[:units]}}}"
          [0..options[:loop]].each do |i|
            puts modbus.read_range(address, options[:count])
          end
        end
      end

      desc 'Read a bulk sparse set of registers with multiple addresses'
      arg_name 'address0 [address1 ... addressn]'
      command :read_bulk do |read_bulk|
        read_bulk.action do |global_options, options, args|
          puts "read_bulk command ran"
        end
      end

      pre do |global, command, options, args|
        # Pre logic here
        # Return true to proceed; false to abort and not call the
        # chosen command
        # Use skips_pre before a command to skip this block
        # on that command only
        @modbus = Modbus.new(global)
        @dict = @modbus.dict
      end

      post do |global,command,options,args|
        # Post logic here
        # Use skips_post before a command to skip this
        # block on that command only
      end

      on_error do |exception|
        # Error logic here
        # return false to skip default error handling
        true
      end

      exit run(ARGV)
    end
  end
end
