#!/usr/bin/env bash

check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        log_fatal "GitHub CLI (gh) is not installed. Please install it to proceed."
    fi
}

create_gh_release() {
    local tag="$1"
    local notes="$2"

    if [ -z "$notes" ]; then
            notes="Automated release $tag"
    fi

    log_info "Creating GitHub release for tag $tag"
    gh release create "$tag" \
        --title "$tag" \
        --notes "$notes"
}
