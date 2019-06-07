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
    local -a opts=("$@")
    local -r coverdir="./build/cover"
    local -r coverprofile="${coverdir}/coverage.out"

    opts+=("-v")
    opts+=("-race")
    opts+=("-covermode=atomic")
    opts+=("-coverprofile=${coverprofile}")

    mkdir -p "$coverdir"
    # cgo is enabled due to the race option
    CGO_ENABLED=1 go test "${opts[@]}" ./...
}

test() {
    local -r test_type="$1"
    local -a opts
    local cmd

    case "$test_type" in
    "go")
        opts+=("--timeout=${TEST_TIMEOUT:="1m"}")
        if [ -n "${TEST_RUN:=""}" ]; then
            opts+=("-run=${TEST_RUN}")
        fi
        if [ -n "${TEST_SHORT:=""}" ]; then
            opts+=("-short")
        fi
        cmd="test_go"
        ;;
    "go-deps")
        cmd="test_go_deps"
        ;;
    *)
        exit_error 2 "${test_type} is not a test type"
    ;;
    esac

    echo "running ${test_type} tests ..."
    $cmd "${opts[@]}"
    echo "${test_type} tests ran without errors"
}

if [ $# -ne 1 ]; then
    echo "Usage: ./test [type]"
    exit 42
fi

test "$1"
