# frozen_string_literal: true

require "test_helper"

require "skunk/cli/commands/version"
require "skunk/cli/options"

describe Skunk::Cli::Command::Version do
  describe "#execute" do
    let(:msg) { Skunk::VERSION }

    it "outputs the right version message" do
      options = ["--version"]
      opts = Skunk::Cli::Options.new(options).parse
      subject = Skunk::Cli::Command::Version.new(opts.to_h)

      assert_output(msg) do
        subject.execute
      end
    end
  end
end
