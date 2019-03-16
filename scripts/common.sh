#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o posix

exit_error() {
    if [ $# -eq 2 ]; then
        echo "$2"
    fi
    exit "$1"
}

project_path_root() {
    cd -P "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" || exit 255 && pwd
}

project_name() {
    basename "$(project_path_root)"
}
