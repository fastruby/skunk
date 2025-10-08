# frozen_string_literal: true

require "pathname"

require "rubycritic/configuration"

module Skunk
  module Generator
    module Json
      # Generates a JSON report for the analysed modules.
      class Simple
        def initialize(analysed_modules)
          @analysed_modules = analysed_modules
        end

        FILE_NAME = "skunk_report.json"

        def render
          JSON.dump(data)
        end

        def data
          {
            analysed_modules_count: analysed_modules_count,
            skunk_score_total: skunk_score_total,
            skunk_score_average: calculate_average,
            worst_pathname: find_worst_module&.pathname,
            worst_score: find_worst_module&.skunk_score,
            files: build_files
          }
        end

        def file_directory
          @file_directory ||= Pathname.new(RubyCritic::Config.root)
        end

        def file_pathname
          Pathname.new(file_directory).join(FILE_NAME)
        end

        private

        def analysed_modules_count
          @analysed_modules_count ||= non_test_modules.count
        end

        def calculate_average
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

        def find_worst_module
          @find_worst_module ||= sorted_modules.first
        end

        def sorted_modules
          @sorted_modules ||= non_test_modules.sort_by(&:skunk_score).reverse!
        end

        def build_files
          @build_files ||= sorted_modules.map(&:to_hash)
        end
      end
    end
  end
end
