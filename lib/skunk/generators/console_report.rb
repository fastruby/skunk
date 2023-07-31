# frozen_string_literal: true

require "erb"
require "terminal-table"
require "rubycritic/generators/console_report"

module Skunk
  module Generator
    # Print SkunkScore at the console in plain text
    class ConsoleReport < RubyCritic::Generator::ConsoleReport
      def initialize(skunk_scorer)
        @skunk_scorer = skunk_scorer
        super
      end

      HEADINGS = %w[file skunk_score churn_times_cost churn cost coverage].freeze
      HEADINGS_WITHOUT_FILE = HEADINGS - %w[file]
      HEADINGS_WITHOUT_FILE_WIDTH = HEADINGS_WITHOUT_FILE.size * 17 # padding

      TEMPLATE = ERB.new(<<~TEMPL
        <%= _ttable %>\n
        SkunkScore Total: <%= total_skunk_score %>
        Modules Analysed: <%= analysed_modules_count %>
        SkunkScore Average: <%= skunk_score_average %>
        <% if worst %>Worst SkunkScore: <%= worst_skunk_score %> (<%= worst_pathname %>)<% end %>

        Generated with Skunk v<%= Skunk::VERSION %>
      TEMPL
                        )

      def generate_report
        opts = table_options.merge(headings: HEADINGS, rows: table)

        _ttable = Terminal::Table.new(opts)

        puts TEMPLATE.result(binding)
      end

      private

      def total_skunk_score
        @skunk_scorer.total_score
      end

      def analysed_modules_count
        @skunk_scorer.analysed_modules_count
      end

      def skunk_score_average
        @skunk_scorer.average
      end

      def worst
        @skunk_scorer.worst
      end

      def worst_skunk_score
        @skunk_scorer.worst_skunk_score
      end

      def worst_pathname
        @skunk_scorer.worst_pathname
      end

      def sorted_modules
        @skunk_scorer.sorted_modules
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
