#!/usr/bin/env bash

# This script will run all Pulumi experiments.
# It uses Hyperfine to run all of the experiemnts sequentially.
set -exuo pipefail

export EXPERIMENT="s3-concurrency"
readonly WARMUP_RUNS="1"
readonly SAMPLE_SIZE="1"
readonly EXPERIMENTS="control,experimental,2x,4x,8x"
readonly RESOURCE_COUNT="64,128,256"
readonly PULUMI_SRC_PATH="${PULUMI_SRC}" # Expecting the directory of the source code.

function main {
  hyperfine \
    --warmup="${WARMUP_RUNS}" \
    --runs="${SAMPLE_SIZE}" \
    --parameter-list "group" "${EXPERIMENTS}" \
    --parameter-list "resource_count" "${RESOURCE_COUNT}" \
    --setup="./scripts/${EXPERIMENT}/prepare.bash ${PULUMI_SRC_PATH} {group} {resource_count}" \
    --cleanup="./scripts/${EXPERIMENT}/cleanup.bash ${PULUMI_SRC_PATH} {group} {resource_count}" \
    --show-output \
    --export-json "${EXPERIMENT}.json" \
    "./scripts/${EXPERIMENT}/up.bash ${PULUMI_SRC_PATH} {group} {resource_count}"
}

main