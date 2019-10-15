# frozen_string_literal: true

require "rubycritic/commands/status_reporter"
require "terminal-table"

module Skunk
  module Command
    # Knows how to report status for stinky files
    class StatusReporter < RubyCritic::Command::StatusReporter
      attr_accessor :analysed_modules

      HEADINGS = %w[file stink_score churn_times_cost churn cost coverage].freeze

      # Returns a status message with a table of all analysed_modules and
      # a stink score average
      def update_status_message
        opts = table_options.merge(headings: HEADINGS, rows: table)

        ttable = Terminal::Table.new(opts) 

        @status_message = "#{ttable}\n\n"

        @status_message += "StinkScore Total: #{total_stink_score}\n"
        @status_message += "Modules Analysed: #{analysed_modules_count}\n"
        @status_message += "StinkScore Average: #{stink_score}\n"
        @status_message += "Worst StinkScore: #{worst.stink_score} (#{worst.pathname})\n" if worst
      end

      private

      def analysed_modules_count
        @analysed_modules_count ||= analysed_modules.count
      end

      def worst
        @worst ||= sorted_modules.first
      end

      def sorted_modules
        @sorted_modules ||= analysed_modules.sort_by(&:stink_score).reverse!
      end

      def total_stink_score
        @total_stink_score ||= analysed_modules.map(&:stink_score).inject(0.0, :+)
      end

      def total_churn_times_cost
        analysed_modules.map(&:churn_times_cost).sum
      end

      def stink_score
        return 0 if analysed_modules_count == 0

        total_stink_score.to_d / analysed_modules_count
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
