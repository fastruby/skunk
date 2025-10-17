# frozen_string_literal: true

require "erb"
require "terminal-table"

module Skunk
  module Generator
    module Console
      # Generates a console report for the analysed modules.
      class Simple
        def initialize(analysed_modules)
          @analysed_modules = analysed_modules
        end

        HEADINGS = %w[file skunk_score churn_times_cost churn cost coverage].freeze
        HEADINGS_WITHOUT_FILE = HEADINGS - %w[file]
        HEADINGS_WITHOUT_FILE_WIDTH = HEADINGS_WITHOUT_FILE.size * 17 # padding

        TEMPLATE = ERB.new(<<~TEMPL
          <%= _ttable %>

          SkunkScore Total: <%= total_skunk_score %>
          Modules Analysed: <%= analysed_modules_count %>
          SkunkScore Average: <%= skunk_score_average %>
          <% if worst %>Worst SkunkScore: <%= worst.skunk_score %> (<%= worst.pathname %>)<% end %>

          Generated with Skunk v<%= Skunk::VERSION %>
        TEMPL
                          )

        def render
          opts = table_options.merge(headings: HEADINGS, rows: table)
          _ttable = Terminal::Table.new(opts)
          TEMPLATE.result(binding)
        end

        private

        def analysed_modules_count
          @analysed_modules.analysed_modules_count
        end

        def worst
          @analysed_modules.worst_module
        end

        def sorted_modules
          @analysed_modules.sorted_modules
        end

        def total_skunk_score
          @analysed_modules.skunk_score_total
        end

        def total_churn_times_cost
          @analysed_modules.total_churn_times_cost
        end

        def skunk_score_average
          @analysed_modules.skunk_score_average
        end

        def table_options
          return { style: { width: 100 } } if sorted_modules.empty?

          max = sorted_modules.max_by { |a_mod| a_mod.pathname.to_s.length }
          width = max.pathname.to_s.length + HEADINGS_WITHOUT_FILE_WIDTH
          {
            style: {
              width: width
            }
          }
        end

        def table
          @analysed_modules.files_as_hash.map { |file_hash| self.class.format_hash_row(file_hash) }
        end

        def self.format_hash_row(file_hash)
          [
            file_hash[:file],
            file_hash[:skunk_score],
            file_hash[:churn_times_cost],
            file_hash[:churn],
            file_hash[:cost],
            file_hash[:coverage]
          ]
        end
      end
    end
  end
end
