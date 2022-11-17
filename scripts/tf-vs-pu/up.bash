#!/usr/bin/env bash

set -exuo pipefail

# Select the correct Pulumi & Terraform binaries.
readonly PULUMI_EXEC="${HOME}/.pulumi-dev/bin/pulumi"
readonly TERRAFORM="/opt/homebrew/bin/terraform"
readonly WORKSPACE="${HOME}/workspace/pulumi/pulumi"
readonly DEFAULT_PARALLELISM="2147483647"
readonly GROUP="$1"

function run_project {
  # Ensure no variables from previous experiments are set.
  unset PULUMI_CONFIG_PASSPHRASE
  unset PULUMI_EXPERIMENTAL
  unset PULUMI_SKIP_CHECKPOINTS
  unset PULUMI_OPTIMIZED_CHECKPOINT_PATCH

  PROJECT_DIR=""
  if [ "${GROUP}" == "control" ]
  then
    PROJECT_DIR="control"
  # Variable Group: Skip checkpointing.
  elif [ "${GROUP}" == "checkpoint" ]
  then
    PROJECT_DIR="control"
    export PULUMI_EXPERIMENTAL="true"
    export PULUMI_SKIP_CHECKPOINTS="true"
  # Variable Group: Use TF Cloud Backend.
  elif [ "${GROUP}" == "terraform-cloud" ]
  then
    PROJECT_DIR="terraform-cloud"
  # Variable Group: Use TF Remote Backend.
  elif [ "${GROUP}" == "terraform-remote" ]
  then
    PROJECT_DIR="terraform-remote"
  fi

  pushd $(pwd)
  
  cd "${PROJECT_DIR}"
  echo "Collecting a sample for ${GROUP}."

  if [ "${GROUP}" == "control" ]
  then
    "${PULUMI_EXEC}" up \
      --yes \
      --non-interactive \
      --stack=dev \
      --skip-preview
  elif [ "${GROUP}" == "checkpoint" ]
  then
    "${PULUMI_EXEC}" up \
      --yes \
      --non-interactive \
      --stack=dev \
      --skip-preview
  elif [ "${GROUP}" == "terraform-cloud" ]
  then
    "${TERRAFORM}" apply -auto-approve -parallelism="${DEFAULT_PARALLELISM}"
  elif [ "${GROUP}" == "terraform-remote" ]
  then
    "${TERRAFORM}" apply -auto-approve -parallelism="${DEFAULT_PARALLELISM}"
  fi

  popd
}

function main {
  run_project
}

main