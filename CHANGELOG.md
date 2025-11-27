# v1.1.0 (2025-11-27)

### Features

- added github_token to GH_TOKEN too
- github releases for git floating tags
- floating tags functionality added

### Bug Fixes

- loop prevention from own commits

# v1.0.1 (2025-11-27)

### Bug Fixes

- args warning for setup_git_user detected by shellcheck

# v1.0.0 (2025-11-27)

### ⚠ BREAKING CHANGES

- strip BREAKING CHANGE: from commits in changelog

### Features

- added version message at start
- now you can update version of target files
- changelog config implementation with output and enable
- custom commit types on config file are available now
- define commit types config on json $schema
- add gh action metadata
- github releases
- simple release tool beta

### Bug Fixes

- command execution, writing files and acces to not authorized paths (outside of repo) by sed was patched
- erase extra log on gh release creation
- update github.active path to github.enable in config
- strip BREAKING CHANGE: from commits in changelog
- strip commit prefix in changelog
- remove trailing backslash in gh release func
- give release.sh +x rights
