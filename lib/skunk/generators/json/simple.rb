# frozen_string_literal: true

require "rubycritic/generators/json/simple"

module Skunk
  module Generator
    module Json
      # Generates a JSON report for the analysed modules.
      class Simple < RubyCritic::Generator::Json::Simple
        def data
          {
            analysed_modules_count: analysed_modules_count,
            skunk_score_average: skunk_score_average,
            skunk_score_total: skunk_score_total,
            worst_pathname: worst&.pathname,
            worst_score: worst&.skunk_score,
            files: files
          }
        end

        private

        def analysed_modules_count
          @analysed_modules_count ||= non_test_modules.count
        end

        def skunk_score_average
          return 0 if analysed_modules_count.zero?

          (skunk_score_total.to_d / analysed_modules_count).to_f.round(2)
        end

        def skunk_score_total
          @skunk_score_total ||= non_test_modules.sum(&:skunk_score)
        end

        def non_test_modules
          @non_test_modules ||= @analysed_modules.reject do |a_module|
            module_path = a_module.pathname.dirname.to_s
            module_path.start_with?("test", "spec") || module_path.end_with?("test", "spec")
          end
        end

        def worst
          @worst ||= sorted_modules.first
        end

        def sorted_modules
          @sorted_modules ||= non_test_modules.sort_by(&:skunk_score).reverse!
        end

        def files
          @files ||= sorted_modules.map(&:to_hash)
        end
      end
    end
  end
end
