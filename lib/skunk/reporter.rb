# frozen_string_literal: true

require "skunk/config"

module Skunk
  # Pick the right report generator based on the format specified in the
  # configuration. If the format is not supported, it will default to ConsoleReport.
  module Reporter
    def self.generate_report(analysed_modules)
      Config.formats.uniq.each do |format|
        report_generator_class(format).new(analysed_modules).generate_report
      end
    end

    def self.report_generator_class(config_format)
      if Config.supported_format?(config_format)
        require "skunk/generators/#{config_format}_report"
        Generator.const_get("#{config_format.capitalize}Report")
      else
        require "skunk/generators/console_report"
        Generator::ConsoleReport
      end
    end
  end
end
