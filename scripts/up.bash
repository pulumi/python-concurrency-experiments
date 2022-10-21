#!/usr/bin/env bash

set -exuo pipefail

readonly PULUMI=/opt/homebrew/bin/pulumi
readonly PULUMI_DEV=/Users/robbiemckinstry/.pulumi-dev/bin/pulumi
readonly PROJECT_DIR="$1"
# readonly PULUMI_HOME_CONTROL=/Users/robbiemckinstry/.pulumi/
# readonly PULUMI_HOME_DEV=/Users/robbiemckinstry/.pulumi-dev/

function run_project {
  local PULUMI_EXEC=""
  if [ "${PROJECT_DIR}" == "control" ]
  then
    PULUMI_EXEC="${PULUMI}"
    # export PULUMI_HOME="${PULUMI_HOME_CONTROL}"
  else
    PULUMI_EXEC="${PULUMI_DEV}"
    # export PULUMI_HOME="${PULUMI_HOME_DEV}"
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