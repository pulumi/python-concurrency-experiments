#!/usr/bin/env bash

set -exuo pipefail

readonly PULUMI=/opt/homebrew/bin/pulumi
readonly PULUMI_DEV=/Users/robbiemckinstry/.pulumi-dev/bin/pulumi
readonly GROUP="$1"
readonly PARALLELISM="$2"
readonly TERRAFORM=/opt/homebrew/bin/terraform

function build_python_runtime() {
    pushd $(pwd)
    cd ~/workspace/pulumi/pulumi/sdk/python
    make ensure && make build && make install
    popd
}

function checkout_3_44() {
    pushd $(pwd)
    cd ~/workspace/pulumi/pulumi
    git checkout v3.44.0
    make ensure && make build && make install
    popd
}

function main {
  PULUMI_EXEC=""
  PROJECT_DIR=""
  if [ "${GROUP}" == "cli" ]
  then
    PROJECT_DIR="control"
    unset PULUMI_CONFIG_PASSPHRASE
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    PULUMI_EXEC="${PULUMI_DEV}"
    checkout_3_44
    build_python_runtime
  elif [ "${GROUP}" == "automation" ]
  then
    PROJECT_DIR="automation"
    unset PULUMI_CONFIG_PASSPHRASE
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    PULUMI_EXEC="${PULUMI_DEV}"
    checkout_3_44
    build_python_runtime
  fi

  pushd $(pwd)
  cd "${PROJECT_DIR}"
  if [ "${GROUP}" == "terraform-remote" ]
  then
    $TERRAFORM destroy -auto-approve
  elif [ "${GROUP}" == "terraform-cloud" ]
  then
    $TERRAFORM destroy -auto-approve
  elif [ "${GROUP}" == "terraform-file" ]
  then
    $TERRAFORM destroy -auto-approve
  elif [ "${GROUP}" == "automation" ]
  then
    python3 __main__.py --parallelism="${PARALLELISM}" --destroy
  else
    $PULUMI_EXEC destroy --yes --non-interactive --stack=dev --skip-preview || true
  fi  
  
  popd
}

main