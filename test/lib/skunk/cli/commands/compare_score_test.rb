# frozen_string_literal: true

require "test_helper"

require "skunk/cli/commands/compare_score"

describe Skunk::Command::CompareScore do
  describe "#score_evolution_message" do
    it "computes skunk score_evolution_message with negative impact" do
      compare_score = Skunk::Command::CompareScore.new(10.1, 12.1)
      compare_score.score_evolution_message.must_equal "Skunk score average is 20% worse \n"
    end

    it "computes skunk score_evolution_message with positive impact" do
      compare_score = Skunk::Command::CompareScore.new(12.1, 8)
      compare_score.score_evolution_message.must_equal "Skunk score average is 34% better \n"
    end

    it "computes skunk score_evolution_message when base_branch_score is 0" do
      compare_score = Skunk::Command::CompareScore.new(0, 2)
      compare_score.score_evolution_message.must_equal "Skunk score average is Infinitely worse \n"
    end

    it "computes skunk score_evolution_message when feature_branch_score is 0" do
      compare_score = Skunk::Command::CompareScore.new(10, 0)
      compare_score.score_evolution_message.must_equal "Skunk score average is 100% better \n"
    end
  end
end
