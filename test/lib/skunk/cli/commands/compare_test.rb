# frozen_string_literal: true

require "test_helper"

require "skunk/rubycritic/analysed_module"
require "skunk/cli/commands/compare"

describe Skunk::Command::Compare do
  let(:paths) { "samples/rubycritic" }

  describe "#analyse_branch" do
    before do
      RubyCritic::Config.root = paths
    end

    it "sets the stink_score_average as the branch score" do
      ::RubyCritic::SourceControlSystem::Git.stub :switch_branch, nil do
        compare = Skunk::Command::Compare.new(paths: "samples/rubycritic")
        compare.analyse_branch(:base_branch)

        _(RubyCritic::Config.base_branch_score).must_equal 515.52
      end
    end
  end
end
