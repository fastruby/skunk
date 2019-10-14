# frozen_string_literal: true

require 'rubycritic/commands/base'
require 'skunk/cli/commands/status_reporter'

module Skunk
  module Cli
    module Command
      class Base < RubyCritic::Command::Base
        def initialize(options)
          @options = options
          @status_reporter = Skunk::Cli::Command::StatusReporter.new(@options)
        end
      end
    end
  end
end
