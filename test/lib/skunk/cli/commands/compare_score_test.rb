# frozen_string_literal: true

require "test_helper"

require "skunk/cli/commands/compare_score"

describe Skunk::Cli::Command::CompareScore do
  describe "#message" do
    it "outputs comparaison message" do
      expected = "Base branch (main) average skunk score: 10 \n"\
        "Feature branch (feature) average skunk score: 2 \n"\
        "Skunk score average is 80% better \n"

      compare_score = Skunk::Cli::Command::CompareScore.new("main", "feature", 10, 2)
      compare_score.message.must_equal expected
    end
  end
  describe "#score_evolution_message" do
    it "computes skunk score_evolution_message with negative impact" do
      compare_score = Skunk::Cli::Command::CompareScore.new("main", "feature", 10.1, 12.1)
      compare_score.score_evolution_message.must_equal "Skunk score average is 20% worse \n"
    end

    it "computes skunk score_evolution_message with positive impact" do
      compare_score = Skunk::Cli::Command::CompareScore.new("main", "feature", 12.1, 8)
      compare_score.score_evolution_message.must_equal "Skunk score average is 34% better \n"
    end

    it "computes skunk score_evolution_message when base_branch_score is 0" do
      compare_score = Skunk::Cli::Command::CompareScore.new("main", "feature", 0, 2)
      compare_score
        .score_evolution_message
        .must_equal "Skunk score average is Infinitely worse \n"
    end

    it "computes skunk score_evolution_message when feature_branch_score is 0" do
      compare_score = Skunk::Cli::Command::CompareScore.new("main", "feature", 10, 0)
      compare_score.score_evolution_message.must_equal "Skunk score average is 100% better \n"
    end
  end
end
