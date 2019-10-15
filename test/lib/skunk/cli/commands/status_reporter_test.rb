# frozen_string_literal: true

require "test_helper"

require "rubycritic/analysers_runner"
require "skunk/cli/commands/status_reporter"

describe Skunk::Command::StatusReporter do
  let(:paths) { "lib/skunk/rubycritic" }

  before do
    # capture_output_streams do
    RubyCritic::Config.source_control_system = RubyCritic::SourceControlSystem::Git.new
    runner = RubyCritic::AnalysersRunner.new(paths)
    analysed_modules = runner.run
    @reporter = Skunk::Command::StatusReporter.new({})
    @reporter.analysed_modules = analysed_modules
    @reporter.score = analysed_modules.score
    # end
  end

  describe "#update_status_message" do
    let(:output) { File.read("test/samples/console_output.txt") }

    it "reports the StinkScore" do
      @reporter.update_status_message.must_equal output
    end
  end
end
