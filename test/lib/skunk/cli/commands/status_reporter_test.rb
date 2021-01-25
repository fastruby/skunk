# frozen_string_literal: true

require "test_helper"

require "rubycritic/analysers_runner"
require "skunk/cli/commands/status_reporter"

describe Skunk::Command::StatusReporter do
  let(:paths) { "samples/rubycritic" }

  describe "#update_status_message" do
    let(:output) { File.read("test/samples/console_output.txt") }
    let(:reporter) { Skunk::Command::StatusReporter.new({}) }

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

      reporter.analysed_modules = analysed_modules
      reporter.score = analysed_modules.score
      example.call
    end

    it "reports the SkunkScore" do
      _(reporter.update_status_message).must_include output
      _(reporter.update_status_message).must_include "Generated with Skunk v#{Skunk::VERSION}"
    end

    context "When there's nested spec files" do
      let(:paths) { "samples" }
      it "reports the SkunkScore" do
        _(reporter.update_status_message).must_include output
        _(reporter.update_status_message).must_include "Generated with Skunk v#{Skunk::VERSION}"
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
