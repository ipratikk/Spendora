fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios lint

```sh
[bundle exec] fastlane ios lint
```

SwiftLint check

### ios ghc_scan_test

```sh
[bundle exec] fastlane ios ghc_scan_test
```

ghc scan test

### ios xcov_report

```sh
[bundle exec] fastlane ios xcov_report
```

xcov report

### ios build_for_test

```sh
[bundle exec] fastlane ios build_for_test
```

build for test

### ios test_without_build

```sh
[bundle exec] fastlane ios test_without_build
```

test without building

### ios get_simulator_app_file

```sh
[bundle exec] fastlane ios get_simulator_app_file
```

get app file for simulator

### ios generate_test_report

```sh
[bundle exec] fastlane ios generate_test_report
```

generate test coverage report

### ios carthage_cache_update

```sh
[bundle exec] fastlane ios carthage_cache_update
```

build dependencies missing a .version file or that where not found in the cache

### ios carthage_cache_bootstrap

```sh
[bundle exec] fastlane ios carthage_cache_bootstrap
```

build dependencies missing a .version file or that where not found in the cache

### ios current_swift_version

```sh
[bundle exec] fastlane ios current_swift_version
```

return current swift version

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
