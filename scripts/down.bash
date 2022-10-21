#!/usr/bin/env bash

# This script will destroy a Pulumi project and exit.
# 
# Usage:
# $1 is the path to the project directory
#
set -exuo pipefail

readonly PROJECT_DIR="$1"

function run_project {
  pulumi-dev destroy --yes  
}

function main {
  pushd $(pwd)
  cd "${PROJECT_DIR}"
  run_project
  popd
}

main