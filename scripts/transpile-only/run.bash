#!/usr/bin/env bash

# This script will run all Pulumi experiments.
# It uses Hyperfine to run all of the experiemnts sequentially.
set -exuo pipefail

export EXPERIMENT="transpile-only"
readonly WARMUP_RUNS="3"
readonly SAMPLE_SIZE="10"
readonly EXPERIMENTS="control,experimental"

function main {
  hyperfine \
    --warmup="${WARMUP_RUNS}" \
    --runs="${SAMPLE_SIZE}" \
    --parameter-list "group" "${EXPERIMENTS}" \
    --setup="./scripts/${EXPERIMENT}/prepare.bash {group}" \
    --cleanup="./scripts/${EXPERIMENT}/cleanup.bash {group}" \
    --show-output \
    --export-json "transpile-samples.json" \
    "./scripts/${EXPERIMENT}/up.bash {group}"
}

main