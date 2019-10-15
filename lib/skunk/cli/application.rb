# frozen_string_literal: true

require "skunk"
require "skunk/rubycritic/analysed_module"
require "skunk/cli/options"
require "skunk/cli/command_factory"

require "rubycritic/cli/application"

module Skunk
  module Cli
    # Knows how to execute command line commands
    class Application < RubyCritic::Cli::Application
      def execute
        parsed_options = @options.parse.to_h

        reporter = Skunk::Cli::CommandFactory.create(parsed_options).execute
        print(reporter.status_message)
        reporter.status
      rescue OptionParser::InvalidOption => error
        warn "Error: #{error}"
        STATUS_ERROR
      end
    end
  end
end
