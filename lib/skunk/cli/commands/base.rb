# frozen_string_literal: true

require "rubycritic/commands/base"
require "skunk/cli/commands/status_reporter"

module Skunk
  module Cli
    module Command
      # Base class for `Skunk` commands. It knows how to build a command with
      # options. It always uses a [Skunk::Command::StatusReporter] as its
      # reporter object.
      class Base < RubyCritic::Command::Base
        def initialize(options)
          @options = options
          @status_reporter = Skunk::Command::StatusReporter.new(@options)
        end
      end
    end
  end
end
