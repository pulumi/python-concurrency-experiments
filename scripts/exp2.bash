#!/usr/bin/env bash

# This script will run all Pulumi experiments.
# It uses Hyperfine to run all of the experiemnts sequentially.
set -exuo pipefail

readonly WARMUP_RUNS="0"
readonly SAMPLE_SIZE="1"
readonly EXPERIMENTS="control,checkpoint,patch,combined"

function main {
  hyperfine \
    --warmup="${WARMUP_RUNS}" \
    --runs="${SAMPLE_SIZE}" \
    --parameter-list "group" "${EXPERIMENTS}" \
    --prepare="./scripts/prepare-exp2.bash {group}" \
    --export-json "env-expr.json" \
    "./scripts/up.bash {group}"
}

main