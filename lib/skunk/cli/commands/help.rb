# frozen_string_literal: true

require "skunk/cli/commands/base"
require "rubycritic/commands/help"

module Skunk
  module Cli
    module Command
      class Help < RubyCritic::Command::Help
      end
    end
  end
end
