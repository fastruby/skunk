# frozen_string_literal: true

require "test_helper"

require "skunk/cli/commands/help"
require "skunk/cli/options"

describe Skunk::Cli::Command::Help do
  describe "#execute" do
    MSG = <<~HELP
      Usage: skunk [options] [paths]
          -p, --path [PATH]                Set path where report will be saved (tmp/skunk by default)
          -b, --branch BRANCH              Set branch to compare
          -v, --version                    Show gem's version
          -h, --help                       Show this message
    HELP

    it "outputs the right help message" do
      options = ["--help"]
      opts = Skunk::Cli::Options.new(options).parse
      subject = Skunk::Cli::Command::Help.new(opts.to_h)

      assert_output(MSG) do
        subject.execute
      end
    end
  end
end
