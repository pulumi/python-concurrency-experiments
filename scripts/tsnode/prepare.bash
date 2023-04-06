#!/usr/bin/env bash

set -exuo pipefail

# Select the correct Pulumi binary.
readonly PULUMI_EXEC="${HOME}/.pulumi-dev/bin/pulumi"
readonly WORKSPACE="$1"
readonly GROUP="$2"
readonly RESOURCE_COUNT=1

# Make sure we're using the correct version of the NodeJS runtime.
function build_node_runtime() {
    pushd $(pwd)
    cd "${WORKSPACE}/sdk/nodejs"
    make ensure && make build && make install
    popd
}

function checkout_master() {
    pushd $(pwd)
    cd "${WORKSPACE}"
    git switch "origin/master" --detach
    make ensure && make build && make install
    popd
}

function checkout_slow() {
    pushd $(pwd)
    cd "${WORKSPACE}"
    git switch "origin/mckinstry/ts-node-expected-slow" --detach
    make ensure && make build && make install
    popd
}

function checkout_tsnode() {
    pushd $(pwd)
    cd "${WORKSPACE}"
    git switch "origin/mckinstry/perf-test-ts-node" --detach
    make ensure && make build && make install
    popd
}

function checkout_swc() {
    pushd $(pwd)
    cd "${WORKSPACE}"
    git switch "origin/mckinstry/swc-tsnode" --detach
    make ensure && make build && make install
    popd
}

function main {
  # PROJECT_DIR is the location of the source code.
  PROJECT_DIR="${EXPERIMENT}"
  # Ensure no variables from previous experiments are set.
  unset PULUMI_CONFIG_PASSPHRASE
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
    checkout_tsnode
  elif [ "${GROUP}" == "transpileOnly" ]
  then
    checkout_swc
  elif [ "${GROUP}" == "slow" ]
  then
    checkout_slow
  fi
    
  build_node_runtime

  # Now, step into the project folder and run the experiment.
  pushd $(pwd)
  cd "${PROJECT_DIR}"
  
  echo "Preparing ${GROUP}"

  # Link the newly build Pulumi SDK.
  yarn link "@pulumi/pulumi"

  # Login to the filestate backend.
  "${PULUMI_EXEC}" login --local

  # Create the stack if it does not exist.
  "${PULUMI_EXEC}" stack init --stack=dev --non-interactive || true

  # Set the resource count.
  "${PULUMI_EXEC}" config set --stack=dev ts-control:resource_count "${RESOURCE_COUNT}"

  # Destroy any resources from the last round of experiments.
  "${PULUMI_EXEC}" destroy --yes --non-interactive --stack=dev --skip-preview

  popd
}

main