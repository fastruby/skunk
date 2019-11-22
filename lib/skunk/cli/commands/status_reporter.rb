# frozen_string_literal: true

require "erb"
require "rubycritic/commands/status_reporter"
require "terminal-table"

module Skunk
  module Command
    # Knows how to report status for stinky files
    class StatusReporter < RubyCritic::Command::StatusReporter
      attr_accessor :analysed_modules

      HEADINGS = %w[file stink_score churn_times_cost churn cost coverage].freeze

      TEMPLATE = ERB.new(<<-TEMPL
<%= _ttable %>\n
StinkScore Total: <%= total_stink_score %>
Modules Analysed: <%= analysed_modules_count %>
StinkScore Average: <%= stink_score_average %>
<% if worst %>Worst StinkScore: <%= worst.stink_score %> (<%= worst.pathname %>)<% end %>
TEMPL
                        )

      # Returns a status message with a table of all analysed_modules and
      # a stink score average
      def update_status_message
        opts = table_options.merge(headings: HEADINGS, rows: table)

        _ttable = Terminal::Table.new(opts)

        @status_message = TEMPLATE.result(binding)
      end

      private

      def analysed_modules_count
        @analysed_modules_count ||= non_test_modules.count
      end

      def non_test_modules
        @non_test_modules ||= analysed_modules.reject do |a_module|
          a_module.pathname.to_s.start_with?("test", "spec")
        end
      end

      def worst
        @worst ||= sorted_modules.first
      end

      def sorted_modules
        @sorted_modules ||= non_test_modules.sort_by(&:stink_score).reverse!
      end

      def total_stink_score
        @total_stink_score ||= non_test_modules.map(&:stink_score).inject(0.0, :+)
      end

      def total_churn_times_cost
        non_test_modules.map(&:churn_times_cost).sum
      end

      def stink_score_average
        return 0 if analysed_modules_count.zero?

        (total_stink_score.to_d / analysed_modules_count).to_f
      end

      def table_options
        {
          style: {
            width: 200
          }
        }
      end

      def table
        sorted_modules.map do |a_mod|
          [
            a_mod.pathname,
            a_mod.stink_score,
            a_mod.churn_times_cost,
            a_mod.churn,
            a_mod.cost,
            a_mod.coverage
          ]
        end
      end
    end
  end
end
