#!/usr/bin/env bash

# This script will run all Pulumi experiments.
# It uses Hyperfine to run all of the experiemnts sequentially.
set -exuo pipefail

readonly WARMUP_RUNS="1"
readonly SAMPLE_SIZE="20"
readonly EXPERIMENTS="control,ts-control,patch,checkpoint,jsonpatch,combined"

function main {
  hyperfine \
    --warmup="${WARMUP_RUNS}" \
    --runs="${SAMPLE_SIZE}" \
    --parameter-list "group" "${EXPERIMENTS}" \
    --prepare="./scripts/prepare.bash {group}" \
    --export-json "six-way-experiment.json" \
    "./scripts/up.bash {group}"
}

main