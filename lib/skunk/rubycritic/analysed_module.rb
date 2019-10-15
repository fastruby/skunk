require 'rubycritic/core/analysed_module'

module RubyCritic
  class AnalysedModule
    PERFECT_COVERAGE = 100

    def stink_score
      require "byebug"; byebug
      return cost if coverage == PERFECT_COVERAGE

      cost * (PERFECT_COVERAGE - coverage.to_i)
    end

    def complexity_per_method
      if methods_count.to_i.zero?
        'N/A'
      else
        complexity.fdiv(methods_count).round(1)
      end
    end
  end
end
