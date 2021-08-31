# frozen_string_literal: true

require "test_helper"

require "skunk/cli/commands/help"
require "skunk/cli/options"

describe Skunk::Cli::Command::Help do
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

    it "outputs the right help message" do
      options = ["--help"]
      opts = Skunk::Cli::Options.new(options).parse
      subject = Skunk::Cli::Command::Help.new(opts.to_h)

      assert_output(msg) do
        subject.execute
      end
    end
  end
end
