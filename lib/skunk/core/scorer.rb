# frozen_string_literal: true

module Skunk
  # Skunk Score to share with generators and sharers
  class Scorer
    attr_reader :analysed_modules

    def initialize(analysed_modules)
      @analysed_modules = analysed_modules
    end

    def score
      analysed_modules.score
    end

    def analysed_modules_count
      @analysed_modules_count ||= non_test_modules.count
    end

    def non_test_modules
      @non_test_modules ||= analysed_modules.reject do |a_module|
        module_path = a_module.pathname.dirname.to_s
        module_path.start_with?("test", "spec") || module_path.end_with?("test", "spec")
      end
    end

    def total_score
      @total_score ||= non_test_modules.sum(&:skunk_score)
    end

    def total_churn_times_cost
      non_test_modules.sum(&:churn_times_cost)
    end

    def average
      return 0 if analysed_modules_count.zero?

      (total_score.to_d / analysed_modules_count).to_f.round(2)
    end

    def worst
      @worst ||= sorted_modules.first
    end

    def worst_skunk_score
      @worst.skunk_score
    end

    def worst_pathname
      @worst.pathname
    end

    def sorted_modules
      @sorted_modules ||= non_test_modules.sort_by(&:skunk_score).reverse!
    end
  end
end
