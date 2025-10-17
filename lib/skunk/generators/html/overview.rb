# frozen_string_literal: true

require "rubycritic/generators/html/base"

require "skunk/generators/html/path_truncator"
require "skunk/generators/html/file_data"
require "skunk/analysis"

module Skunk
  module Generator
    module Html
      # Generates an HTML overview report for the analysed modules.
      class Overview < RubyCritic::Generator::Html::Base
        def self.erb_template(template_path)
          ERB.new(File.read(File.join(TEMPLATES_DIR, template_path)))
        end

        TEMPLATES_DIR = File.expand_path("templates", __dir__)
        TEMPLATE = erb_template("skunk_overview.html.erb")

        def initialize(analysed_modules)
          @analysed_modules = analysed_modules
          @analysis = Skunk::Analysis.new(analysed_modules)
          @generated_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
          @skunk_version = Skunk::VERSION
        end

        def file_name
          "skunk_overview.html"
        end

        def render
          TEMPLATE.result(binding)
        end

        def analysed_modules_count
          @analysis.analysed_modules_count
        end

        def skunk_score_total
          @analysis.skunk_score_total
        end

        def skunk_score_average
          @analysis.skunk_score_average
        end

        def files
          @files ||= @analysis.sorted_modules.map do |module_data|
            FileData.new(module_data)
          end
        end
      end
    end
  end
end
