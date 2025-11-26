# Bash release kit for Git

## Example workflow for GitHub Actions

```yaml
name: Bash Release

on:
  push:
    branches:
      - main

permissions:
  contents: write # This permits creating releases

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          submodules: recursive

      - name: Ejecutar Release Script
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }} # This token is needed to create releases
        run: ./.github/release-kit/release.sh
```
