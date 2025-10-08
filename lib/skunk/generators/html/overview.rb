# frozen_string_literal: true

require "rubycritic/generators/html/base"

require "skunk/generators/html/path_truncator"
require "skunk/generators/html/skunk_data"

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
          @data = SkunkData.new(analysed_modules)
        end

        def file_name
          "skunk_overview.html"
        end

        def render
          data = @data
          TEMPLATE.result(binding)
        end
      end
    end
  end
end
