#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o posix

# shellcheck disable=SC1090
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

lint_dockerfile() {
    for file in ./**/*.Dockerfile; do
        hadolint "$file"
    done
}

lint_go() {
    go get
    CGO_ENABLED=0 golangci-lint run \
        --config "$(dirname "${BASH_SOURCE[0]}")/lint-go-config.yaml"
}

lint_markdown() {
    remark \
        --rc-path "$(dirname "${BASH_SOURCE[0]}")/lint-markdown.yaml" \
        --frail \
        .
}

lint_sh() {
    shellcheck \
        --check-sourced \
        --external-sources \
        --severity=info \
        --shell=bash \
        ./**/*.sh
}

lint_yaml() {
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
        lint_dockerfile
        ;;
    "go")
        lint_go
        ;;
    "markdown")
        lint_markdown
        ;;
    "sh")
        lint_sh
        ;;
    "yaml")
        lint_yaml
        ;;
    *)
        exit_error 2 "${lint_type} is not a lint type"
    ;;
    esac
    echo "${lint_type} linters ran without errors"
}

if [ $# -ne 1 ]; then
    echo "Usage: ./lint [type]"
    exit 42
fi

lint "$1"
