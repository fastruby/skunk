# Skunk

![skunk](logo.png)

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md) [![Build Status](https://travis-ci.org/fastruby/skunk.svg?branch=master)](https://travis-ci.org/fastruby/skunk) [![Maintainability](https://api.codeclimate.com/v1/badges/3e33d701ced16eee2420/maintainability)](https://codeclimate.com/github/fastruby/skunk/maintainability) [![Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/gems/skunk) [![codecov](https://codecov.io/gh/fastruby/skunk/branch/master/graph/badge.svg)](https://codecov.io/gh/fastruby/skunk)

Skunk is a RubyCritic extension to calculate a SkunkScore for a file or project. The SkunkScore is a value that assesses the technical debt of a module.

## Table of contents
* [What is the SkunkScore?](#what-is-the-skunkscore)
* [Getting started](#getting-started)
    * [Running SimpleCov](#running-simplecov)
* [Usage](#usage)
    * [Help commands](#help-commands)
    * [Generate the SkunkCore for your project](#generate-the-skunkcore-for-your-project)
    * [Comparing Feature Branches](#comparing-feature-branches)
* [Configuration](#configuration)
    * [Setting Output Formats](#setting-output-formats)
* [Sharing your SkunkScore](#sharing-your-skunkscore)
* [Contributing](#contributing)
* [Sponsorship](#sponsorship)

## What is the SkunkScore?

The main goal of the SkunkScore is to serve as a compass in your next refactoring adventure. It will help you answer these questions:

- What can I do to pay off technical debt?
- What are the most complicated files with the least code coverage?
- What are good candidates for my next test-writing efforts?
- What are good candidates for my next refactoring efforts?

To assess the technical debt of a module, Skunk takes into account:
- Code Complexity
- Code Smells
- Code Coverage

## Getting started

Start by including `skunk` in your Gemfile:

```ruby
gem 'skunk'
```

Then run `bundle`.

Or, install it yourself by running: `$ gem install skunk`

### Running SimpleCov to generate your Code Coverage report
Use SimpleCov to generate a report of how many statements are covered by your test suite (code coverage). That's how `skunk` knows what's the status of your test suite + code coverage.

Please refer to [SimpleCov's Getting Started Guide](https://github.com/simplecov-ruby/simplecov#getting-started) to install it and generate the coverage report.

SimpleCov was successfully installed when it generated a JSON file under `coverage/.resultset.json` in your application directory.

> :warning: Skunk runs `rubycritic`, which loads code coverage data from your `coverage/.resultset.json` file. Make sure to have this file for best SkunkScore results.

**Note:** after adding more tests to your application, run SimpleCov again to generate an updated Code Coverage. This way, skunk will generate a new SkunkScore.
## Usage

### Help commands

Run `skunk -h` to check out the help options:

```
Usage: skunk [options] [paths]
    -b, --branch BRANCH              Set branch to compare
    -o, --out FILE                   Output report to file
    -v, --version                    Show gem's version
    -h, --help                       Show this message
```

### Generating the SkunkCore for your project

The SkunkCore is a sorted list of smelly files. Skunk's report will be in the console. On the Ruby project you want to analyze, run:

```
skunk
```

The result is a list of smelly files and the SkunkScore of the project/files:

```
+-----------------------------------------------------+----------------+------------------+--------------+--------------+--------------+
| file                                                | skunk_score    | churn_times_cost | churn        | cost         | coverage     |
+-----------------------------------------------------+----------------+------------------+--------------+--------------+--------------+
| samples/rubycritic/analysed_module.rb               | 258.88         | 12.94            | 5            | 2.59         | 0.0          |
| lib/skunk/commands/compare.rb                       | 85.41          | 32.32            | 14           | 2.31         | 63.64        |
| lib/skunk/rubycritic/analysed_modules_collection.rb | 31.76          | 3.18             | 5            | 0.64         | 50.0         |
| lib/skunk/commands/status_reporter.rb               | 11.33          | 68.0             | 18           | 3.78         | 97.5         |
| lib/skunk/command_factory.rb                        | 8.3            | 1.95             | 4            | 0.49         | 83.33        |
| lib/skunk/commands/status_sharer.rb                 | 8.17           | 10.9             | 4            | 2.72         | 97.67        |
| lib/skunk/cli/application.rb                        | 7.06           | 21.19            | 18           | 1.18         | 94.12        |
| lib/skunk/cli/options/argv.rb                       | 4.08           | 7.35             | 9            | 0.82         | 95.24        |
| lib/skunk/commands/compare_score.rb                 | 3.77           | 2.51             | 4            | 0.63         | 94.74        |
| lib/skunk/rubycritic/analysed_module.rb             | 3.37           | 33.74            | 10           | 3.37         | 100.0        |
| lib/skunk/commands/version.rb                       | 2.64           | 0.7              | 8            | 0.09         | 70.0         |
| lib/skunk/commands/output.rb                        | 1.86           | 0.09             | 1            | 0.09         | 80.0         |
| lib/skunk/cli/options.rb                            | 0.68           | 5.44             | 8            | 0.68         | 100.0        |
| lib/skunk/commands/default.rb                       | 0.4            | 3.23             | 8            | 0.4          | 100.0        |
| lib/skunk/commands/shareable.rb                     | 0.2            | 0.4              | 2            | 0.2          | 100.0        |
| lib/skunk/commands/help.rb                          | 0.2            | 1.2              | 6            | 0.2          | 100.0        |
| lib/skunk/commands/base.rb                          | 0.1            | 0.49             | 5            | 0.1          | 100.0        |
| lib/skunk.rb                                        | 0.0            | 0.0              | 6            | 0.0          | 100.0        |
| lib/skunk/version.rb                                | 0.0            | 0.0              | 12           | 0.0          | 0.0          |
+-----------------------------------------------------+----------------+------------------+--------------+--------------+--------------+

SkunkScore Total: 428.21
Modules Analysed: 19
SkunkScore Average: 22.54
Worst SkunkScore: 258.88 (samples/rubycritic/analysed_module.rb)
```

With the report, you can answer [these refactoring questions](#what-is-the-skunkscore) with clarity.

In this example, the file `samples/rubycritic/analysed_module.rb` has the Worst SkunkScore. It means this file has a high code complexity, with lower code coverage. To decrease its SkunkScore, start by adding tests to it. Then, simplify the code to decrease the code complexity.

Other great candidates are the files that have lower code coverage. By adding tests, their SkunkScore will decrease, and refactoring the code will be more achievable.

Skunk also gives you a SkunkScore Total value: it shows you the overall code quality of the project. As you decrease the SkunkScore of the files, the total score of the project will decrease.

#### Excluding folders from the report

To only run skunk on specific folders, pass a list of directories in the command line. For example, if you only want the report for the files under `app` and `lib`, run:

`skunk app lib`

### Generate JSON report in background

When the Skunk command is run, it will generate a JSON report file in the `RubyCritic::Config.root` location.

### Comparing feature branches

When working on new features, run skunk against your feature branch to check if the changes are improving or decreasing the code quality of the project.

To generate the SkunkScore of your feature branch, run:

```
skunk -b <your-feature-branch-name>
```

Then, get a SkunkScore average comparison with `main` by running:

`$ skunk -b main`

```
Switched to branch 'main'
....

Base branch (main) average skunk score: 290.53999999999996
Feature branch (feature/compare) average skunk score: 340.3005882352941
Score: 340.3
```

This should give you an idea if you're moving in the direction of maintaining the code quality or not. In this case, the feature branch is decreasing the code quality because it has a higher SkunkScore than the main branch.

## Configuration

### Setting Output Formats

Skunk provides a simple configuration class to control output formats programmatically. You can use `Skunk::Config` to set which formats should be generated when running Skunk.

**Supported formats:**
- `:json` - JSON report (default)
- `:html` - HTML report with visual charts and tables

```ruby
require 'skunk/config'

# Set multiple formats
Skunk::Config.formats = [:json, :html]

# Add a format to the existing list
Skunk::Config.add_format(:html)

# Remove a format
Skunk::Config.remove_format(:json)

# Check supported formats
Skunk::Config.supported_formats # => [:json, :html]
Skunk::Config.supported_format?(:json) # => true

# Reset to defaults
Skunk::Config.reset
```

## Sharing your SkunkScore

If you want to share the results of your Skunk report with the Ruby community, run:

`SHARE=true skunk app/`

```
SkunkScore Total: 126.99
Modules Analysed: 17
SkunkScore Average: 7.47
Worst SkunkScore: 41.92 (lib/skunk/commands/status_sharer.rb)

Generated with Skunk v0.5.0
Shared at: https://skunk.fastruby.io/
```

Results will be posted by default to https://skunk.fastruby.io which is a free and open source Ruby on Rails application sponsored by [OmbuLabs](https://www.ombulabs.com)([source code](https://github.com/fastruby/skunk.fyi)).

If you prefer to post results to your server, set your own `SHARE_URL`:

`$ SHARE_URL=https://path.to.your.skunk-fyi-server.example.com skunk app/`

```
SkunkScore Total: 126.99
Modules Analysed: 17
SkunkScore Average: 7.47
Worst SkunkScore: 41.92 (lib/skunk/commands/status_sharer.rb)

Generated with Skunk v0.5.0
Shared at: https://path.to.your.skunk-fyi-server.example.com
```

## Contributing
Have a fix for a problem you've been running into or an idea for a new feature you think would be useful? Want to see how you can support Skunk?

Take a look at the [Contributing document](CONTRIBUTING.md) for instructions to set up the repo on your machine, check the Help Wanted section, and create a good Pull Request.

## Sponsorship

![FastRuby.io | Rails Upgrade Services](fastruby-logo.png)

`skunk` is maintained and funded by [FastRuby.io](https://fastruby.io). The names and logos for FastRuby.io are trademarks of The Lean Software Boutique LLC.
