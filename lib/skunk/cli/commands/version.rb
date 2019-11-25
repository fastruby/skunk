# frozen_string_literal: true

require "rubycritic/commands/version"

# nodoc #
module Skunk
  module Command
    # Shows skunk version
    class Version < RubyCritic::Command::Version
      def execute
        print Skunk::VERSION
        status_reporter
      end
    end
  end
end
