#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o posix

# shellcheck disable=SC1090
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

test_go_deps() {
    go mod verify
}

test_go() {
    local -r timeout="${TEST_TIMEOUT:="1m"}"
    local -r coverdir="./build/cover"
    local -r coverprofile="${coverdir}/coverage.out"
    local -a opts=("$@")

    opts+=("-v")
    opts+=("-race")
    opts+=("-timeout=${timeout}")
    opts+=("-covermode=atomic")
    opts+=("-coverprofile=${coverprofile}")

    mkdir -p "$coverdir"
    CGO_ENABLED=1 go test "${opts[@]}" ./...
}

test() {
    local -r test_type="$1"

    echo "running ${test_type} tests ..."
    case "$test_type" in
    "go")
        test_go
        ;;
    "go-deps")
        test_go_deps
        ;;
    "go-fast")
        test_go -short
        ;;
    *)
        exit_error 2 "${test_type} is not a test type"
    ;;
    esac
    echo "${test_type} tests ran without errors"
}

test "$1"
