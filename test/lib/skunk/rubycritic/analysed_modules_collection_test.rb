# frozen_string_literal: true

require "test_helper"

require "skunk/rubycritic/analysed_modules_collection"
require "skunk/rubycritic/analysed_module"

describe RubyCritic::AnalysedModulesCollection do
  let(:analysed_modules) { [] }
  let(:collection) { create_collection(analysed_modules) }

  describe "#analysed_modules_count" do
    context "with no modules" do
      it "returns 0" do
        _(collection.analysed_modules_count).must_equal 0
      end
    end

    context "with non-test modules" do
      let(:analysed_modules) { [create_analysed_module("lib/file.rb"), create_analysed_module("app/model.rb")] }

      it "returns the count of non-test modules" do
        _(collection.analysed_modules_count).must_equal 2
      end
    end

    context "with test modules" do
      let(:analysed_modules) do
        [
          create_analysed_module("lib/file.rb"),
          create_analysed_module("test/file_test.rb"),
          create_analysed_module("spec/file_spec.rb")
        ]
      end

      it "excludes test modules from count" do
        _(collection.analysed_modules_count).must_equal 1
      end
    end
  end

  describe "#skunk_score_total" do
    context "with no modules" do
      it "returns 0" do
        _(collection.skunk_score_total).must_equal 0
      end
    end

    context "with modules" do
      let(:analysed_modules) do
        [
          create_analysed_module("lib/file1.rb", skunk_score: 10.5),
          create_analysed_module("lib/file2.rb", skunk_score: 20.3)
        ]
      end

      it "returns the sum of skunk scores" do
        _(collection.skunk_score_total).must_equal 30.8
      end
    end

    context "with test modules" do
      let(:analysed_modules) do
        [
          create_analysed_module("lib/file.rb", skunk_score: 10.0),
          create_analysed_module("test/file_test.rb", skunk_score: 50.0)
        ]
      end

      it "excludes test modules from total" do
        _(collection.skunk_score_total).must_equal 10.0
      end
    end
  end

  describe "#skunk_score_average" do
    context "with no modules" do
      it "returns 0" do
        _(collection.skunk_score_average).must_equal 0.0
      end
    end

    context "with modules" do
      let(:analysed_modules) do
        [
          create_analysed_module("lib/file1.rb", skunk_score: 10.0),
          create_analysed_module("lib/file2.rb", skunk_score: 20.0)
        ]
      end

      it "returns the average skunk score" do
        _(collection.skunk_score_average).must_equal 15.0
      end
    end

    context "with decimal average" do
      let(:analysed_modules) do
        [
          create_analysed_module("lib/file1.rb", skunk_score: 10.0),
          create_analysed_module("lib/file2.rb", skunk_score: 11.0)
        ]
      end

      it "rounds to 2 decimal places" do
        _(collection.skunk_score_average).must_equal 10.5
      end
    end
  end

  describe "#total_churn_times_cost" do
    context "with no modules" do
      it "returns 0" do
        _(collection.total_churn_times_cost).must_equal 0
      end
    end

    context "with modules" do
      let(:analysed_modules) do
        [
          create_analysed_module("lib/file1.rb", churn_times_cost: 5.0),
          create_analysed_module("lib/file2.rb", churn_times_cost: 15.0)
        ]
      end

      it "returns the sum of churn times cost" do
        _(collection.total_churn_times_cost).must_equal 20.0
      end
    end
  end

  describe "#worst_module" do
    context "with no modules" do
      it "returns nil" do
        _(collection.worst_module).must_be_nil
      end
    end

    context "with modules" do
      let(:worst_module) { create_analysed_module("lib/worst.rb", skunk_score: 100.0) }
      let(:best_module) { create_analysed_module("lib/best.rb", skunk_score: 10.0) }
      let(:analysed_modules) { [best_module, worst_module] }

      it "returns the module with highest skunk score" do
        _(collection.worst_module).must_equal worst_module
      end
    end
  end

  describe "#sorted_modules" do
    context "with no modules" do
      it "returns empty array" do
        _(collection.sorted_modules).must_equal []
      end
    end

    context "with modules" do
      let(:module1) { create_analysed_module("lib/file1.rb", skunk_score: 10.0) }
      let(:module2) { create_analysed_module("lib/file2.rb", skunk_score: 30.0) }
      let(:module3) { create_analysed_module("lib/file3.rb", skunk_score: 20.0) }
      let(:analysed_modules) { [module1, module2, module3] }

      it "returns modules sorted by skunk score descending" do
        _(collection.sorted_modules).must_equal [module2, module3, module1]
      end
    end

    context "with test modules" do
      let(:spec_module) { create_analysed_module("test/file_test.rb", skunk_score: 100.0) }
      let(:lib_module) { create_analysed_module("lib/file.rb", skunk_score: 10.0) }
      let(:analysed_modules) { [spec_module, lib_module] }

      it "excludes test modules from sorted list" do
        _(collection.sorted_modules).must_equal [lib_module]
      end
    end
  end

  describe "#non_test_modules" do
    context "with mixed modules" do
      let(:analysed_modules) do
        [
          create_analysed_module("lib/file.rb"),
          create_analysed_module("test/file_test.rb"),
          create_analysed_module("spec/file_spec.rb"),
          create_analysed_module("app/model.rb")
        ]
      end

      it "filters out test and spec modules" do
        non_test = collection.non_test_modules
        _(non_test.size).must_equal 2
        _(non_test.map(&:pathname).map(&:to_s)).must_include "lib/file.rb"
        _(non_test.map(&:pathname).map(&:to_s)).must_include "app/model.rb"
      end
    end

    context "with modules in test directories" do
      let(:analysed_modules) do
        [
          create_analysed_module("test/unit/file.rb"),
          create_analysed_module("spec/unit/file.rb"),
          create_analysed_module("lib/file.rb")
        ]
      end

      it "filters out modules in test directories" do
        non_test = collection.non_test_modules
        _(non_test.size).must_equal 1
        _(non_test.first.pathname.to_s).must_equal "lib/file.rb"
      end
    end

    context "with modules ending in test/spec" do
      let(:analysed_modules) do
        [
          create_analysed_module("lib/file_test.rb"),
          create_analysed_module("lib/file_spec.rb"),
          create_analysed_module("lib/file.rb")
        ]
      end

      it "filters out modules ending in test/spec" do
        non_test = collection.non_test_modules
        _(non_test.size).must_equal 1
        _(non_test.first.pathname.to_s).must_equal "lib/file.rb"
      end
    end
  end

  describe "#to_hash" do
    let(:analysed_modules) do
      [
        create_analysed_module("lib/file.rb", skunk_score: 10.0, churn_times_cost: 5.0)
      ]
    end

    it "returns a hash with all analysis data including files" do
      hash = collection.to_hash
      _(hash[:analysed_modules_count]).must_equal 1
      _(hash[:skunk_score_total]).must_equal 10.0
      _(hash[:skunk_score_average]).must_equal 10.0
      _(hash[:total_churn_times_cost]).must_equal 5.0
      _(hash[:worst_pathname]).must_equal Pathname.new("lib/file.rb")
      _(hash[:worst_score]).must_equal 10.0
      _(hash[:files]).must_be_kind_of Array
      _(hash[:files].size).must_equal 1
      _(hash[:files].first[:file]).must_equal "lib/file.rb"
      _(hash[:files].first[:skunk_score]).must_equal 10.0
    end
  end

  private

  def create_collection(modules)
    # Create a collection by manually setting the @modules instance variable
    # This bypasses the complex initialization that expects file paths
    collection = RubyCritic::AnalysedModulesCollection.new([], [])
    collection.instance_variable_set(:@modules, modules)
    collection
  end

  def create_analysed_module(path, skunk_score: 0.0, churn_times_cost: 0.0)
    module_path = Pathname.new(path)
    analysed_module = RubyCritic::AnalysedModule.new(
      pathname: module_path,
      smells: [],
      churn: 1,
      committed_at: Time.now
    )

    add_mock_methods_to_module(analysed_module, skunk_score, churn_times_cost)
  end

  def add_mock_methods_to_module(analysed_module, skunk_score, churn_times_cost)
    # Mock the skunk_score and churn_times_cost methods
    analysed_module.define_singleton_method(:skunk_score) { @skunk_score ||= 0.0 }
    analysed_module.define_singleton_method(:skunk_score=) { |value| @skunk_score = value }
    analysed_module.define_singleton_method(:churn_times_cost) { @churn_times_cost ||= 0.0 }
    analysed_module.define_singleton_method(:churn_times_cost=) { |value| @churn_times_cost = value }

    analysed_module.skunk_score = skunk_score
    analysed_module.churn_times_cost = churn_times_cost
    analysed_module
  end
end
