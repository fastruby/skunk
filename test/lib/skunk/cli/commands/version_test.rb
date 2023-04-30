# frozen_string_literal: true

require "test_helper"

require "skunk/cli/commands/version"
require "skunk/cli/options"

describe Skunk::Cli::Command::Version do
  describe "#execute" do
    let(:msg) { Skunk::VERSION }
    let(:options) { ["--version"] }
    let(:opts) { Skunk::Cli::Options.new(options).parse }
    let(:subject) { Skunk::Cli::Command::Version.new(opts.to_h) }

    it "outputs the right version message" do
      assert_output(msg) do
        subject.execute
      end
    end

    describe "#sharing?" do
      it "returns false" do
        _(subject.sharing?).must_equal false
      end
    end
  end
end
