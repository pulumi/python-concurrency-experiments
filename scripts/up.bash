#!/usr/bin/env bash

set -exuo pipefail

readonly PULUMI=/opt/homebrew/bin/pulumi
readonly PULUMI_DEV=/Users/robbiemckinstry/.pulumi-dev/bin/pulumi
readonly GROUP="$1"

function run_project {
  PULUMI_EXEC=""
  PROJECT_DIR=""
  if [ "${GROUP}" == "control" ]
  then
    PROJECT_DIR="control"
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    PULUMI_EXEC="${PULUMI}"
  elif [ "${GROUP}" == "ts-control" ]
  then
    PROJECT_DIR="ts-control"
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    PULUMI_EXEC="${PULUMI}"
  elif [ "${GROUP}" == "patch" ]
  then
    PROJECT_DIR="control"
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    PULUMI_EXEC="${PULUMI_DEV}"
  elif [ "${GROUP}" == "checkpoint" ]
  then
    PROJECT_DIR="control"
    export PULUMI_EXPERIMENTAL="true"
    export PULUMI_SKIP_CHECKPOINTS="true"
    PULUMI_EXEC="${PULUMI_DEV}"
  elif [ "${GROUP}" == "jsonpatch" ]
  then
    PROJECT_DIR="control"
    export PULUMI_EXPERIMENTAL="true"
    unset PULUMI_SKIP_CHECKPOINTS
    export PULUMI_OPTIMIZED_CHECKPOINT_PATCH="true"
    PULUMI_EXEC="${PULUMI_DEV}"
  elif [ "${GROUP}" == "combined" ]
  then
    PROJECT_DIR="control"
    export PULUMI_EXPERIMENTAL="true"
    export PULUMI_SKIP_CHECKPOINTS="true"
    export PULUMI_OPTIMIZED_CHECKPOINT_PATCH="true"
    PULUMI_EXEC="${PULUMI_DEV}"
  fi

  pushd $(pwd)
  cd "${PROJECT_DIR}"
  $PULUMI_EXEC up --yes --non-interactive --stack=dev --skip-preview
  popd
}

function main {
  run_project
}

main