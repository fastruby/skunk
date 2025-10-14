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
  spec.description   = "Knows how to calculate the SkunkScore for a set of Ruby modules"
  spec.homepage      = "https://github.com/fastruby/skunk"

  spec.required_ruby_version = [">= 2.4.0"]

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://www.rubygems.org"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/fastruby/skunk"
    spec.metadata["changelog_uri"] = "https://github.com/fastruby/skunk/blob/main/CHANGELOG.md"
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

  spec.add_dependency "base64"
  spec.add_dependency "rubycritic", ">= 4.5.2", "< 5.0"
  spec.add_dependency "terminal-table", "~> 3.0"

  spec.add_development_dependency "codecov", "~> 0.1.16"
  spec.add_development_dependency "debug"
  spec.add_development_dependency "minitest", "< 6"
  spec.add_development_dependency "minitest-around", "~> 0.5.0"
  spec.add_development_dependency "minitest-stub_any_instance", "~> 1.0.2"
  spec.add_development_dependency "minitest-stub-const", "~> 0.6"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "reek"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "simplecov", "~> 0.18"
  spec.add_development_dependency "simplecov-console", "0.5.0"
  spec.add_development_dependency "webmock", "~> 3.10.0"
end
