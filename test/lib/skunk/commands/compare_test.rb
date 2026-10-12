# frozen_string_literal: true

require "test_helper"
require "minitest/stub_const"

require "skunk/rubycritic/analysed_module"
require "skunk/commands/compare"

describe Skunk::Command::Compare do
  let(:paths) { "samples/rubycritic" }
  let(:compare_root_directory) { "test/support/tmp/rubycritic/compare/" }

  describe "#analyse_branch" do
    before do
      RubyCritic::Config.root = paths
      Skunk::Config.reset
      FileUtils.rm_rf("test/support/")
    end

    it "sets the skunk_score_average as the branch score" do
      ::RubyCritic::SourceControlSystem::Git.stub :switch_branch, nil do
        compare = Skunk::Command::Compare.new(paths: "samples/rubycritic")
        compare.analyse_branch(:base_branch)

        _(RubyCritic::Config.base_branch_score).must_equal 58.88
      end
    end

    it "creates the compare_root_directory if it doesn't exist" do
      ::RubyCritic::Config.configuration.stub(:compare_root_directory,
                                              compare_root_directory) do
        Skunk::Command::Compare.new(paths: "samples/rubycritic").build_details
        _(File.exist?(compare_root_directory)).must_equal true
      end
    end

    it "writes build_details.txt under --out when given" do
      Skunk::Config.root = "test/support/out"
      begin
        Skunk::Command::Compare.new(paths: "samples/rubycritic").build_details
        _(File.exist?("test/support/out/compare/build_details.txt")).must_equal true
      ensure
        FileUtils.rm_rf("test/support/out")
        Skunk::Config.reset
      end
    end
  end
end
