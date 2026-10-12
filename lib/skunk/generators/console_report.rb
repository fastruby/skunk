# frozen_string_literal: true

require "erb"
require "terminal-table"
require "pathname"
require "fileutils"

require "skunk/generators/console/simple"
require "skunk/config"

module Skunk
  module Generator
    # Generates a console report for the analysed modules.
    class ConsoleReport
      FILE_NAME = "skunk_report.txt"

      def initialize(analysed_modules)
        @analysed_modules = analysed_modules
      end

      def generate_report
        content = generator.render
        puts content
        write_file(content) if Skunk::Config.root_set?
      end

      private

      def generator
        @generator ||= Skunk::Generator::Console::Simple.new(@analysed_modules)
      end

      # Only written when --out is given, so a plain `skunk` run stays free of filesystem side effects
      def write_file(content)
        FileUtils.mkdir_p(file_directory)
        File.write(file_pathname, content)
      end

      def file_directory
        @file_directory ||= Pathname.new(Skunk::Config.root)
      end

      def file_pathname
        file_directory.join(FILE_NAME)
      end
    end
  end
end
