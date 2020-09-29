# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] [(commits)](https://github.com/fastruby/skunk/compare/v0.4.2...HEAD)

* [FEATURE] Rename the tech debt metric: StinkScore => SkunkScore. It's a little friendlier.
* [FEATURE] Add `--out=file.txt` support to the command line (by [@manuca]())

## [0.4.2] [(commits)](https://github.com/fastruby/skunk/compare/v0.4.1...v0.4.2)
* [BUGFIX] Fixes table width issues by rounding values (by [@etagwerker][])

## [0.4.1] [(commits)](https://github.com/fastruby/skunk/compare/v0.4.0...v0.4.1)
* [BUGFIX] Fixes table width issues (by [@etagwerker][])

## [0.4.0] [(commits)](https://github.com/fastruby/skunk/compare/v0.3.2...v0.4.0)
* [FEATURE] Add `--version` support to the command line. (by [@bronzdoc][])
* [FEATURE] Stop accepting `-p <path>` in the command line. It's redundant and it's not working anyway. (by [@etagwerker][])
* [BUGFIX] Change "StinkScore" formula to skip `churn_times_cost` (by [@etagwerker][])
* [BUGFIX] Fixes #12 (by [@sebastian-palma][])

## [0.3.2] - 2019-11-23 [(commits)](https://github.com/fastruby/skunk/compare/v0.3.1...v0.3.2)
### Changed
* [BUGFIX] Change "StinkScore" formula to skip `churn_times_cost` (by [@etagwerker][])

## [0.3.1] - 2019-11-19 [(commits)](https://github.com/fastruby/skunk/compare/v0.3.0...v0.3.1)
### Changed
* [BUGFIX] Change "StinkScore" formula to skip `churn_times_cost` (by [@etagwerker][])

## [0.3.0] - 2019-11-19 [(commits)](https://github.com/fastruby/skunk/compare/v0.2.0...v0.3.0)
### Changed
* [FEATURE] Added Travis CI badge to README (by [@themayurkumbhar][])
* [FEATURE] Now you can compare "StinkScore" between branches (by [@etagwerker][])
* [BUGFIX] Add contributor covenant doc (by [@etagwerker][])
* [BUGFIX] Make sure tests work even you don't have a `coverage/.resultset.json` file (by [@etagwerker][])
* [BUGFIX] Make tests easier to maintain (by [@etagwerker][])

## [0.2.0] - 2019-10-16 [(commits)](https://github.com/fastruby/skunk/compare/v0.1.0...v0.2.0)
### Changed
- [FEATURE] Now `skunk` will not report status for files that start with `test/` or `spec/` (by [@etagwerker][])

## [0.1.0] - 2019-10-16
### Added
- [FEATURE] Now `skunk` uses `rubycritic-simplecov` to generate a console report with a list
of files and their "StinkScore" (by [@etagwerker][])
