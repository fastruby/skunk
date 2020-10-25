# frozen_string_literal: true

# nodoc #
module Skunk
  module Command
    class CompareScore
      def initialize(base_branch_score, feature_branch_score)
        @base_branch_score = base_branch_score
        @feature_branch_score = feature_branch_score
      end

      def score_evolution_message
        score_evolution_appreciation = (@feature_branch_score > @base_branch_score) ? "worse" : "better"
        "Skunk score average is #{score_evolution} #{score_evolution_appreciation} \n"
      end

      def score_evolution
        return "Infinitely" if @base_branch_score.zero?

        score_evolution = (100 * (@base_branch_score - @feature_branch_score) / @base_branch_score).round(0)
        "#{score_evolution.abs}%"
      end
    end
  end
end
