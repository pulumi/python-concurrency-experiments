#!/usr/bin/env bash

set -exuo pipefail

readonly PULUMI=/opt/homebrew/bin/pulumi
readonly PULUMI_DEV=/Users/robbiemckinstry/.pulumi-dev/bin/pulumi
readonly PROJECT_DIR="$1"

function build_python_runtime() {
    pushd $(pwd)
    cd ~/workspace/pulumi/pulumi/sdk/python
    make ensure && make build && make install
    popd
}

function checkout_master() {
    pushd $(pwd)
    cd ~/workspace/pulumi/pulumi
    git checkout master
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
  if [ "${PROJECT_DIR}" == "control" ]
  then
    PULUMI_EXEC="${PULUMI}"
    checkout_master
    build_python_runtime
  else
    PULUMI_EXEC="${PULUMI_DEV}"
    checkout_branch
    build_python_runtime
  fi
  pushd $(pwd)
  cd "${PROJECT_DIR}"
  $PULUMI_EXEC destroy --yes --non-interactive --stack=dev --skip-preview || true
  popd
}

main