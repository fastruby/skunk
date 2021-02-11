# frozen_string_literal: true

require "rubycritic/commands/default"
require "rubycritic/analysers_runner"
require "rubycritic/revision_comparator"
require "rubycritic/reporter"

require "skunk/cli/commands/base"
require "skunk/cli/commands/shareable"
require "skunk/cli/commands/status_reporter"

module Skunk
  module Cli
    module Command
      # Default command runs a critique using RubyCritic and uses
      # Skunk::Command::StatusReporter to report status
      class Default < RubyCritic::Command::Default
        include Skunk::Cli::Command::Shareable

        def initialize(options)
          super
          @options = options
          @status_reporter = Skunk::Command::StatusReporter.new(options)
        end

        # It generates a report and it returns an instance of
        # Skunk::Command::StatusReporter
        #
        # @return [Skunk::Command::StatusReporter]
        def execute
          RubyCritic::Config.formats = []

          report(critique)

          status_reporter
        end

        # It connects the Skunk::Command::StatusReporter with the collection
        # of analysed modules.
        #
        # @param [RubyCritic::AnalysedModulesCollection] A collection of analysed modules
        def report(analysed_modules)
          status_reporter.analysed_modules = analysed_modules
          status_reporter.score = analysed_modules.score
        end
      end
    end
  end
end
