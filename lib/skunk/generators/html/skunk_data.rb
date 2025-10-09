# frozen_string_literal: true

require "skunk/generators/html/file_data"
require "skunk/generators/html/path_truncator"

module Skunk
  module Generator
    module Html
      # Data object for the HTML overview report
      class SkunkData
        attr_reader :generated_at, :skunk_version,
                    :analysed_modules_count, :skunk_score_total, :skunk_score_average,
                    :worst_pathname, :worst_score, :files

        def initialize(analysed_modules)
          @analysed_modules = analysed_modules
          @generated_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
          @skunk_version = Skunk::VERSION

          @analysed_modules_count = non_test_modules.count
          @skunk_score_total = non_test_modules.sum(&:skunk_score)
          @skunk_score_average = calculate_average
          @worst_pathname = PathTruncator.truncate(find_worst_module&.pathname)
          @worst_score = find_worst_module&.skunk_score
          @files = build_files
        end

        private

        def non_test_modules
          @non_test_modules ||= @analysed_modules.reject do |a_module|
            module_path = a_module.pathname.dirname.to_s
            module_path.start_with?("test", "spec") || module_path.end_with?("test", "spec")
          end
        end

        def calculate_average
          return 0 if @analysed_modules_count.zero?

          (@skunk_score_total.to_d / @analysed_modules_count).round(2)
        end

        def find_worst_module
          @find_worst_module ||= sorted_modules.first
        end

        def sorted_modules
          @sorted_modules ||= non_test_modules.sort_by(&:skunk_score).reverse!
        end

        def build_files
          @build_files ||= sorted_modules.map do |module_data|
            FileData.new(module_data)
          end
        end
      end
    end
  end
end
