# frozen_string_literal: true

module Skunk
  # Pick the right report generator based on the format specified in the
  # configuration. If the format is not supported, it will default to ConsoleReport.
  module Reporter
    REPORT_GENERATOR_CLASS_FORMATS = %i[json].freeze

    def self.generate_report(analysed_modules)
      RubyCritic::Config.formats.uniq.each do |format|
        report_generator_class(format).new(analysed_modules).generate_report
      end
    end

    def self.report_generator_class(config_format)
      if REPORT_GENERATOR_CLASS_FORMATS.include? config_format
        require "skunk/generators/#{config_format}_report"
        Generator.const_get("#{config_format.capitalize}Report")
      else
        require "skunk/generators/console_report"
        Generator::ConsoleReport
      end
    end
  end
end
