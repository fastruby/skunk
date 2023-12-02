# frozen_string_literal: true

require "rubycritic/commands/status_reporter"

module Skunk
  module Command
    # Implements analysed_modules to share it when SHARE is true
    class StatusReporter < RubyCritic::Command::StatusReporter
      attr_accessor :analysed_modules
    end
  end
end
