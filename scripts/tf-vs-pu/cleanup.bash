#!/usr/bin/env bash

set -exuo pipefail

# Select the correct Pulumi binary.
readonly PULUMI_EXEC="${HOME}/.pulumi-dev/bin/pulumi"
readonly TERRAFORM="/opt/homebrew/bin/terraform"
readonly WORKSPACE="${HOME}/workspace/pulumi/pulumi"
readonly GROUP="$1"

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
  elif [ "${GROUP}" == "checkpoint" ]
  then
    PROJECT_DIR="control"
  # Variable Group: 
  elif [ "${GROUP}" == "terraform-cloud" ]
  then
    PROJECT_DIR="terraform-cloud"
  elif [ "${GROUP}" == "terraform-remote" ]
  then
    PROJECT_DIR="terraform-remote"
  fi

  # Now, step into the project folder and run the experiment.
  pushd $(pwd)
  cd "${PROJECT_DIR}"
  
  # Destroy any resources from the last round of experiments.
  if [ "${GROUP}" == "control" ]
  then
    "${PULUMI_EXEC}" destroy --yes --non-interactive --stack=dev --skip-preview
  elif [ "${GROUP}" == "checkpoint" ]
  then
    "${PULUMI_EXEC}" destroy --yes --non-interactive --stack=dev --skip-preview
  elif [ "${GROUP}" == "terraform-cloud" ]
  then
    "${TERRAFORM}" destroy -auto-approve
  elif [ "${GROUP}" == "terraform-remote" ]
  then
    "${TERRAFORM}" destroy -auto-approve
  fi

  popd
}

main