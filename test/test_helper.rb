# frozen_string_literal: true

if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start do
    track_files '/lib/'
  end
end

require 'minitest/autorun'
require 'minitest/pride'

def context(*args, &block)
  describe(*args, &block)
end

# This class is to encapsulate avoid specs class called those paths methods accidentally
module PathHelper
  class << self
    def project_path
      File.expand_path('..', __dir__)
    end
  end
end
