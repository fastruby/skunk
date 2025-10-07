# frozen_string_literal: true

module Skunk
  module Generator
    module Html
      # Data object for individual file information in the HTML overview report
      class FileData
        attr_reader :file, :skunk_score, :churn_times_cost, :churn, :cost, :coverage

        def initialize(module_data)
          @file = PathTruncator.truncate(module_data.pathname)
          @skunk_score = module_data.skunk_score
          @churn_times_cost = module_data.churn_times_cost
          @churn = module_data.churn
          @cost = module_data.cost.round(2)
          @coverage = module_data.coverage.round(2)
        end
      end
    end
  end
end
