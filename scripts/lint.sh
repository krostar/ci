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
    local config_file
    if [ -f "$(project_path_root)/.lint-go.yaml" ]; then
        config_file="$(project_path_root)/.lint-go.yaml"
    else
        config_file="$(dirname "${BASH_SOURCE[0]}")/lint-go-config.yaml"
    fi

    go mod download
    CGO_ENABLED=0 GOGC=50 golangci-lint run \
        --timeout "5m"              \
        --config "$config_file"
}

lint_markdown() {
    local config_file
    if [ -f "$(project_path_root)/.lint-markdown.yaml" ]; then
        config_file="$(project_path_root)/.lint-markdown.yaml"
    else
        config_file="$(dirname "${BASH_SOURCE[0]}")/lint-markdown-config.yaml"
    fi

    remark \
        --rc-path "$config_file" \
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
    local config_file
    if [ -f "$(project_path_root)/.lint-yaml.yaml" ]; then
        config_file="$(project_path_root)/.lint-yaml.yaml"
    else
        config_file="$(dirname "${BASH_SOURCE[0]}")/lint-yaml-config.yaml"
    fi

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
