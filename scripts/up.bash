#!/usr/bin/env bash

set -exuo pipefail

readonly PULUMI=/opt/homebrew/bin/pulumi
readonly PULUMI_DEV=/Users/robbiemckinstry/.pulumi-dev/bin/pulumi
readonly TERRAFORM=/opt/homebrew/bin/terraform
readonly GROUP="$1"
readonly DEFAULT_PARALLELISM="2147483647"

function run_project {
  PULUMI_EXEC=""
  PROJECT_DIR=""
  if [ "${GROUP}" == "control" ]
  then
    PROJECT_DIR="control"
    unset PULUMI_CONFIG_PASSPHRASE
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    PULUMI_EXEC="${PULUMI}"
  elif [ "${GROUP}" == "ts-control" ]
  then
    PROJECT_DIR="ts-control"
    unset PULUMI_CONFIG_PASSPHRASE
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    PULUMI_EXEC="${PULUMI}"
  elif [ "${GROUP}" == "patch" ]
  then
    PROJECT_DIR="control"
    unset PULUMI_CONFIG_PASSPHRASE
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    PULUMI_EXEC="${PULUMI_DEV}"
  elif [ "${GROUP}" == "checkpoint" ]
  then
    PROJECT_DIR="control"
    unset PULUMI_CONFIG_PASSPHRASE
    export PULUMI_EXPERIMENTAL="true"
    export PULUMI_SKIP_CHECKPOINTS="true"
    PULUMI_EXEC="${PULUMI_DEV}"
  elif [ "${GROUP}" == "jsonpatch" ]
  then
    PROJECT_DIR="control"
    unset PULUMI_CONFIG_PASSPHRASE
    export PULUMI_EXPERIMENTAL="true"
    unset PULUMI_SKIP_CHECKPOINTS
    export PULUMI_OPTIMIZED_CHECKPOINT_PATCH="true"
    PULUMI_EXEC="${PULUMI_DEV}"
  elif [ "${GROUP}" == "combined" ]
  then
    PROJECT_DIR="control"
    unset PULUMI_CONFIG_PASSPHRASE
    export PULUMI_EXPERIMENTAL="true"
    export PULUMI_SKIP_CHECKPOINTS="true"
    export PULUMI_OPTIMIZED_CHECKPOINT_PATCH="true"
    PULUMI_EXEC="${PULUMI_DEV}"
  elif [ "${GROUP}" == "pulumi-file" ]
  then
    PROJECT_DIR="pulumi-file"
    export PULUMI_CONFIG_PASSPHRASE=""
    export PULUMI_EXPERIMENTAL="true"
    export PULUMI_SKIP_CHECKPOINTS="true"
    export PULUMI_OPTIMIZED_CHECKPOINT_PATCH="true"
    PULUMI_EXEC="${PULUMI_DEV}"
  elif [ "${GROUP}" == "pulumi-s3" ]
  then
    PROJECT_DIR="pulumi-s3"
    export PULUMI_CONFIG_PASSPHRASE=""
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    unset PULUMI_OPTIMIZED_CHECKPOINT_PATCH
    PULUMI_EXEC="${PULUMI_DEV}"
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
  elif [ "${GROUP}" == "terraform-s3" ]
  then
    PROJECT_DIR="terraform-s3"
    unset PULUMI_CONFIG_PASSPHRASE
    unset PULUMI_EXPERIMENTAL
    unset PULUMI_SKIP_CHECKPOINTS
    unset PULUMI_OPTIMIZED_CHECKPOINT_PATCH
    PULUMI_EXEC=""
  fi

  pushd $(pwd)
  cd "${PROJECT_DIR}"
  echo "Collecting a sample for ${GROUP}."
  
  if [ "${GROUP}" == "terraform-remote" ]
  then
    $TERRAFORM apply -auto-approve -parallelism="${DEFAULT_PARALLELISM}"
  elif [ "${GROUP}" == "terraform-cloud" ]
  then
    $TERRAFORM apply -auto-approve -parallelism="${DEFAULT_PARALLELISM}"
  elif [ "${GROUP}" == "terraform-file" ]
  then
    $TERRAFORM apply -auto-approve -parallelism="${DEFAULT_PARALLELISM}"
  elif [ "${GROUP}" == "terraform-s3" ]
  then
    $TERRAFORM apply -auto-approve -parallelism="${DEFAULT_PARALLELISM}"
  else
    $PULUMI_EXEC up --yes --non-interactive --stack=dev --skip-preview
  fi
  popd
}

function main {
  run_project
}

main