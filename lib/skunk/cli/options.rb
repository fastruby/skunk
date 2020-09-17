# frozen_string_literal: true

require "skunk/cli/options/argv"
require "rubycritic/cli/options/file"

module Skunk
  module Cli
    # Knows how to parse options passed to the CLI application
    class Options
      attr_reader :argv_options, :file_options

      def initialize(argv)
        @argv_options = Argv.new(argv)
        @file_options = RubyCritic::Cli::Options::File.new
      end

      def parse
        argv_options.parse
        file_options.parse
        self
      end

      def output_stream
        @argv_options.output_filename.nil? ? $stdout : File.open(@argv_options.output_filename, "w")
      end

      # :reek:NilCheck
      def to_h
        file_hash = file_options.to_h
        argv_hash = argv_options.to_h

        file_hash.merge(argv_hash) do |_, file_option, argv_option|
          Array(argv_option).empty? ? file_option : argv_option
        end
      end
    end
  end
end
