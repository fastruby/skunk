# frozen_string_literal: true

module Skunk
  module Command
    # Implements the needed methods for a successful compare output
    class Output
      def self.create_directory(directory)
        FileUtils.mkdir_p(directory) unless File.exist?(directory)
      end
    end
  end
end
