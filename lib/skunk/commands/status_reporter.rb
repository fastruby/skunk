# frozen_string_literal: true

require "rubycritic/commands/status_reporter"

module Skunk
  module Command
    # Knows how to report status for stinky files
    class StatusReporter < RubyCritic::Command::StatusReporter
      attr_accessor :analysed_modules

      def initialize(options = {})
        super(options)
      end

      # Returns a simple status message indicating the analysis is complete
      def update_status_message
        @status_message = "Skunk Report Completed"
      end
    end
  end
end
