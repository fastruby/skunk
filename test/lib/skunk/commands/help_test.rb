# frozen_string_literal: true

require "test_helper"

require "skunk/commands/help"
require "skunk/cli/options"

describe Skunk::Command::Help do
  describe "#execute" do
    let(:msg) do
      <<~HELP
        Usage: skunk [options] [paths]
            -b, --branch BRANCH              Set branch to compare
            -o, --out FILE                   Output report to file
            -v, --version                    Show gem's version
            -h, --help                       Show this message
      HELP
    end
    let(:options) { ["--help"] }
    let(:opts) { Skunk::Cli::Options.new(options).parse }
    let(:subject) { Skunk::Command::Help.new(opts.to_h) }

    it "outputs the right help message" do
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
