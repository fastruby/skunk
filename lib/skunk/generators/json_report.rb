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
        puts "#{report_name} generated at #{file_path}"
        File.write(file_path, generator.render)
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

      def file_path
        generator.file_pathname
      end
    end
  end
end
