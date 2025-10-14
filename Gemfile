# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in skunk.gemspec
gemspec

gem "base64", "~> 0.3.0" if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4")
gem "reek", "~> 6.1"
gem "rubocop", "~> 1.48"
gem "vcr", "~> 6.1.0"
