require "rubycritic/commands/version"
module Skunk
  module Command
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
