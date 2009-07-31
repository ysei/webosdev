require 'optparse'

module Webosdev
  class CLI
    COMMANDS = %w(new_app new_scene package install)

    def self.execute(stdout, arguments=[])
      options = {
      }
      mandatory_options = %w(command)

      parser = OptionParser.new do |opts|
        opts.banner = <<-BANNER.gsub(/^          /,'')
          This application is a tool to help with developing WebOS applications
          with using tools such as Haml and Sass.

          Usage: #{File.basename($0)} [options]

          Options are:
        BANNER
        opts.separator ""
        opts.on("-a", "--application NAME", String,
                "Name of the application.") { |name| options[:application] = name }
        opts.on("-c", "--command COMMAND", String, COMMANDS,
                "Command to run.") { |command| options[:command] = command }
        opts.on("-h", "--help",
                "Show this help message.") { stdout.puts opts; exit }
        opts.parse!(arguments)

        if mandatory_options && missing = mandatory_options.find { |option| options[option.to_sym].nil? }
          STDERR.puts "Please specify the #{missing}.\n\n"
          stdout.puts opts; exit
        end
      end
      
      manager = PalmManager.new
      options[:application] ||= manager.application_name
      raise PalmManager::ArgumentError, "Missing application name" unless options[:application]
      message = manager.send(options[:command].to_sym, options)
      stdout.puts "#{message}."
    end
  end
end