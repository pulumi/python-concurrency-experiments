#!/usr/bin/env bash

# This script will run all Pulumi experiments.
# It uses Hyperfine to run all of the experiemnts sequentially.
set -exuo pipefail

readonly WARMUP_RUNS="0"
readonly SAMPLE_SIZE="20"
readonly EXPERIMENTS="control,ts-control"

function main {
  hyperfine \
    --warmup="${WARMUP_RUNS}" \
    --runs="${SAMPLE_SIZE}" \
    --parameter-list "group" "${EXPERIMENTS}" \
    --prepare="./scripts/ts-vs-py/prepare.bash {group}" \
    --cleanup="./scripts/ts-vs-py/cleanup.bash {group}" \
    --show-output \
    --export-json "ts-vs-py.json" \
    "./scripts/ts-vs-py/up.bash {group}"
}

main