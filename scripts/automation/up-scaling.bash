#!/usr/bin/env bash

set -exuo pipefail

readonly PULUMI=/opt/homebrew/bin/pulumi
readonly PULUMI_DEV=/Users/robbiemckinstry/.pulumi-dev/bin/pulumi
readonly TERRAFORM=/opt/homebrew/bin/terraform
readonly GROUP="$1"
readonly PARALLELISM="$2"
readonly DEFAULT_PARALLELISM="2147483647"

function run_project {
  PULUMI_EXEC=""
  PROJECT_DIR=""
  if [ "${GROUP}" == "cli" ]
  then
    PROJECT_DIR="control"
    unset PULUMI_CONFIG_PASSPHRASE
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    PULUMI_EXEC="${PULUMI}"
  elif [ "${GROUP}" == "automation" ]
  then
    PROJECT_DIR="automation"
    unset PULUMI_CONFIG_PASSPHRASE
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    PULUMI_EXEC="${PULUMI}"
  fi

  pushd $(pwd)
  cd "${PROJECT_DIR}"
  
  if [ "${GROUP}" == "cli" ]
  then
    "${PULUMI_EXEC}" up \
      --yes \
      --non-interactive \
      --stack=dev \
      --skip-preview \
      --parallel="${PARALLELISM}"
  elif [ "${GROUP}" == "automation" ]
  then
    python3 __main__.py --parallelism="${PARALLELISM}"
  fi
  popd
}

function main {
  run_project
}

main