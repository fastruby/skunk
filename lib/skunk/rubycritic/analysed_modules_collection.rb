require "rubycritic/core/analysed_modules_collection"

module RubyCritic
  class AnalysedModulesCollection
    def stink_score_average
      num_modules = @modules.size
      if num_modules.positive?
        map { |mod| mod.stink_score }.reduce(:+) / num_modules.to_f
      else
        0.0
      end
    end
  end
end
