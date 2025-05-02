# frozen_string_literal: true

require "rubycritic/generators/json_report"

require "skunk/generators/json/simple"

module Skunk
  module Generator
    # Generates a JSON report for the analysed modules.
    class JsonReport < RubyCritic::Generator::JsonReport
      def initialize(analysed_modules)
        super
        @analysed_modules = analysed_modules
      end

      private

      def generator
        Skunk::Generator::Json::Simple.new(@analysed_modules)
      end
    end
  end
end
