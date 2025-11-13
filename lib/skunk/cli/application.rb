# frozen_string_literal: true

require "rubycritic/cli/options"
require "rubycritic/cli/application"

require "skunk"
require "skunk/rubycritic/analysed_module"
require "skunk/rubycritic/analysed_modules_collection"
require "skunk/cli/options"
require "skunk/command_factory"
require "skunk/commands/status_sharer"

module Skunk
  module Cli
    # Knows how to execute command line commands
    # :reek:InstanceVariableAssumption
    class Application < RubyCritic::Cli::Application
      COVERAGE_FILE = "coverage/.resultset.json"

      def initialize(argv)
        @options = Skunk::Cli::Options.new(argv)
      end

      # :reek:UncommunicativeVariableName
      def execute
        warn_coverage_info unless File.exist?(COVERAGE_FILE)

        # :reek:NilCheck
        @parsed_options = @options.parse.to_h
        command = Skunk::CommandFactory.create(@parsed_options)
        reporter = command.execute

        print(reporter.status_message)
        if command.sharing?
          share_status_message = command.share(reporter)
          print(share_status_message)
        end

        reporter.status
      rescue OptionParser::InvalidOption => e
        warn "Error: #{e}"
        STATUS_ERROR
      end

      private

      def warn_coverage_info
        warn "warning: Couldn't find coverage info at #{COVERAGE_FILE}."
        warn "warning: Having no coverage metrics will make your SkunkScore worse."
      end

      # :reek:NilCheck
      def print(message)
        filename = @parsed_options[:output_filename]
        if filename.nil?
          $stdout.puts(message)
        else
          File.open(filename, "a") { |file| file << message }
        end
      end
    end
  end
end
