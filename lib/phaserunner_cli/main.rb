require 'gli'

require 'json'
require 'pp'

module PhaserunnerCli

  class Cli

    include GLI::App

    program_desc 'Read values from the Grin PhaseRunner Controller for logging'

    version PhaserunnerCli::VERSION

    subcommand_option_handling :normal
    arguments :strict

    desc 'Describe some switch here'
    switch [:s,:switch]

    desc 'Describe some flag here'
    default_value 'the default'
    arg_name 'The name of the argument'
    flag [:f,:flagname]

    desc 'Read a single or multiple adjacent registers from and address'
    arg_name 'register_address'
    command :read_register do |c|
      c.desc 'Describe a switch to read_register'
      c.switch :s

      c.desc 'Describe a flag to read_register'
      c.default_value 'default'
      c.flag :f
      c.action do |global_options,options,args|

        # Your command logic here
        
        # If you have any errors, just raise them
        # raise "that command made no sense"

        puts "read_register command ran"
      end
    end

    desc 'Read a bulk sparse set of registers with multiple addresses'
    arg_name 'address0 [address1 ... addressn]'
    command :read_bulk do |c|
      c.action do |global_options,options,args|
        puts "read_bulk command ran"
      end
    end

    pre do |global,command,options,args|
      # Pre logic here
      # Return true to proceed; false to abort and not call the
      # chosen command
      # Use skips_pre before a command to skip this block
      # on that command only
      true
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
