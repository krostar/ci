#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set +o posix

exit::error() {
    if [ $# -eq 2 ]; then
        echo "$2"
    fi
    exit "$1"
}

project::path::root() {
    cd -P "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" || exit 255 && pwd
}

project::name() {
    basename "$(project::path::root)"
}
