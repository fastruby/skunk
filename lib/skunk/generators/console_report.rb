# frozen_string_literal: true

require "erb"
require "terminal-table"

require "skunk/generators/console/simple"

module Skunk
  module Generator
    # Generates a console report for the analysed modules.
    class ConsoleReport
      def initialize(analysed_modules)
        @analysed_modules = analysed_modules
      end

      def generate_report
        puts generator.render
      end

      private

      def generator
        @generator ||= Skunk::Generator::Console::Simple.new(@analysed_modules)
      end
    end
  end
end
