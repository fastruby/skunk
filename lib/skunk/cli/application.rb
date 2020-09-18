# frozen_string_literal: true

require "rubycritic/cli/options"
require "rubycritic/cli/application"

require "skunk"
require "skunk/rubycritic/analysed_module"
require "skunk/cli/options"
require "skunk/cli/command_factory"

module Skunk
  module Cli
    # Knows how to execute command line commands
    class Application < RubyCritic::Cli::Application
      COVERAGE_FILE = "coverage/.resultset.json"

      def initialize(argv)
        @options = Skunk::Cli::Options.new(argv)
      end

      def execute
        warn_coverage_info unless File.exist?(COVERAGE_FILE)

        parsed_options = @options.parse.to_h
        reporter = Skunk::Cli::CommandFactory.create(parsed_options).execute
        print(reporter.status_message)
        reporter.status
      rescue OptionParser::InvalidOption => error
        warn "Error: #{error}"
        STATUS_ERROR
      end

      private

      def warn_coverage_info
        warn "warning: Couldn't find coverage info at #{COVERAGE_FILE}."
        warn "warning: Having no coverage metrics will make your SkunkScore worse."
      end
    end
  end
end
