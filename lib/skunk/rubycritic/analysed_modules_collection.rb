# frozen_string_literal: true

require "rubycritic/core/analysed_modules_collection"

module RubyCritic
  # Monkey-patches RubyCritic::AnalysedModulesCollection to add Skunk analysis methods
  class AnalysedModulesCollection
    # Returns the count of non-test modules
    # @return [Integer]
    def analysed_modules_count
      @analysed_modules_count ||= non_test_modules.count
    end

    # Returns the total Skunk score across all non-test modules
    # @return [Float]
    def skunk_score_total
      @skunk_score_total ||= non_test_modules.sum(&:skunk_score)
    end

    # Returns the average Skunk score across all non-test modules
    # @return [Float]
    def skunk_score_average
      return 0.0 if analysed_modules_count.zero?

      (skunk_score_total.to_d / analysed_modules_count).to_f.round(2)
    end

    # Returns the total churn times cost across all non-test modules
    # @return [Float]
    def total_churn_times_cost
      @total_churn_times_cost ||= non_test_modules.sum(&:churn_times_cost)
    end

    # Returns the module with the highest Skunk score (worst performing)
    # @return [RubyCritic::AnalysedModule, nil]
    def worst_module
      @worst_module ||= sorted_modules.first
    end

    # Returns modules sorted by Skunk score in descending order (worst first)
    # @return [Array<RubyCritic::AnalysedModule>]
    def sorted_modules
      @sorted_modules ||= non_test_modules.sort_by(&:skunk_score).reverse!
    end

    # Returns only non-test modules (excludes test and spec directories)
    # @return [Array<RubyCritic::AnalysedModule>]
    def non_test_modules
      @non_test_modules ||= reject do |a_module|
        test_module?(a_module)
      end
    end

    # Returns a hash representation of the analysis results
    # @return [Hash]
    def to_hash
      {
        analysed_modules_count: analysed_modules_count,
        skunk_score_total: skunk_score_total,
        skunk_score_average: skunk_score_average,
        total_churn_times_cost: total_churn_times_cost,
        worst_pathname: worst_module&.pathname,
        worst_score: worst_module&.skunk_score,
        files: files_as_hash
      }
    end

    private

    # Returns files as an array of hashes (for JSON serialization)
    # @return [Array<Hash>]
    def files_as_hash
      @files_as_hash ||= sorted_modules.map(&:to_hash)
    end

    # Determines if a module is a test module based on its path
    # @param a_module [RubyCritic::AnalysedModule] The module to check
    # @return [Boolean]
    def test_module?(a_module)
      pathname = a_module.pathname
      directory_is_test?(pathname) || filename_is_test?(pathname)
    end

    # Checks if the directory path indicates a test module
    # @param pathname [Pathname] The pathname to check
    # @return [Boolean]
    # :reek:UtilityFunction
    def directory_is_test?(pathname)
      module_path = pathname.dirname.to_s
      module_path.start_with?("test", "spec") || module_path.end_with?("test", "spec")
    end

    # Checks if the filename indicates a test module
    # @param pathname [Pathname] The pathname to check
    # @return [Boolean]
    # :reek:UtilityFunction
    def filename_is_test?(pathname)
      filename = pathname.basename.to_s
      filename.end_with?("_test.rb", "_spec.rb")
    end
  end
end
