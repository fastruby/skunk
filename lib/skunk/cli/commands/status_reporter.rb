# frozen_string_literal: true

require "rubycritic/commands/status_reporter"
require "skunk/cli/generators/console_report"

module Skunk
  module Command
    # Knows how to report status for stinky files
    class StatusReporter < RubyCritic::Command::StatusReporter
      attr_accessor :analysed_modules

      def update_status_message
        Skunk::Generator::ConsoleReport.new(analysed_modules).generate_report
      end
    end
  end
end
