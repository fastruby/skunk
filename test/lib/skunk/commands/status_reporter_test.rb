# frozen_string_literal: true

require "test_helper"

require "skunk/commands/status_reporter"

describe Skunk::Command::StatusReporter do
  describe "#update_status_message" do
    let(:reporter) { Skunk::Command::StatusReporter.new({}) }

    it "reports a simple status message" do
      _(reporter.update_status_message).must_equal ""
    end
  end
end
