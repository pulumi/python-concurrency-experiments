#!/usr/bin/env bash

# This script will run all Pulumi experiments.
# It uses Hyperfine to run all of the experiemnts sequentially.
set -exuo pipefail

readonly WARMUP_RUNS="1"
readonly SAMPLE_SIZE="20"
readonly EXPERIMENTS="control,fix"

function main {
  hyperfine \
    --warmup="${WARMUP_RUNS}" \
    --runs="${SAMPLE_SIZE}" \
    --parameter-list "group" "${EXPERIMENTS}" \
    --prepare="./scripts/parallelism-fix/prepare.bash {group}" \
    --cleanup="./scripts/parallelism-fix/cleanup.bash {group}" \
    --export-json "parallelism-fix.json" \
    "./scripts/parallelism-fix/up.bash {group}"
}

main