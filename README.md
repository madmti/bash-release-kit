# Bash Release Kit

A zero-dependency, pure Bash release automation tool for Git repositories. It analyzes commit history based on commit messages, creates Git tags, generates Changelogs, publishes GitHub releases, and updates version numbers in specified files (npm, python, text, etc).

Designed to be **lightweight and fast**, running natively on GitHub Actions without the need for Node.js, Python, or Docker containers.

## Quick Start (GitHub Action)

The easiest way to use this tool is as a GitHub Action step.

### Create the Workflow

Create a file at `.github/workflows/release.yml`:

```yaml
name: Release

on:
  push:
    branches:
      - main

permissions:
  contents: write # Required to create tags and releases

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0 # Important: Required to calculate version history

      - name: Semantic Release
        uses: madmti/release-kit@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          # Optional (Default: release-config.json)
          # config_file: 'release-config.json'
```

That's it\! On every push to the `main` branch, the action will analyze commit messages, create a new Git tag, and publish a GitHub release.

-----

## Configuration

The release kit uses a configuration file to define version update behavior and other settings. By default, it looks for `release-config.json` in the repository root.

### Enable IntelliSense (Recommended)

Add the `$schema` property to your JSON file to get autocompletion and validation in VS Code.

```json
{
  "$schema": "https://raw.githubusercontent.com/madmti/release-kit/main/release-schema.json",
  "github": {
    "enable": true
  }
}
```

### 1\. Changelog Configuration

Control if and where the local Changelog file is generated.

```json
"changelog": {
  "enable": true,            // Default: true
  "output": "HISTORY.md"     // Default: "CHANGELOG.md"
}
```

### 2\. File Updaters (Targets)

Automatically update version numbers in your source code.

Supported types: `npm` (or `json`), `python`, `text`, `custom-regex`.

```json
"targets": [
  {
    "path": "package.json",
    "type": "npm"
  },
  {
    "path": "src/version.txt",
    "type": "text"
  },
  {
    "path": "src/app/__init__.py",
    "type": "python"
  },
  {
    "path": "src/config.h",
    "type": "custom-regex",
    "pattern": "s/^#define VERSION .*/#define VERSION \"%VERSION%\"/"
  }
]
```

**Note on `custom-regex`:**

  * Use standard `sed` substitution syntax: `s/find/replace/`.
  * Use `%VERSION%` as a placeholder for the new version number.
  * **Security:** The tool blocks regex patterns containing `e` (execute) or `w` (write) flags to prevent code injection.

### 3\. Custom Commit Types

Customize how different commit types affect the versioning and the Changelog sections.

```json
"commitTypes": [
  {
    "type": "feat",
    "section": "New Features",
    "bump": "minor"
  },
  {
    "type": "fix",
    "section": "Bug Fixes",
    "bump": "patch"
  },
  {
    "type": "docs",
    "section": "Documentation",
    "bump": "none",
    "hidden": true
  },
  {
    "type": "perf",
    "section": "Performance",
    "bump": "patch",
    "hidden": false
  }
]
```

  * **bump**: `major`, `minor`, `patch`, or `none`.
  * **hidden**: If `true`, these commits won't appear in the Changelog.

-----

## Versioning Rules

This tool follows [Semantic Versioning](https://semver.org/) rules based on [Conventional Commits](https://www.conventionalcommits.org/).

| Commit Message | Release Type | Example |
| :--- | :--- | :--- |
| `fix: ...` | **Patch** (`1.0.0` -\> `1.0.1`) | `fix: prevent null pointer exception` |
| `feat: ...` | **Minor** (`1.0.0` -\> `1.1.0`) | `feat: add new login button` |
| `feat!: ...` | **Major** (`1.0.0` -\> `2.0.0`) | `feat!: drop support for Node 12` |
| `BREAKING CHANGE:` | **Major** (`1.0.0` -\> `2.0.0`) | (Footer) `BREAKING CHANGE: API removed` |

> **Note:** Priority is hierarchical. A single `MAJOR` commit overrides any number of `MINOR` or `PATCH` commits.

-----

## Inputs

| Input | Description | Required | Default |
| :--- | :--- | :--- | :--- |
| `github_token` | The `GITHUB_TOKEN` secret to create releases via GitHub CLI. | **Yes** | N/A |
| `config_file` | Path to the JSON configuration file. | No | `release-config.json` |
