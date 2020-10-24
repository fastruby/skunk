# frozen_string_literal: true

require "test_helper"

require "skunk/rubycritic/analysed_module"
require "skunk/cli/commands/compare"

describe Skunk::Command::Compare do
  let(:paths) { "samples/rubycritic" }
  let(:compare_root_directory) { "test/support/tmp/rubycritic/compare/" }

  describe "#analyse_branch" do
    before do
      RubyCritic::Config.root = paths
      FileUtils.rm_rf("test/support/")
    end

    it "sets the skunk_score_average as the branch score" do
      ::RubyCritic::SourceControlSystem::Git.stub :switch_branch, nil do
        compare = Skunk::Command::Compare.new(paths: "samples/rubycritic")
        compare.analyse_branch(:base_branch)

        _(RubyCritic::Config.base_branch_score).must_equal 58.88
      end
    end

    it "creates the compare_root_directory if it doesn't exist" do
      ::RubyCritic::Config.configuration.stub(:compare_root_directory,
                                              compare_root_directory) do
        Skunk::Command::Compare.new(paths: "samples/rubycritic").build_details
        _(File.exist?(compare_root_directory)).must_equal true
      end
    end

    it "computes skunk score_evolution_message with negative impact" do
      compare = Skunk::Command::Compare.new(paths: "samples/rubycritic")
      compare.stub :base_branch_score, 10.1 do
        compare.stub :feature_branch_score, 12.1 do
          compare.score_evolution_message.must_equal "Skunk score average is 20% worse \n"
        end
      end
    end

    it "computes skunk score_evolution_message with positive impact" do
      compare = Skunk::Command::Compare.new(paths: "samples/rubycritic")
      compare.stub :base_branch_score, 12.1 do
        compare.stub :feature_branch_score, 8 do
          compare.score_evolution_message.must_equal "Skunk score average is 34% better \n"
        end
      end
    end

    it "computes skunk score_evolution_message when base_branch_score is 0" do
      compare = Skunk::Command::Compare.new(paths: "samples/rubycritic")
      compare.stub :base_branch_score, 0 do
        compare.stub :feature_branch_score, 2 do
          compare.score_evolution_message.must_equal "Skunk score average is Infinitely worse \n"
        end
      end
    end

    it "computes skunk score_evolution_message when feature_branch_score is 0" do
      compare = Skunk::Command::Compare.new(paths: "samples/rubycritic")
      compare.stub :base_branch_score, 10 do
        compare.stub :feature_branch_score, 0 do
          compare.score_evolution_message.must_equal "Skunk score average is 100% better \n"
        end
      end
    end
  end
end
