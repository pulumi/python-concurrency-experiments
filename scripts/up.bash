#!/usr/bin/env bash

set -exuo pipefail

readonly PULUMI=/opt/homebrew/bin/pulumi
readonly PULUMI_DEV=/Users/robbiemckinstry/.pulumi-dev/bin/pulumi
readonly PROJECT_DIR="$1"

function run_project {
  $PULUMI up --yes --skip-preview
}

function main {
  pushd $(pwd)
  cd "${PROJECT_DIR}"
  run_project
  popd
}

main