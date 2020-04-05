# frozen_string_literal: true

require "rubycritic/core/analysed_modules_collection"

module RubyCritic
  # nodoc #
  class AnalysedModulesCollection
    def skunk_score_average
      num_modules = @modules.size
      if num_modules.positive?
        sum(&:skunk_score) / num_modules.to_f
      else
        0.0
      end
    end
  end
end
