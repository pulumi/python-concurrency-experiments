#!/usr/bin/env bash

# This script will run all Pulumi experiments.
# It uses Hyperfine to run all of the experiemnts sequentially.
set -exuo pipefail

export EXPERIMENT="tsnode"
readonly WARMUP_RUNS="3"
readonly SAMPLE_SIZE="10"
readonly EXPERIMENTS="control,tsnode,slow"
# readonly RESOURCE_COUNT="64,128,256"
readonly RESOURCE_COUNT="256"

function main {
  hyperfine \
    --warmup="${WARMUP_RUNS}" \
    --runs="${SAMPLE_SIZE}" \
    --parameter-list "group" "${EXPERIMENTS}" \
    --parameter-list "resource_count" "${RESOURCE_COUNT}" \
    --setup="./scripts/${EXPERIMENT}/prepare.bash {group} {resource_count}" \
    --cleanup="./scripts/${EXPERIMENT}/cleanup.bash {group} {resource_count}" \
    --show-output \
    --export-json "tsnode-samples.json" \
    "./scripts/tsnode/up.bash {group} {resource_count}"
}

main