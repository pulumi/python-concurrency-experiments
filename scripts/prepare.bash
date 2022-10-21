#!/usr/bin/env bash

set -exuo pipefail

readonly PULUMI=/opt/homebrew/bin/pulumi
readonly PULUMI_DEV=/Users/robbiemckinstry/.pulumi-dev/bin/pulumi
readonly PROJECT_DIR="$1"

function main {
  pushd $(pwd)
  cd "${PROJECT_DIR}"
  $PULUMI destroy --yes --skip-preview || true
  popd
}

main