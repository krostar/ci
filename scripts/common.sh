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
    local -r binary="$1"
    local path

    path="$(project_path_root)/cmd"

    if ls -d "$(project_path_root)/cmd/*/" &> /dev/null; then
        path+="/$binary"
    fi

    echo "$path"
}

project_path_scripts() {
    echo "$(project_path_root)/scripts"
}

project_path_build_bin() {
    local -r project="$(project_name)"
    local -r binary="$1"
    local path

    path="$(project_path_root)/build/bin/$project"

    if [[ "$project" != "$binary" ]]; then
        path+="-$binary"
    fi

    echo "$path"
}

project_repo() {
    head -n1 "$(project_path_root)/go.mod" | cut -d' ' -f2
}

project_name() {
    basename "$(project_repo)"
}
