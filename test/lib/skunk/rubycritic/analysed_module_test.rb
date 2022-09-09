# frozen_string_literal: true

require "test_helper"

require "rubycritic/analysers_runner"
require "skunk/rubycritic/analysed_module"

describe RubyCritic::AnalysedModule do
  let(:paths) { "samples/rubycritic" }

  before do
    capture_output_streams do
      RubyCritic::Config.source_control_system = RubyCritic::SourceControlSystem::Git.new
      runner = RubyCritic::AnalysersRunner.new(paths)
      analysed_modules = runner.run
      @analysed_module = analysed_modules.first
    end
  end

  describe "#skunk_score" do
    around do |example|
      @analysed_module.stub(:coverage, coverage) do
        example.call
      end
    end

    context "when there is no test coverage" do
      let(:coverage) { 0 }

      it "should be 99.32" do
        @analysed_module.stub(:churn, 1) do
          _(@analysed_module.skunk_score).must_equal 58.88
        end
      end
    end

    context "when there is near-perfect code coverage" do
      let(:coverage) { 95 }

      it "should be penalized slightly" do
        @analysed_module.stub(:churn, 1) do
          _(@analysed_module.skunk_score).must_equal 2.94
        end
      end
    end

    context "when there is perfect code coverage" do
      let(:coverage) { 100 }

      it "should not be penalized" do
        @analysed_module.stub(:churn, 1) do
          _(@analysed_module.skunk_score).must_equal 0.59
        end
      end
    end
  end

  describe "#to_hash" do
    let(:result) do
      {
        file: "samples/rubycritic/analysed_module.rb",
        skunk_score: 58.88,
        churn_times_cost: 2.36,
        churn: 4,
        cost: 0.59,
        coverage: 0.0
      }
    end

    it "returns a hash with all the attributes and values" do
      _(@analysed_module.to_hash).must_equal result
    end
  end
end
