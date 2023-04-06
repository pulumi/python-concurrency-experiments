#!/usr/bin/env bash

set -exuo pipefail

# Select the correct Pulumi binary.
readonly PULUMI_EXEC="${HOME}/.pulumi-dev/bin/pulumi"
readonly WORKSPACE="$1"
readonly GROUP="$2"
readonly RESOURCE_COUNT="$3"

function checkout_master() {
    pushd $(pwd)
    cd "${WORKSPACE}"
    git switch "origin/master" --detach
    make ensure && make build && make install
    popd
}

function main {
  # PROJECT_DIR is the location of the source code.
  PROJECT_DIR="${EXPERIMENT}"
  # Ensure no variables from previous experiments are set.
  unset PULUMI_EXPERIMENTAL
  unset PULUMI_SKIP_CHECKPOINTS
  unset PULUMI_OPTIMIZED_CHECKPOINT_PATCH
  unset PULUMI_NODEJS_TRANSPILE_ONLY
  unset PULUMI_ACCESS_TOKEN
  
  # Control Group: AWS Native on Master.
  if [ "${GROUP}" == "control" ]
  then
    checkout_master
  elif [ "${GROUP}" == "experimental" ]
  then
    # TODO: This needs to point to the correct branch.
    checkout_tsnode
  fi

  # Now, step into the project folder and run the experiment.
  pushd $(pwd)
  cd "${PROJECT_DIR}"
  
  echo "Preparing ${GROUP}"

  # Login to the filestate backend.
  # TODO: This needs to point to an S3 bucket.
  "${PULUMI_EXEC}" login --local

  # Create the stack if it does not exist.
  "${PULUMI_EXEC}" stack init --stack=dev --non-interactive || true

  # Set the resource count.
  "${PULUMI_EXEC}" config set --stack=dev s3-concurrency:resource_count "${RESOURCE_COUNT}"

  # Destroy any resources from the last round of experiments.
  "${PULUMI_EXEC}" destroy --yes --non-interactive --stack=dev --skip-preview

  popd
}

main