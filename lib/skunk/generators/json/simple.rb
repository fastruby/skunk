# frozen_string_literal: true

require "pathname"

require "rubycritic/configuration"
require "skunk/analysis"

module Skunk
  module Generator
    module Json
      # Generates a JSON report for the analysed modules.
      class Simple
        def initialize(analysed_modules)
          @analysed_modules = analysed_modules
          @analysis = Skunk::Analysis.new(analysed_modules)
        end

        FILE_NAME = "skunk_report.json"

        def render
          JSON.dump(data)
        end

        def data
          @analysis.to_hash
        end

        def file_directory
          @file_directory ||= Pathname.new(RubyCritic::Config.root)
        end

        def file_pathname
          Pathname.new(file_directory).join(FILE_NAME)
        end
      end
    end
  end
end
