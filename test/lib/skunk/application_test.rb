# frozen_string_literal: true

require "test_helper"
require "skunk/cli/application"
require "rubycritic/core/analysed_module"

describe Skunk::Cli::Application do
  describe "#execute" do
    let(:argv) { ["--help"] }
    let(:application) { Skunk::Cli::Application.new(argv) }

    context "when passing an invalid option" do
      let(:argv) { ["--foo"] }
      let(:error_code) { 1 }

      it "returns an error code (1)" do
        result = application.execute
        _(result).must_equal error_code
      end
    end

    context "when passing a valid option" do
      let(:argv) { ["--help"] }
      let(:success_code) { 0 }

      it "returns a success code (0)" do
        result = application.execute
        _(result).must_equal success_code
      end
    end

    context "when passing --out option with a file" do
      require "fileutils"

      let(:argv) { ["--out=tmp/generated_report.txt", "samples/rubycritic"] }
      let(:success_code) { 0 }

      it "writes output to the file" do
        FileUtils.rm("tmp/generated_report.txt", force: true)
        FileUtils.mkdir_p("tmp")

        RubyCritic::AnalysedModule.stub_any_instance(:churn, 1) do
          RubyCritic::AnalysedModule.stub_any_instance(:coverage, 100.0) do
            result = application.execute
            _(result).must_equal success_code
          end
        end

        _(File.read("tmp/generated_report.txt"))
          .must_equal File.read("test/samples/console_output.txt")
      end
    end

    context "when passing an environment variable SHARE=true" do
      let(:argv) { ["--out=tmp/shared_report.txt", "samples/rubycritic"] }
      let(:success_code) { 0 }
      let(:shared_message) do
        "Shared at: https://skunk.fastruby.io/j\n"
      end

      around do |example|
        VCR.use_cassette "skunk-fyi" do
          example.call
        end
      end

      it "share report to default server" do
        ENV["SHARE"] = "true"

        RubyCritic::AnalysedModule.stub_any_instance(:churn, 1) do
          RubyCritic::AnalysedModule.stub_any_instance(:coverage, 100.0) do
            result = application.execute
            _(result).must_equal success_code
            output = File.read("tmp/shared_report.txt")
            _(output).must_include(shared_message)
          end
        end

        ENV["SHARE"] = nil
      end
    end
  end
end
