# frozen_string_literal: true

require "rubycritic/core/analysed_module"

module RubyCritic
  # Monkey-patches RubyCritic::AnalysedModule to add a skunk_score method
  class AnalysedModule
    PERFECT_COVERAGE = 100

    # Returns a numeric value that represents the skunk_score of a module:
    #
    # If module is perfectly covered, skunk score is the same as the
    # `churn_times_cost`
    #
    # If module has no coverage, skunk score is a penalized value of
    # `churn_times_cost`
    #
    # For now the skunk_score is calculated by multiplying `churn_times_cost`
    # times the lack of coverage.
    #
    # For example:
    #
    # When `churn_times_cost` is 100 and module is perfectly covered:
    # skunk_score => 100
    #
    # When `churn_times_cost` is 100 and module is not covered at all:
    # skunk_score => 100 * 100 = 10_000
    #
    # When `churn_times_cost` is 100 and module is covered at 75%:
    # skunk_score => 100 * 25 (percentage uncovered) = 2_500
    #
    # @return [Float]
    def skunk_score
      return cost.round(2) if coverage == PERFECT_COVERAGE

      (cost * (PERFECT_COVERAGE - coverage.to_i)).round(2)
    end

    # Returns the value of churn times cost.
    #
    # @return [Integer]
    def churn_times_cost
      safe_churn = churn.positive? ? churn : 1
      @churn_times_cost ||= (safe_churn * cost).round(2)
    end

    # Returns a hash with these attributes:
    #   - file
    #   - skunk_score
    #   - churn_times_cost
    #   - churn
    #   - cost
    #   - coverage
    #
    # @return [Hash]
    # rubocop:disable Style/HashSyntax
    def to_hash
      {
        file: pathname.to_s,
        skunk_score: skunk_score,
        churn_times_cost: churn_times_cost,
        churn: churn,
        cost: cost.round(2),
        coverage: coverage.round(2)
      }
    end
    # rubocop:enable Style/HashSyntax
  end
end
