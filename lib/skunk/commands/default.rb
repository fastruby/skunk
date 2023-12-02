# frozen_string_literal: true

require "rubycritic/commands/default"

require "skunk/commands/status_reporter"
require "skunk/commands/shareable"
require "skunk/generators/console_report"
require "skunk/core/scorer"

module Skunk
  module Command
    # Default command runs a critique using RubyCritic and uses
    # Skunk::Command::StatusReporter to report status
    class Default < RubyCritic::Command::Default
      include Skunk::Command::Shareable

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
        skunk_scorer = Skunk::Scorer.new(analysed_modules)
        Skunk::Generator::ConsoleReport.new(skunk_scorer).generate_report

        status_reporter.analysed_modules = analysed_modules
        status_reporter.score = analysed_modules.score
      end
    end
  end
end
