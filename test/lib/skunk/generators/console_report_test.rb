# frozen_string_literal: true

require "test_helper"

require "rubycritic/analysers_runner"
require "skunk/core/scorer"
require "skunk/generators/console_report"

describe Skunk::Generator::ConsoleReport do
  let(:paths) { "samples/rubycritic" }
  let(:output) { File.read("test/samples/console_output.txt") }

  around do |example|
    RubyCritic::Config.source_control_system = MockGit.new
    runner = RubyCritic::AnalysersRunner.new(paths)
    analysed_modules = runner.run
    analysed_modules.each do |analysed_module|
      def analysed_module.coverage
        100.0
      end

      def analysed_module.churn
        1
      end
    end

    @skunk_scorer = Skunk::Scorer.new(analysed_modules)

    example.call
  end

  describe "#generate_report" do
    it "reports the SkunkScore" do
      skip
      reporter = Skunk::Generator::ConsoleReport.new(@skunk_scorer)
      generate_report = reporter.generate_report

      _(generate_report).must_include output
      _(generate_report).must_include "Generated with Skunk v#{Skunk::VERSION}"
    end

    context "When there's nested spec files" do
      let(:paths) { "samples" }
      it "reports the SkunkScore" do
        skip
        reporter = Skunk::Generator::ConsoleReport.new(@skunk_scorer)
        generate_report = reporter.generate_report

        _(generate_report).must_include output
        _(generate_report).must_include "Generated with Skunk v#{Skunk::VERSION}"
      end
    end
  end
end

# A Mock Git class that returns always 1 for revisions_count
class MockGit < RubyCritic::SourceControlSystem::Git
  def revisions_count(_)
    1
  end
end
