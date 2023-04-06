#!/usr/bin/env bash

set -exuo pipefail

# Select the correct Pulumi binary.
PULUMI_EXEC="${HOME}/.pulumi-dev/bin/pulumi"
readonly WORKSPACE="$1"
readonly GROUP="$2"

function delete_bucket() {
  aws s3 rb --force 's3://mckinstry-perf-testing' || true
}

function logout() {
  "${PULUMI_EXEC}" logout
}

function main {
  # PROJECT_DIR is the location of the source code.
  PROJECT_DIR="${EXPERIMENT}"
  # Ensure no variables from previous experiments are set.
  unset PULUMI_EXPERIMENTAL
  unset PULUMI_SKIP_CHECKPOINTS
  unset PULUMI_OPTIMIZED_CHECKPOINT_PATCH
  unset PULUMI_NODEJS_TRANSPILE_ONLY

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

  # Now, step into the project folder and run the experiment.
  pushd $(pwd)
  cd "${PROJECT_DIR}"

  # Destroy any resources from the last round of experiments.
  "${PULUMI_EXEC}" destroy --yes --non-interactive --stack=dev --skip-preview
  
  delete_bucket

  logout

  popd
}

main