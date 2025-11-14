# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## main [(unreleased)](https://github.com/fastruby/skunk/compare/v0.5.4...HEAD)

* [FEATURE: Add `--formats` CLI flag to select report formats (json, html, console)]
* [REFACTOR: Move Console Report](https://github.com/fastruby/skunk/pull/128)
* [BUGFIX: Set the right content type in the share HTTP request](https://github.com/fastruby/skunk/pull/129)
* [REFACTOR: Centralize Skunk analysis into RubyCritic module](https://github.com/fastruby/skunk/pull/127)
* [FEATURE: Add Skunk HTML Report](https://github.com/fastruby/skunk/pull/123)
* [FEATURE: Add Skunk::Config class](https://github.com/fastruby/skunk/pull/123)
* [FEATURE: Add Ruby 3.4 compatibility](https://github.com/fastruby/skunk/pull/124)

## v0.5.4 / 2025-05-05 [(commits)](https://github.com/fastruby/skunk/compare/v0.5.3...v0.5.4)

* [FEATURE: Generate JSON report in background](https://github.com/fastruby/skunk/pull/119)
* [ENHANCEMENT: Better test suite with more relaxed console output expectation](https://github.com/fastruby/skunk/pull/117)
* [ENHANCEMENT: Use minitest 5.22.x (also, stop testing with Ruby 2.4 and 2.5)](https://github.com/fastruby/skunk/pull/115)

## v0.5.3 / 2023-12-01 [(commits)](https://github.com/fastruby/skunk/compare/v0.5.2...v0.5.3)

* [BUGFIX: Update reek, rubocop, and terminal-table dependencies](https://github.com/fastruby/skunk/pull/111)
* [BUGFIX: Better test coverage tracking for skunk](https://github.com/fastruby/skunk/pull/108)
* [FEATURE: Add Ruby 3.2 Support](https://github.com/fastruby/skunk/pull/106)
* [BUGFIX: Fix skunk workflow](https://github.com/fastruby/skunk/pull/104)
* [BUGFIX: Fix documentation and refactor `skunk_score` method](https://github.com/fastruby/skunk/pull/102)
* [FEATURE: Improve main workflow](https://github.com/fastruby/skunk/pull/99)
* [BUGFIX: Fix analized module test](https://github.com/fastruby/skunk/pull/98)

## v0.5.2 / 2022-04-27 [(commits)](https://github.com/fastruby/skunk/compare/v0.5.1...v0.5.2)

* [FEATURE: Support more rubies](https://github.com/fastruby/skunk/pull/92)
* [BUGFIX: Fixed share issue with version command](https://github.com/fastruby/skunk/pull/83)
* [FEATURE: Add PR Template](https://github.com/fastruby/skunk/pull/72)
* [BUGFIX: Fix Sponsorship logo path in README](https://github.com/fastruby/skunk/pull/73)
* [BUGFIX: Test with Ruby 3.1](https://github.com/fastruby/skunk/pull/85)
* [BUGFIX: Fix changelog uri](https://github.com/fastruby/skunk/pull/90)

## v0.5.1 / 2021-02-17 [(commits)](https://github.com/fastruby/skunk/compare/v0.5.0...v0.5.1)

* [BUGFIX: Fix bug related to compare plus share code](https://github.com/fastruby/skunk/pull/69)

## v0.5.0 / 2020-09-18 [(commits)](https://github.com/fastruby/skunk/compare/v0.4.2...v0.5.0)

* [FEATURE: Share your results using an environment variable](https://github.com/fastruby/skunk/pull/56)
* [FEATURE: Rename the tech debt metric: StinkScore => SkunkScore. It's a little friendlier.](https://github.com/fastruby/skunk/pull/36)
* [FEATURE: Add `--out=file.txt` support to the command line](https://github.com/fastruby/skunk/pull/47)
* [BUGFIX: Skip both nested and top level spec and test folders](https://github.com/fastruby/skunk/pull/65)

## v0.4.2 / 2020-02-09 [(commits)](https://github.com/fastruby/skunk/compare/v0.4.1...v0.4.2)

* [BUGFIX: Fixes table width issues by rounding values](https://github.com/fastruby/skunk/commit/80e2e4743bcb79619f9bb5aed9808bac1ca78231)

## v0.4.1 / 2020-02-09 [(commits)](https://github.com/fastruby/skunk/compare/v0.4.0...v0.4.1)

* [BUGFIX: Fixes table width issues](https://github.com/fastruby/skunk/commit/372bc506f408e3647ce48b7bc149234c9da71168)

## v0.4.0 / 2020-02-08 [(commits)](https://github.com/fastruby/skunk/compare/v0.3.2...v0.4.0)

* [FEATURE: Add `--version` support to the command line.](https://github.com/fastruby/skunk/pull/18)
* [FEATURE: Stop accepting `-p <path>` in the command line. It's redundant and it's not working anyway.](https://github.com/fastruby/skunk/commit/40976c65a1176b47d3b67f75cd7b4ec92d7c4c88)
* [BUGFIX: Create compare_root_directory when it does not exist](https://github.com/fastruby/skunk/pull/23) (#12)

## v0.3.2 / 2019-11-23 [(commits)](https://github.com/fastruby/skunk/compare/v0.3.1...v0.3.2)

* [BUGFIX: Make variable binding friendly to avoid warning](https://github.com/fastruby/skunk/pull/20)

## v0.3.1 / 2019-11-19 [(commits)](https://github.com/fastruby/skunk/compare/v0.3.0...v0.3.1)

* [BUGFIX: Change "StinkScore" formula to skip `churn_times_cost`](https://github.com/fastruby/skunk/pull/14)

## v0.3.0 / 2019-11-19 [(commits)](https://github.com/fastruby/skunk/compare/v0.2.0...v0.3.0)

* [FEATURE: Added Travis CI badge to README](https://github.com/fastruby/skunk/pull/3)
* [FEATURE: Now you can compare "StinkScore" between branches](https://github.com/fastruby/skunk/pull/11)
* [BUGFIX Add contributor covenant doc](https://github.com/fastruby/skunk/commit/c765a6406f0d53043e8d1c51309d6372196e9f94)
* [BUGFIX Make sure tests work even you don't have a `coverage/.resultset.json` file](https://github.com/fastruby/skunk/pull/7)
* [BUGFIX: Make tests easier to maintain](https://github.com/fastruby/skunk/pull/10)

## v0.2.0 / 2019-10-16 [(commits)](https://github.com/fastruby/skunk/compare/v0.1.0...v0.2.0)

* [FEATURE: Now `skunk` will not report status for files that start with `test/` or `spec/`](https://github.com/fastruby/skunk/commit/6f1a3c60967abb114576e71084d80e12b0f0235f) (by

## v0.1.0 / 2019-10-16

* [FEATURE: Now `skunk` uses `rubycritic-simplecov` to generate a console report with a list of files and their "StinkScore"](https://github.com/fastruby/skunk/commit/2ccc5b885b5e12135d963e779566d27d6eefa140)
