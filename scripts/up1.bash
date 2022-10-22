#!/usr/bin/env bash

set -exuo pipefail

readonly PULUMI=/opt/homebrew/bin/pulumi
readonly PULUMI_DEV=/Users/robbiemckinstry/.pulumi-dev/bin/pulumi
readonly PROJECT_DIR="$1"

function run_project {
  local PULUMI_EXEC=""
  if [ "${PROJECT_DIR}" == "control" ]
  then
    PULUMI_EXEC="${PULUMI}"
  elif ["${PROJECT_DIR}" == "ts-control" ]
  then
    PULUMI_EXEC="${PULUMI}"
  else
    PULUMI_EXEC="${PULUMI_DEV}"
  fi
  $PULUMI_EXEC up --yes --non-interactive --stack=dev --skip-preview
}

function main {
  pushd $(pwd)
  cd "${PROJECT_DIR}"
  run_project
  popd
}

main