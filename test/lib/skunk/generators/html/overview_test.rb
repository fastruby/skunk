# frozen_string_literal: true

require "minitest/autorun"
require "skunk/generators/html/overview"
require "skunk/config"

module Skunk
  module Generator
    module Html
      class OverviewTest < Minitest::Test
        def teardown
          Skunk::Config.reset
        end

        def test_root_directory_uses_skunk_config_root
          Skunk::Config.root = "tmp/custom_html"
          analysed_modules = Minitest::Mock.new
          generator = Overview.new(analysed_modules)

          root = generator.send(:root_directory)
          assert_equal File.expand_path("tmp/custom_html", Dir.pwd), root.to_s
        end
      end
    end
  end
end