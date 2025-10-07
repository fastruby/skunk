# frozen_string_literal: true

module Skunk
  module Generator
    module Html
      # Utility class for truncating file paths to show only the relevant project structure
      class PathTruncator
        attr_reader :file_path

        # Common project folder names to truncate from
        PROJECT_FOLDERS = %w[app lib src test spec features db].freeze

        # Truncates a file path to show only the relevant project structure
        # starting from the first project folder found
        #
        # @param file_path [String] The full file path to truncate
        # @return [String] The truncated path starting from the project folder
        # :reek:NilCheck
        def self.truncate(file_path)
          return file_path if file_path.nil?

          new(file_path).truncate
        end

        def initialize(file_path)
          @file_path = file_path.to_s
        end

        # :reek:TooManyStatements
        def truncate
          return file_path if file_path.empty?

          path_parts = file_path.split("/")
          folder_index = path_parts.find_index do |part|
            PROJECT_FOLDERS.include?(part)
          end

          if folder_index
            # rubocop:disable Style/SlicingWithRange
            path_parts[folder_index..-1].join("/")
            # rubocop:enable Style/SlicingWithRange
          else
            file_path
          end
        end
      end
    end
  end
end
