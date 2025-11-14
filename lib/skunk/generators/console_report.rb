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
      def initialize(analysed_modules)
        @analysed_modules = analysed_modules
      end

      def generate_report
        content = generator.render
        puts content
        FileUtils.mkdir_p(file_directory)
        File.write(file_pathname, content)
      end

      private

      def generator
        @generator ||= Skunk::Generator::Console::Simple.new(@analysed_modules)
      end

      def file_directory
        @file_directory ||= Pathname.new(Skunk::Config.root)
      end

      def file_pathname
        Pathname.new(file_directory).join("skunk_console.txt")
      end
    end
  end
end
