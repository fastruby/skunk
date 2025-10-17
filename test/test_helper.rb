# frozen_string_literal: true

if ENV["COVERAGE"] == "true"
  require "simplecov"
  require "simplecov-console"
  require "codecov"

  formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console
  ]

  # Only add Codecov formatter if CODECOV_TOKEN is set
  formatters << SimpleCov::Formatter::Codecov if ENV["CODECOV_TOKEN"]

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(formatters)

  SimpleCov.start do
    add_filter "lib/skunk/version.rb"
    add_filter "test/lib"

    track_files "lib/**/*.rb"
  end

  puts "Using SimpleCov v#{SimpleCov::VERSION}"
end

require "minitest/autorun"
require "minitest/pride"
require "minitest/around/spec"
require "minitest/stub_any_instance"
require "webmock/minitest"

require "skunk"
require "skunk/rubycritic/analysed_module"

# Helper modules for testing
module MockHelpers
  # Helper methods for mocking in tests

  # Captures stdout output for testing
  # @return [String] The captured output
  def capture_stdout
    old_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end
end

# Include helper modules in Minitest::Test
class Minitest::Test
  include MockHelpers
end

def context(*args, &block)
  describe(*args, &block)
end

# This class is to encapsulate avoid specs class called those paths methods
# accidentally
module PathHelper
  class << self
    def project_path
      File.expand_path("..", __dir__)
    end
  end
end

def capture_output_streams
  $stdout = StringIO.new
  $stderr = StringIO.new
  yield
ensure
  $stdout = STDOUT
  $stderr = STDERR
end
