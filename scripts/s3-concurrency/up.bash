#!/usr/bin/env bash

set -exuo pipefail

# Select the correct Pulumi binary.
readonly PULUMI_EXEC="${HOME}/.pulumi-dev/bin/pulumi"
readonly WORKSPACE="$1"
readonly GROUP="$2"

function run_project {
  # Ensure no variables from previous experiments are set.
  unset PULUMI_EXPERIMENTAL
  unset PULUMI_SKIP_CHECKPOINTS
  unset PULUMI_OPTIMIZED_CHECKPOINT_PATCH
  unset PULUMI_NODEJS_TRANSPILE_ONLY
  unset PULUMI_ACCESS_TOKEN

  unset CONCURRENCY_MULTIPLIER

  if [ "${GROUP}" == "experimental" ]
  then
    export CONCURRENCY_MULTIPLIER="1"
  elif [ "${GROUP}" == "2x" ]
  then
    export CONCURRENCY_MULTIPLIER="2"
  elif [ "${GROUP}" == "4x" ]
  then
    export CONCURRENCY_MULTIPLIER="4"
  elif [ "${GROUP}" == "8x" ]
  then
    export CONCURRENCY_MULTIPLIER="8"
  fi
  
  PROJECT_DIR="${EXPERIMENT}"

  pushd $(pwd)

  cd "${PROJECT_DIR}"
  echo "Collecting a sample for ${GROUP}."
  "${PULUMI_EXEC}" up --yes --non-interactive --stack=dev

  popd
}

function main {
  run_project
}

main