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

    echo "-X $(project_repo)/${package}.${key}=${value}"
}

build_ldflags() {
    local name="$1"
    local -r compress="$2"
    local -r pkg="internal/pkg/app"
    local -a ldflags

    if [[ "$name" != "$(project_name)" ]]; then
        name="$(project_name)_$name"
    fi

    if [ "$compress" -eq 1 ]; then
        ldflags+=("-w")
        ldflags+=("-s")
    fi

    ldflags+=("$(build_ldflags_xvar "$pkg" "name" "$name")")
    ldflags+=("$(build_ldflags_xvar "$pkg" "builtAtRaw" "$(date -u +'%Y-%m-%dT%H:%M:%SZ')")")
    ldflags+=("$(build_ldflags_xvar "$pkg" "version" "$(git describe --tags --always --dirty="-dev" 2>/dev/null || echo "0.0.0-0-gmaster")")")

    echo "${ldflags[*]}"
}

build_gcflags() {
    local -a gcflags
    gcflags+=("all=-nolocalimports")
    gcflags+=("-trimpath=$(project_path_root)")
    echo "${gcflags[*]}"
}

build_asmflags() {
    local -a asmflags
    asmflags+=("-trimpath=$(project_path_root)")
    echo "${asmflags[*]}"
}

build() {
    local -r project_to_build="$1"
    local -r project_to_build_path="$(project_path_cmd)/${project_to_build}"
    local -r compress="${BUILD_COMPRESS:-0}"

    # test if the project exists
    test -d "$project_to_build_path" || exit_error 1 "project '${project_to_build}' not found"

    if [ -x "$(project_path_scripts)/pre-build.sh" ]; then
        "$(project_path_scripts)/pre-build.sh"
    fi

    go generate ./...

    # build the binary
    GOROOT_FINAL="${BUILD_FINAL_TREE:-"$(go env GOROOT)"}"          \
    GOOS="${BUILD_FOR_OS:-"$(go env GOOS)"}"                        \
    GOARCH="${BUILD_FOR_ARCH:-"$(go env GOARCH)"}"                  \
    CGO_ENABLED="${BUILD_WITH_CGO:=0}"                              \
    go build -v -o "$(project_path_build_bin)/${project_to_build}"  \
        -ldflags="$(build_ldflags "$project_to_build" "$compress")" \
        -gcflags="$(build_gcflags)"                                 \
        -asmflags="$(build_asmflags)"                               \
        "$project_to_build_path"

    if [ "$compress" -eq 1 ]; then
        upx --brute "$(project_path_build_bin)/${project_to_build}"
    fi
}

# $1 is the project to build
if [ $# -ne 1 ]; then
    echo "Usage: ./build [project]"
    exit 42
fi

build "$1"
