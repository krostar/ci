#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set +o posix

# shellcheck disable=SC1090
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

lint::dockerfile() {
    for file in ./**/*.Dockerfile; do
        hadolint "$file"
    done
}

lint::go() {
    CGO_ENABLED=0 golangci-lint run \
        --config "$(dirname "${BASH_SOURCE[0]}")/lint-go-config.yaml"
}

lint::markdown() {
    remark \
        --rc-path "$(dirname "${BASH_SOURCE[0]}")/lint-markdown.yaml" \
        --frail \
        .
}

lint::sh() {
    shellcheck \
        --check-sourced \
        --external-sources \
        --severity=info \
        --shell=bash \
        ./**/*.sh
}

lint::yaml() {
    yamllint \
        --config-file "$(dirname "${BASH_SOURCE[0]}")/lint-yaml-config.yaml" \
        --strict \
        .
}

lint() {
    local -r lint_type="$1"

    echo "running ${lint_type} linters ..."
    case "$lint_type" in
    "dockerfile")
        lint::dockerfile
        ;;
    "go")
        lint::go
        ;;
    "markdown")
        lint::markdown
        ;;
    "sh")
        lint::sh
        ;;
    "yaml")
        lint::yaml
        ;;
    *)
        exit::error -1 "${lint_type} is not a lint type"
    ;;
    esac
    echo "${lint_type} linters ran without errors"
}

lint "$1"
