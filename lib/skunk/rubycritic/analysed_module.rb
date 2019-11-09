# frozen_string_literal: true

require "rubycritic/core/analysed_module"

module RubyCritic
  # Monkey-patches RubyCritic::AnalysedModule to add a stink_score method
  class AnalysedModule
    PERFECT_COVERAGE = 100

    # Returns a numeric value that represents the stink_score of a module:
    #
    # If module is perfectly covered, stink score is the same as the
    # `churn_times_cost`
    #
    # If module has no coverage, stink score is a penalized value of
    # `churn_times_cost`
    #
    # For now the stink_score is calculated by multiplying `churn_times_cost`
    # times the lack of coverage.
    #
    # For example:
    #
    # When `churn_times_cost` is 100 and module is perfectly covered:
    # stink_score => 100
    #
    # When `churn_times_cost` is 100 and module is not covered at all:
    # stink_score => 100 * 100 = 10_000
    #
    # When `churn_times_cost` is 100 and module is covered at 75%:
    # stink_score => 100 * 25 (percentage uncovered) = 2_500
    #
    # @return [Float]
    def stink_score
      return churn_times_cost.round(2) if coverage == PERFECT_COVERAGE

      (churn_times_cost * (PERFECT_COVERAGE - coverage.to_i)).round(2)
    end

    # Returns the value of churn times cost.
    #
    # @return [Integer]
    def churn_times_cost
      safe_churn = churn.positive? ? churn : 1
      @churn_times_cost ||= safe_churn * cost
    end
  end
end
