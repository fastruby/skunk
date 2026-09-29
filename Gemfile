# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in skunk.gemspec
gemspec

gem "reek"

# Pinned so the CI matrix lints against one RuboCop instead of each Ruby
# resolving whatever version it happens to support. Rubies older than 3.1 cannot
# install it: reek and rubycritic hold parser below 3.3 there, while RuboCop
# 1.60 and up require it, so those rubies get no RuboCop and the Rakefile drops
# the lint task for them. They still run the tests and reek.
gem "rubocop", "~> 1.81.0" if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.1")
