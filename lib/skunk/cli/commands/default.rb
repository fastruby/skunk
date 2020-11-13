# frozen_string_literal: true

require "rubycritic/commands/default"
require "rubycritic/analysers_runner"
require "rubycritic/revision_comparator"
require "rubycritic/reporter"

require "skunk/cli/commands/base"
require "skunk/cli/commands/status_reporter"

module Skunk
  module Cli
    module Command
      # Default command runs a critique using RubyCritic and uses
      # Skunk::Command::StatusReporter to report status
      class Default < RubyCritic::Command::Default
        def initialize(options)
          super
          @status_reporter = Skunk::Command::StatusReporter.new(@options)
        end

        def execute
          RubyCritic::Config.formats = []

          report(critique)

          if ENV['SHARE'] || ENV['SHARE_URL']
            require 'skunk/share'
            share = Share.new @status_reporter
            share.share
          end

          status_reporter
        end

        def report(analysed_modules)
          status_reporter.analysed_modules = analysed_modules
          status_reporter.score = analysed_modules.score
        end
      end
    end
  end
end
