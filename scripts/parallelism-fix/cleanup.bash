#!/usr/bin/env bash

set -exuo pipefail

# Select the correct Pulumi binary.
PULUMI_EXEC="${HOME}/.pulumi-dev/bin/pulumi"
readonly WORKSPACE="${HOME}/workspace/pulumi/pulumi"
readonly GROUP="$1"

function main {
  # PROJECT_DIR is the location of the source code.
  # Both experiments use the same code; only the version
  # of Pulumi is different between the experimental group
  # and the control group.
  PROJECT_DIR="control"
  # Ensure no variables from previous experiments are set.
  unset PULUMI_CONFIG_PASSPHRASE
  unset PULUMI_EXPERIMENTAL
  unset PULUMI_SKIP_CHECKPOINTS
  unset PULUMI_OPTIMIZED_CHECKPOINT_PATCH

  # Now, step into the project folder and run the experiment.
  pushd $(pwd)
  cd "${PROJECT_DIR}"

  # Destroy any resources from the last round of experiments.
  "${PULUMI_EXEC}" destroy --yes --non-interactive --stack=dev --skip-preview

  popd
}

main