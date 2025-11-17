# frozen_string_literal: true

require "test_helper"
require "skunk/cli/application"
require "skunk/commands/default"
require "rubycritic/core/analysed_module"
require "minitest/stub_const"

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
      let(:success_code) { 0 }

      %w[help version].each do |argument|
        context "and option is #{argument}" do
          let(:argv) { ["--#{argument}"] }

          it "returns a success code (0)" do
            result = application.execute
            _(result).must_equal success_code
          end
        end
      end
    end

    context "when comparing two branches" do
      let(:argv) { ["-b main", "samples/rubycritic"] }
      let(:success_code) { 0 }

      it "returns a comparison" do
        result = application.execute
        _(result).must_equal success_code
      end
    end

    context "when passing an environment variable SHARE=true" do
      let(:argv) { ["--out=tmp", "samples/rubycritic"] }
      let(:success_code) { 0 }
      let(:generated_message) { "Generated with Skunk" }
      let(:shared_message) { "Shared at: https://skunk.fastruby.io/j" }
      let(:share_url) { "https://skunk.fastruby.io" }
      let(:report_path) { "tmp/skunk_report.txt" }

      around do |example|
        stub_request(:post, "#{share_url}/reports").to_return(
          status: 200,
          body: '{"id":"j"}',
          headers: { "Content-Type" => "application/json" }
        )
        example.call
      end

      it "share report to default server" do
        FileUtils.rm(report_path, force: true)
        FileUtils.mkdir_p("tmp")

        Skunk::Command::Default.stub_any_instance(:share_enabled?, true) do
          Skunk::Command::StatusSharer.stub_any_instance(:share_url, share_url) do
            Skunk::Command::StatusSharer.stub_any_instance(:share, "Shared at: #{share_url}/j") do
              stdout = capture_stdout do
                result = application.execute
                _(result).must_equal success_code
              end
              _(File.exist?(report_path)).must_equal true
              file_output = File.read(report_path)

              _(file_output).must_include(generated_message)
              _(stdout).must_include(shared_message)
            end
          end
        end
      end
    end
  end
end
