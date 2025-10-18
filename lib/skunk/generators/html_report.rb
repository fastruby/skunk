# frozen_string_literal: true

require "fileutils"

require "rubycritic/browser"
require "rubycritic/generators/html_report"

require "skunk/generators/html/overview"

module Skunk
  module Generator
    # Generates an HTML report for the analysed modules.
    class HtmlReport < RubyCritic::Generator::HtmlReport
      def initialize(analysed_modules)
        super
        @analysed_modules = analysed_modules
      end

      def generate_report
        create_directories_and_files
        puts "#{report_name} generated at #{report_location}"
        browser.open unless RubyCritic::Config.no_browser
      end

      def create_directories_and_files
        Array(generators).each do |generator|
          FileUtils.mkdir_p(generator.file_directory)
          File.write(generator.file_pathname, generator.render)
        end
      end

      private

      def generators
        @generators ||= [
          overview_generator
        ]
      end

      def overview_generator
        @overview_generator ||= Skunk::Generator::Html::Overview.new(@analysed_modules)
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
