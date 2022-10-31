#!/usr/bin/env bash

# This script will run all Pulumi experiments.
# It uses Hyperfine to run all of the experiemnts sequentially.
set -exuo pipefail

readonly WARMUP_RUNS="0"
readonly SAMPLE_SIZE="1"
# readonly EXPERIMENTS="control,ts-control,patch,checkpoint,jsonpatch,combined"
readonly EXPERIMENTS="cli,automation"
readonly PARALLELISM="50,150,250,350"

function main {
  hyperfine \
    --warmup="${WARMUP_RUNS}" \
    --runs="${SAMPLE_SIZE}" \
    --parameter-list "group" "${EXPERIMENTS}" \
    --parameter-list "parallelism" "${PARALLELISM}" \
    --prepare="./scripts/prepare-scaling.bash {group} {parallelism}" \
    --show-output \
    --export-json "scaling-experiment.json" \
    "./scripts/up-scaling.bash {group} {parallelism}"
}

main