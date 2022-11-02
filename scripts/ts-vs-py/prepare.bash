#!/usr/bin/env bash

set -exuo pipefail

# Select the correct Pulumi binary.
readonly PULUMI_EXEC="${HOME}/.pulumi-dev/bin/pulumi"
readonly WORKSPACE="$HOME/workspace/pulumi/pulumi"
readonly GROUP="$1"

# Make sure we're using the correct version of the Python runtime.
function build_python_runtime() {
    pushd $(pwd)
    cd "${WORKSPACE}/sdk/python"
    make ensure && make build && make install
    popd
}

# Make sure we're using the correct version of the NodeJS runtime.
function build_node_runtime() {
    pushd $(pwd)
    cd "${WORKSPACE}/sdk/nodejs"
    make ensure && make build && make install
    popd
}

# Pulumi v3.43.1 contains the patched version of the Python runtime
# so the --parallel flag is honored.
function checkout_3-44-3() {
    pushd $(pwd)
    cd "${WORKSPACE}"
    git checkout v3.44.3
    make ensure && make build && make install
    popd
}

function main {
  # PROJECT_DIR is the location of the source code.
  PROJECT_DIR=""
  # Ensure no variables from previous experiments are set.
  unset PULUMI_CONFIG_PASSPHRASE
  unset PULUMI_EXPERIMENTAL
  unset PULUMI_SKIP_CHECKPOINTS
  unset PULUMI_OPTIMIZED_CHECKPOINT_PATCH

  # Control Group: Python.
  if [ "${GROUP}" == "control" ]
  then
    PROJECT_DIR="control"
    checkout_3-44-3
    build_python_runtime
    build_node_runtime
  # Variable Group: TypeScript
  elif [ "${GROUP}" == "ts-control" ]
  then
    PROJECT_DIR="ts-control"
    checkout_3-44-3
    build_python_runtime
    build_node_runtime
  fi

  # Now, step into the project folder and run the experiment.
  pushd $(pwd)
  cd "${PROJECT_DIR}"
  
  echo "Preparing ${GROUP}"

  # Destroy any resources from the last round of experiments.
  "${PULUMI_EXEC}" destroy --yes --non-interactive --stack=dev --skip-preview

  popd
}

main