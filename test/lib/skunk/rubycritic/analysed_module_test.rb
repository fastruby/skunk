# frozen_string_literal: true

require "test_helper"

require "rubycritic/analysers_runner"
require "skunk/rubycritic/analysed_module"

describe RubyCritic::AnalysedModule do
  let(:paths) { "lib/skunk/rubycritic" }

  before do
    capture_output_streams do
      RubyCritic::Config.source_control_system = RubyCritic::SourceControlSystem::Git.new
      runner = RubyCritic::AnalysersRunner.new(paths)
      analysed_modules = runner.run
      @analysed_module = analysed_modules.first
    end
  end

  describe "#stink_score" do
    around do |example|
      @analysed_module.stub(:coverage, coverage) do
        example.call
      end
    end

    context "when there is no test coverage" do
      let(:coverage) { 0 }

      it "should be 99.32" do
        @analysed_module.stub(:churn, 1) do
          _(@analysed_module.stink_score).must_equal 85.92
        end
      end
    end

    context "when there is near-perfect code coverage" do
      let(:coverage) { 95 }

      it "should be penalized slightly" do
        @analysed_module.stub(:churn, 1) do
          _(@analysed_module.stink_score).must_equal 4.3
        end
      end
    end

    context "when there is perfect code coverage" do
      let(:coverage) { 100 }

      it "should not be penalized" do
        @analysed_module.stub(:churn, 1) do
          _(@analysed_module.stink_score).must_equal 0.86
        end
      end
    end
  end
end
