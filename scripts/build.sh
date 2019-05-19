#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o posix

# shellcheck disable=SC1090
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

build_ldflags_xvar() {
    local -r package="$1"
    local -r key="$2"
    local -r value="$3"

    echo "-X \"$(project_repo)/${package}.${key}=${value}\""
}

build_ldflags() {
    local name="$1"
    local -r pkg="internal/pkg/app"
    local -a xflags

    if [[ "$name" != "$(project_name)" ]]; then
        name="$(project_name)_$name"
    fi

    xflags+=("$(build_ldflags_xvar "$pkg" "name" "$name")")
    xflags+=("$(build_ldflags_xvar "$pkg" "builtAtRaw" "$(date -u +'%Y-%m-%dT%H:%M:%SZ')")")
    xflags+=("$(build_ldflags_xvar "$pkg" "version" "$(git describe --tags --always --dirty="-dev" 2>/dev/null || echo "0.0.0-0-gmaster")")")

   echo "$(IFS=' ' ; echo "${xflags[*]}")"
}

build() {
    local -r project_to_build="$1"
    local -r project_to_build_path="$(project_path_cmd)/${project_to_build}"

    # test if the project exists
    test -d "$project_to_build_path" || exit_error 1 "project '${project_to_build}' not found"

    if [ -x "$(project_path_scripts)/pre-build.sh" ]; then
        "$(project_path_scripts)/pre-build.sh"
    fi

    go generate ./...

    # build the binary
    GOOS="${BUILD_FOR_OS:-$(go env GOOS)}" GOARCH="${BUILD_FOR_ARCH:-$(go env GOARCH)}" CGO_ENABLED=0 \
    go build -v \
        -o "$(project_path_build_bin)/${project_to_build}" \
        -ldflags="-s -w $(build_ldflags "$project_to_build")" \
        "$project_to_build_path"

    if [ "${BUILD_COMPRESS:-0}" -eq 1 ]; then
        upx --brute "$(project_path_build_bin)/${project_to_build}"
    fi
}

# $1 is the project to build
build "$1"
