# frozen_string_literal: true

require "test_helper"

require "skunk/command_factory"
require "skunk/commands/default"
require "skunk/commands/version"

describe Skunk::CommandFactory do
  describe ".command_class" do
    context "when mode does not exist" do
      it "returns the default command" do
        command = Skunk::CommandFactory.command_class(:foo)

        _(command).must_equal Skunk::Command::Default
      end
    end

    context "when mode exists" do
      it "returns the version command" do
        command = Skunk::CommandFactory.command_class(:version)

        _(command).must_equal Skunk::Command::Version
      end
    end
  end
end
