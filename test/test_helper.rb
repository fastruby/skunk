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
require "vcr"

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

VCR.configure do |config|
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = false
  config.cassette_library_dir = "test/samples/vcr"
end
