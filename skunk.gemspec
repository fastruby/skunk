# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "skunk/version"

Gem::Specification.new do |spec|
  spec.name          = "skunk"
  spec.version       = Skunk::VERSION
  spec.authors       = ["Ernesto Tagwerker"]
  spec.email         = ["ernesto+github@ombulabs.com"]
  spec.licenses      = ["MIT"]
  spec.summary       = "A library to assess code quality vs. code coverage"
  spec.description   = "Knows how to calculate the StinkScore for a Ruby file"
  spec.homepage      = "https://github.com/fastruby/skunk"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://www.rubygems.org"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/fastruby/skunk"
    spec.metadata["changelog_uri"] = "https://github.com/fastruby/skunk/changelog"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(bin|test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rubycritic", "~> 4.0"
  spec.add_dependency "terminal-table", "~> 1.8.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "byebug", "~> 11"
  spec.add_development_dependency "codecov", "~> 0.1.16"
  spec.add_development_dependency "minitest", "~> 5.8.4"
  spec.add_development_dependency "minitest-around", "~> 0.5.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "reek", "~> 5.4.0"
  spec.add_development_dependency "rubocop", "< 1.0"
  spec.add_development_dependency "simplecov", "~> 0.18.1"
  spec.add_development_dependency "simplecov-console", "0.5.0"
end
