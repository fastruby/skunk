# Contributing to Skunk
Have a fix for a problem you've been running into or an idea for a new feature you think would be useful? Bug reports and pull requests are welcome on GitHub at [https://github.com/fastruby/skunk](https://github.com/fastruby/skunk).

Here's what you need to do:

- Read and understand the [Code of Conduct](https://github.com/fastruby/skunk/blob/main/CODE_OF_CONDUCT.md).
- Fork this repo and clone your fork to somewhere on your machine.
- [Ensure that you have a working environment](#setting-up-your-environment)
- Read up on the [architecture of the gem](#architecture), and [run the tests](#running-all-tests).
- Cut a new branch and write a failing test for the feature or bug fix you plan on implementing.
- [Update the changelog when applicable](#a-word-on-the-changelog).
- Read the guidelines when [Releasing a new version](#releasing-a-new-version)
- Push to your fork and submit a pull request.
- [Make sure the test suite passes on GitHub Actions and make any necessary changes to your branch to bring it to green.](#continuous-integration).
- Check out the [Help Wanted](#help-wanted) section for suggestions on how to support Skunk.

## Requirements
For a Linux distro called Pop!_OS, running Ruby 3.0 and up might require installing the following packages:
```bash
sudo apt install libyaml-dev
```

## Setting up your environment
To install the dependencies, run:

```bash
bin/setup
```

You can also run `bin/console` for an interactive prompt that will allow you to experiment with the gem.

To install this gem onto your local machine, run:

`bundle exec rake install`.

## Architecture

This project follows the typical structure for a gem: code is located in `lib` and tests are in `test`.

Under `/lib/skunk`, you find the CLI commands. Under `lib/skunk/rubycritic` you find skunk's extension from `rubycritic` gem.

### Running all tests

To run all of the tests, simply run:

```bash
bundle exec rake
```

## A word on the changelog
You may also notice that we have a changelog in the form of [CHANGELOG.md](CHANGELOG.md). We use a format based on [Keep A Changelog](https://keepachangelog.com/en/1.0.0/).

The important things to keep in mind are:

- If your PR closes any open GitHub issue, make sure you include `Closes #XXXX` in your comment.
- New additions get added under the main (unreleased) heading;
- Attach a link to the PR with the following format:

* [<FEATURE | BUGFIX | CHORE>: Description of changes](github.com/link/to/pr).

## Releasing a new version
To release a new version, update the version number in `version.rb`.

To create a git tag for the version, push git commits and tags, and push the `.gem` file to rubygems.org, run:

`bundle exec rake release`

## When Submitting a Pull Request:
* If your PR closes any open GitHub issues, please include `Closes #XXXX` in your comment.
* Please include a summary of the change and which issue is fixed or which feature is introduced.
* If changes to the behavior are made, clearly describe what are the changes and why.
* If changes to the UI are made, please include screenshots of the before and after.

## Continuous integration
After opening your Pull Request, please make sure that all tests pass on the CI, to make sure your changes work in all possible environments. GitHub Actions will kick in after you push up a branch or open a PR.

If the build fails, click on a failed job and scroll through its output to verify what is the problem. Push your changes to your branch until the build is green.

## Help Wanted
Skunk's formula is not perfect and it is certainly controversial. The SkunkScore could be calculated per method. This would provide a more accurate representation of the average SkunkScore in a module.

The SkunkScore of a module should be the average of the SkunkScores of all of its methods. Right now the SkunkScore is calculated using the totals for a module:

- Total Code Coverage Percentage per Module
- Total Churn per Module
- Total Cost per Module

Feel free to review and submit your suggestions to improve the method [RubyCritic::AnalysedModule#skunk_score](https://github.com/fastruby/skunk/blob/main/lib/skunk/rubycritic/analysed_module.rb#L33).

📘 Read [Escaping The Tar Pit: Introducing Skunk v0.3.2 at RubyConf 2019](https://www.fastruby.io/blog/code-quality/escaping-the-tar-pit-at-rubyconf.html) and [Churn vs. Complexity vs. Code Coverage](https://www.fastruby.io/blog/code-quality/churn-vs-complexity-vs-coverage.html) for more details about the `skunk_score` method.
