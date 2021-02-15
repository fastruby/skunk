# frozen_string_literal: true

# nodoc #
module Skunk
  module Cli
    module Command
      # Knows how to describe score evolution between two branches
      class CompareScore
        def initialize(base_branch, feature_branch, base_branch_score, feature_branch_score)
          @base_branch = base_branch
          @feature_branch = feature_branch
          @base_branch_score = base_branch_score
          @feature_branch_score = feature_branch_score
        end

        def message
          "Base branch (#{@base_branch}) "\
            "average skunk score: #{@base_branch_score} \n"\
            "Feature branch (#{@feature_branch}) "\
            "average skunk score: #{@feature_branch_score} \n"\
            "#{score_evolution_message}"
        end

        def score_evolution_message
          "Skunk score average is #{score_evolution} #{score_evolution_appreciation} \n"
        end

        def score_evolution_appreciation
          @feature_branch_score > @base_branch_score ? "worse" : "better"
        end

        def score_evolution
          return "Infinitely" if @base_branch_score.zero?

          precentage = (100 * (@base_branch_score - @feature_branch_score) / @base_branch_score)
          "#{precentage.round(0).abs}%"
        end
      end
    end
  end
end
