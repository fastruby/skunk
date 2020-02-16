# frozen_string_literal: true

require "test_helper"
require "skunk/cli/application"

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
  end
end
