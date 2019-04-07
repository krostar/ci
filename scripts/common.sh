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
    echo "/app"
}

project_path_cmd() {
    echo "$(project_path_root)/cmd"
}

project_path_scripts() {
    echo "$(project_path_root)/scripts"
}

project_path_build_bin() {
    echo "$(project_path_root)/build/bin"
}

project_repo() {
    head -n1 "$(project_path_root)/go.mod" | cut -d' ' -f2
}

project_name() {
    basename "$(project_repo)"
}
