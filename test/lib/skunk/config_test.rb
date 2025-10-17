# frozen_string_literal: true

require "minitest/autorun"
require_relative "../../../lib/skunk/config"

module Skunk
  # Test class for Skunk::Config functionality
  class ConfigTest < Minitest::Test
    # Reset configuration before each test to ensure clean state
    # This method doesn't depend on instance state as it's a class-level operation
    def setup
      Config.reset
    end

    def test_default_format
      assert_equal [:json], Config.formats
    end

    def test_set_formats_with_array
      Config.formats = %i[html json]
      assert_equal %i[html json], Config.formats
    end

    def test_set_formats_with_single_format
      Config.formats = :html
      assert_equal [:html], Config.formats
    end

    def test_set_formats_filters_unsupported_formats
      Config.formats = %i[html json unsupported xml]
      assert_equal %i[html json], Config.formats
    end

    def test_set_formats_with_empty_array_defaults_to_json
      Config.formats = []
      assert_equal [:json], Config.formats
    end

    def test_add_format
      Config.add_format(:html)
      assert_equal %i[json html], Config.formats
    end

    def test_add_format_ignores_duplicates
      Config.add_format(:html)
      Config.add_format(:html) # This should be ignored as duplicate
      assert_equal %i[json html], Config.formats
    end

    def test_add_format_ignores_unsupported_formats
      Config.add_format(:unsupported)
      assert_equal [:json], Config.formats
    end

    def test_remove_format
      Config.formats = %i[json html]
      Config.remove_format(:html)
      assert_equal [:json], Config.formats
    end

    def test_remove_format_defaults_to_json_when_empty
      Config.remove_format(:json)
      assert_equal [:json], Config.formats
    end

    def test_supported_format
      assert Config.supported_format?(:json)
      assert Config.supported_format?(:html)
      refute Config.supported_format?(:xml)
      refute Config.supported_format?(:unsupported)
    end

    def test_supported_formats
      expected = %i[json html]
      assert_equal expected, Config.supported_formats
    end

    def test_reset
      Config.formats = [:html]
      Config.reset
      assert_equal [:json], Config.formats
    end
  end
end
