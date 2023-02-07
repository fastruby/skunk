# frozen_string_literal: true

require "erb"
require "terminal-table"
require "rubycritic/generators/console_report"

module Skunk
  module Generator
    # Returns a status message with a table of all analysed_modules and
    # a skunk score average
    class ConsoleReport < RubyCritic::Generator::ConsoleReport
      HEADINGS = %w[file skunk_score churn_times_cost churn cost coverage].freeze
      HEADINGS_WITHOUT_FILE = HEADINGS - %w[file]
      HEADINGS_WITHOUT_FILE_WIDTH = HEADINGS_WITHOUT_FILE.size * 17 # padding

      TEMPLATE = ERB.new(<<-TEMPL
<%= _ttable %>\n
SkunkScore Total: <%= total_skunk_score %>
Modules Analysed: <%= analysed_modules_count %>
SkunkScore Average: <%= skunk_score_average %>
<% if worst %>Worst SkunkScore: <%= worst.skunk_score %> (<%= worst.pathname %>)<% end %>

Generated with Skunk v<%= Skunk::VERSION %>
TEMPL
                        )

      def generate_report
        opts = table_options.merge(headings: HEADINGS, rows: table)
        _ttable = Terminal::Table.new(opts)
        TEMPLATE.result(binding)
      end

      private

      def analysed_modules_count
        @analysed_modules_count ||= non_test_modules.count
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

      def total_skunk_score
        @total_skunk_score ||= non_test_modules.sum(&:skunk_score)
      end

      def total_churn_times_cost
        non_test_modules.sum(&:churn_times_cost)
      end

      def skunk_score_average
        return 0 if analysed_modules_count.zero?

        (total_skunk_score.to_d / analysed_modules_count).to_f.round(2)
      end

      def table_options
        max = sorted_modules.max_by { |a_mod| a_mod.pathname.to_s.length }
        width = max.pathname.to_s.length + HEADINGS_WITHOUT_FILE_WIDTH
        {
          style: {
            width: width
          }
        }
      end

      def table
        sorted_modules.map do |a_mod|
          [
            a_mod.pathname,
            a_mod.skunk_score,
            a_mod.churn_times_cost,
            a_mod.churn,
            a_mod.cost.round(2),
            a_mod.coverage.round(2)
          ]
        end
      end
    end
  end
end
