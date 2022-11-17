#!/usr/bin/env bash

# This script will run all Pulumi experiments.
# It uses Hyperfine to run all of the experiemnts sequentially.
set -exuo pipefail

readonly WARMUP_RUNS="1"
readonly SAMPLE_SIZE="20"
readonly EXPERIMENTS="control,checkpoint,terraform-cloud,terraform-remote"

function main {
  hyperfine \
    --warmup="${WARMUP_RUNS}" \
    --runs="${SAMPLE_SIZE}" \
    --parameter-list "group" "${EXPERIMENTS}" \
    --prepare="./scripts/tf-vs-pu/prepare.bash {group}" \
    --cleanup="./scripts/tf-vs-pu/cleanup.bash {group}" \
    --export-json "tf-vs-pu.json" \
    "./scripts/tf-vs-pu/up.bash {group}"
}

main