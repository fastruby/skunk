# frozen_string_literal: true

require "rubycritic/commands/version"

# nodoc #
module Skunk
  module Command

    # Shows skunk version
    class Version < RubyCritic::Command::Version
      def initialize(options)
        super
      end

      def execute
        print Skunk::VERSION
        status_reporter
      end
    end
  end
end
