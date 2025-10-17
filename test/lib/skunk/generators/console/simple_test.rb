# frozen_string_literal: true

require "test_helper"

require "skunk/generators/console/simple"

# Helper methods for this test file
module SkunkMethods
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
  # @return [Object, nil]
  def worst_module
    @worst_module ||= sorted_modules.first
  end

  # Returns modules sorted by Skunk score in descending order (worst first)
  # @return [Array<Object>]
  def sorted_modules
    @sorted_modules ||= non_test_modules.sort_by(&:skunk_score).reverse!
  end

  # Returns only non-test modules (excludes test and spec directories)
  # @return [Array<Object>]
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

  # Returns files as an array of hashes (for JSON serialization)
  # @return [Array<Hash>]
  def files_as_hash
    @files_as_hash ||= sorted_modules.map(&:to_hash)
  end

  private

  # Determines if a module is a test module based on its path
  # @param a_module [Object] The module to check
  # @return [Boolean]
  def test_module?(a_module)
    pathname = a_module.pathname
    directory_is_test?(pathname) || filename_is_test?(pathname)
  end

  # Checks if the directory path indicates a test module
  # @param pathname [Pathname] The pathname to check
  # @return [Boolean]
  def directory_is_test?(pathname)
    module_path = pathname.dirname.to_s
    module_path.start_with?("test", "spec") || module_path.end_with?("test", "spec")
  end

  # Checks if the filename indicates a test module
  # @param pathname [Pathname] The pathname to check
  # @return [Boolean]
  def filename_is_test?(pathname)
    filename = pathname.basename.to_s
    filename.end_with?("_test.rb", "_spec.rb")
  end
end

# Helper methods for creating mock objects
def create_analysed_module(path, options = {})
  # Create a simple object that responds to the methods we need
  mock_module = Object.new

  # Define the methods we need
  mock_module.define_singleton_method(:pathname) { Pathname.new(path) }
  mock_module.define_singleton_method(:skunk_score) { options[:skunk_score] || 0.0 }
  mock_module.define_singleton_method(:churn_times_cost) { options[:churn_times_cost] || 0.0 }
  mock_module.define_singleton_method(:churn) { options[:churn] || 1 }
  mock_module.define_singleton_method(:cost) { options[:cost] || 0.0 }
  mock_module.define_singleton_method(:coverage) { options[:coverage] || 100.0 }

  # Add to_hash method for JSON serialization
  mock_module.define_singleton_method(:to_hash) do
    {
      file: pathname.to_s,
      skunk_score: skunk_score,
      churn_times_cost: churn_times_cost,
      churn: churn,
      cost: cost.round(2),
      coverage: coverage.round(2)
    }
  end

  mock_module
end

# Creates a collection of analysed modules for testing
# @param analysed_modules [Array<Object>] Array of analysed modules
# @return [Object] A collection with the modules
def create_collection(analysed_modules)
  # Create a simple array that responds to the methods we need
  collection = analysed_modules.dup

  # Add the Skunk methods to the collection
  collection.extend(SkunkMethods)
  collection
end

# Creates a simple mock collection for testing console generators
# @return [Object] A collection with one mock module
def create_simple_mock_collection
  mock_module = create_analysed_module("samples/rubycritic/analysed_module.rb",
                                       skunk_score: 0.59,
                                       churn_times_cost: 0.59,
                                       churn: 1,
                                       cost: 0.59,
                                       coverage: 100.0)
  create_collection([mock_module])
end

module Skunk
  module Generator
    module Console
      class SimpleTest < Minitest::Test
        def setup
          @analysed_modules = create_simple_mock_collection
          @simple = Simple.new(@analysed_modules)
        end

        def test_initializes_with_analysed_modules
          assert_equal @analysed_modules, @simple.instance_variable_get(:@analysed_modules)
        end

        def test_render_includes_expected_content
          output = @simple.render

          assert_includes output, "SkunkScore Total:"
          assert_includes output, "Modules Analysed:"
          assert_includes output, "SkunkScore Average:"
          assert_includes output, "Generated with Skunk"
        end

        def test_render_includes_table_headers
          output = @simple.render

          assert_includes output, "file"
          assert_includes output, "skunk_score"
          assert_includes output, "churn_times_cost"
          assert_includes output, "churn"
          assert_includes output, "cost"
          assert_includes output, "coverage"
        end

        def test_headings_constant
          expected_headings = %w[file skunk_score churn_times_cost churn cost coverage]
          assert_equal expected_headings, Simple::HEADINGS
        end
      end
    end
  end
end
