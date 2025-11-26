# Bash Release Kit

A zero-dependency, pure Bash release automation tool for Git repositories. It analyzes commit history based on commit messages, creates Git tags, GitHub releases, and can update version numbers in specified files.

Designed to be lightweight and fast, running natively on GitHub Actions without the need for Node.js, Python, or Docker containers.

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

That's it! On every push to the `main` branch, the action will analyze commit messages, create a new Git tag, and publish a GitHub release if applicable.
