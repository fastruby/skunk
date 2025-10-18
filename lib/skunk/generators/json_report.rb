# frozen_string_literal: true

require "skunk/generators/json/simple"

module Skunk
  module Generator
    # Generates a JSON report for the analysed modules.
    class JsonReport
      def initialize(analysed_modules)
        @analysed_modules = analysed_modules
      end

      def generate_report
        FileUtils.mkdir_p(generator.file_directory)
        puts "#{report_name} generated at #{generator.file_pathname}"
        File.write(generator.file_pathname, generator.render)
      end

      private

      def generator
        Skunk::Generator::Json::Simple.new(@analysed_modules)
      end

      def report_name
        self.class.name.split("::").last
            .gsub(/([a-z])([A-Z])/, '\1 \2')
            .downcase
            .capitalize
      end
    end
  end
end
