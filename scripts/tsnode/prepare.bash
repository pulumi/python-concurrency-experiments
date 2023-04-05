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
    git checkout "master"
    make ensure && make build && make install
    popd
}

function checkout_slow() {
    pushd $(pwd)
    cd "${WORKSPACE}"
    git checkout "mckinstry/ts-node-expected-slow"
    make ensure && make build && make install
    popd
}

function checkout_tsnode() {
    pushd $(pwd)
    cd "${WORKSPACE}"
    git checkout "mckinstry/perf-test-ts-node"
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
  
  # Control Group: AWS Native on Master.
  if [ "${GROUP}" == "control" ]
  then
    checkout_master
  elif [ "${GROUP}" == "experimental" ]
  then
    checkout_tsnode
  elif [ "${GROUP}" == "slow" ]
  then
    checkout_slow
  fi
    
  build_node_runtime

  # Now, step into the project folder and run the experiment.
  pushd $(pwd)
  cd "${PROJECT_DIR}"
  
  echo "Preparing ${GROUP}"

  # Set the resource count.
  "${PULUMI_EXEC}" config set ts-control:resource_count "${RESOURCE_COUNT}"

  # Destroy any resources from the last round of experiments.
  "${PULUMI_EXEC}" destroy --yes --non-interactive --stack=dev --skip-preview

  popd
}

main