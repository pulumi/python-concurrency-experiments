#!/usr/bin/env bash

set -exuo pipefail

readonly PULUMI=/opt/homebrew/bin/pulumi
readonly PULUMI_DEV=/Users/robbiemckinstry/.pulumi-dev/bin/pulumi
readonly GROUP="$1"
readonly TERRAFORM=/opt/homebrew/bin/terraform
readonly DEFAULT_PARALLELISM=214783647

function build_python_runtime() {
    pushd $(pwd)
    cd ~/workspace/pulumi/pulumi/sdk/python
    make ensure && make build && make install
    popd
}

function checkout_latest() {
    pushd $(pwd)
    cd ~/workspace/pulumi/pulumi
    git checkout v3.43.1
    make ensure && make build && make install
    popd
}

function checkout_branch() {
    pushd $(pwd)
    cd ~/workspace/pulumi/pulumi
    git checkout mckinstry/python-concurrency
    make ensure && make build && make install
    popd
}

function main {
  PULUMI_EXEC=""
  PROJECT_DIR=""
  if [ "${GROUP}" == "control" ]
  then
    PROJECT_DIR="control"
    unset PULUMI_CONFIG_PASSPHRASE
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    PULUMI_EXEC="${PULUMI}"
    checkout_latest
    build_python_runtime
  elif [ "${GROUP}" == "ts-control" ]
  then
    PROJECT_DIR="ts-control"
    unset PULUMI_CONFIG_PASSPHRASE
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    PULUMI_EXEC="${PULUMI}"
    checkout_latest
    build_python_runtime
  elif [ "${GROUP}" == "patch" ]
  then
    PROJECT_DIR="control"
    unset PULUMI_CONFIG_PASSPHRASE
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    PULUMI_EXEC="${PULUMI_DEV}"
    checkout_branch
    build_python_runtime
  elif [ "${GROUP}" == "checkpoint" ]
  then
    PROJECT_DIR="control"
    unset PULUMI_CONFIG_PASSPHRASE
    export PULUMI_EXPERIMENTAL="true"
    export PULUMI_SKIP_CHECKPOINTS="true"
    PULUMI_EXEC="${PULUMI_DEV}"
    checkout_branch
    build_python_runtime
  elif [ "${GROUP}" == "jsonpatch" ]
  then
    PROJECT_DIR="control"
    unset PULUMI_CONFIG_PASSPHRASE
    export PULUMI_EXPERIMENTAL="true"
    unset PULUMI_SKIP_CHECKPOINTS
    export PULUMI_OPTIMIZED_CHECKPOINT_PATCH="true"
    PULUMI_EXEC="${PULUMI_DEV}"
    checkout_branch
    build_python_runtime
  elif [ "${GROUP}" == "combined" ]
  then
    PROJECT_DIR="control"
    unset PULUMI_CONFIG_PASSPHRASE
    export PULUMI_EXPERIMENTAL="true"
    export PULUMI_SKIP_CHECKPOINTS="true"
    export PULUMI_OPTIMIZED_CHECKPOINT_PATCH="true"
    PULUMI_EXEC="${PULUMI_DEV}"
    checkout_branch
    build_python_runtime
  elif [ "${GROUP}" == "pulumi-file" ]
  then
    PROJECT_DIR="pulumi-file"
    export PULUMI_CONFIG_PASSPHRASE=""
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    unset PULUMI_OPTIMIZED_CHECKPOINT_PATCH
    PULUMI_EXEC="${PULUMI_DEV}"
    checkout_branch
    build_python_runtime
  elif [ "${GROUP}" == "pulumi-s3" ]
  then
    PROJECT_DIR="pulumi-file"
    export PULUMI_CONFIG_PASSPHRASE=""
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    unset PULUMI_OPTIMIZED_CHECKPOINT_PATCH
    PULUMI_EXEC="${PULUMI_DEV}"
    checkout_branch
    build_python_runtime
  elif [ "${GROUP}" == "terraform-remote" ]
  then
    PROJECT_DIR="terraform-remote"
    unset PULUMI_CONFIG_PASSPHRASE
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    unset PULUMI_OPTIMIZED_CHECKPOINT_PATCH
    PULUMI_EXEC=""
  elif [ "${GROUP}" == "terraform-cloud" ]
  then
    PROJECT_DIR="terraform-cloud"
    unset PULUMI_CONFIG_PASSPHRASE
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    unset PULUMI_OPTIMIZED_CHECKPOINT_PATCH
    PULUMI_EXEC=""
  elif [ "${GROUP}" == "terraform-file" ]
  then
    PROJECT_DIR="terraform-file"
    unset PULUMI_CONFIG_PASSPHRASE
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    unset PULUMI_OPTIMIZED_CHECKPOINT_PATCH
    PULUMI_EXEC=""
  fi

  pushd $(pwd)
  cd "${PROJECT_DIR}"
  if [ "${GROUP}" == "terraform-remote" ]
  then
    $TERRAFORM destroy -auto-approve -parallelism="${DEFAULT_PARALLELISM}"
  elif [ "${GROUP}" == "terraform-cloud" ]
  then
    $TERRAFORM destroy -auto-approve -parallelism="${DEFAULT_PARALLELISM}"
  elif [ "${GROUP}" == "terraform-file" ]
  then
    $TERRAFORM destroy -auto-approve -parallelism="${DEFAULT_PARALLELISM}"
  elif [ "${GROUP}" == "terraform-s3" ]
  then
    $TERRAFORM destroy -auto-approve -parallelism="${DEFAULT_PARALLELISM}"
  else
    $PULUMI_EXEC destroy --yes --non-interactive --stack=dev --skip-preview || true
  fi
  popd
}

main