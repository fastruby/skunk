# frozen_string_literal: true

require "skunk/cli/commands/base"
require "rubycritic/commands/help"

module Skunk
  module Cli
    module Command
      # Knows how to guide user into using `skunk` properly
      class Help < Skunk::Cli::Command::Base
        # Outputs a help message
        def execute
          puts options[:help_text]
          status_reporter
        end

        def sharing?
          false
        end

        private

        attr_reader :options, :status_reporter
      end
    end
  end
end
