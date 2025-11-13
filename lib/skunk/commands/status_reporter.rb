# frozen_string_literal: true

require "rubycritic/commands/status_reporter"

module Skunk
  module Command
    # Extends RubyCritic::Command::StatusReporter to silence the status message
    class StatusReporter < RubyCritic::Command::StatusReporter
      attr_accessor :analysed_modules

      def initialize(options = {})
        super(options)
      end

      def update_status_message
        @status_message = ""
      end
    end
  end
end
