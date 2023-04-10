#!/usr/bin/env bash

set -exuo pipefail

# Select the correct Pulumi binary.
readonly PULUMI_EXEC="${HOME}/.pulumi-dev/bin/pulumi"
readonly WORKSPACE="$1"
readonly GROUP="$2"
readonly RESOURCE_COUNT="128"

function checkout_master() {
    pushd $(pwd)
    cd "${WORKSPACE}"
    git switch "origin/master" --detach
    make ensure && make build && make install
    popd
}

function checkout_concurrency() {
    pushd $(pwd)
    cd "${WORKSPACE}"
    git switch "origin/mckinstry/concurrency" --detach
    make ensure && make build && make install
    popd
}

function create_bucket() {
  aws s3 mb 's3://mckinstry-perf-testing'
  sleep 8
}

function delete_bucket() {
  aws s3 rb --force 's3://mckinstry-perf-testing' || true
}

function login_s3() {
  "${PULUMI_EXEC}" login 's3://mckinstry-perf-testing'
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
  unset CONCURRENCY_MULTIPLIER
  
  # Control Group: AWS Native on Master.
  if [ "${GROUP}" == "control" ]
  then
    checkout_master
  else
    checkout_concurrency
  fi

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
  
  echo "Preparing ${GROUP}"

  delete_bucket
  create_bucket
  login_s3

  yarn install

  # Create the stack if it does not exist.
  "${PULUMI_EXEC}" stack init --stack=dev --non-interactive || true

  # Set the resource count.
  "${PULUMI_EXEC}" config set --stack=dev s3-concurrency:resource_count "${RESOURCE_COUNT}"

  # Destroy any resources from the last round of experiments.
  "${PULUMI_EXEC}" destroy --yes --non-interactive --stack=dev --skip-preview

  popd
}

main