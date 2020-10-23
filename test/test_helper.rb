# frozen_string_literal: true

if ENV["COVERAGE"] == "true"
  require "simplecov"
  require "simplecov-console"
  require "codecov"

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console,
    SimpleCov::Formatter::Codecov,
  ]

  SimpleCov.start do
    track_files "lib/**/*.rb"
  end

  puts "Using SimpleCov v#{SimpleCov::VERSION}"
end

require "minitest/autorun"
require "minitest/pride"
require "minitest/around/spec"
require "minitest/stub_any_instance"

require "skunk/rubycritic/analysed_module"

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
