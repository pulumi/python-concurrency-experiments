#!/usr/bin/env bash

# This script will run all Pulumi experiments.
# It uses Hyperfine to run all of the experiemnts sequentially.
set -exuo pipefail

readonly WARMUP_RUNS="0"
readonly SAMPLE_SIZE="1"
# readonly EXPERIMENTS="control,ts-control,patch,checkpoint,jsonpatch,combined"
# readonly EXPERIMENTS="terraform-remote,terraform-cloud,terraform-file,pulumi-file"
readonly EXPERIMENTS="terraform-s3,pulumi-s3,terraform-remote,terraform-cloud,terraform-file,pulumi-file"

function main {
  hyperfine \
    --warmup="${WARMUP_RUNS}" \
    --runs="${SAMPLE_SIZE}" \
    --parameter-list "group" "${EXPERIMENTS}" \
    --prepare="./scripts/prepare.bash {group}" \
    --show-output \
    --export-json "eight-way-experiment.json" \
    "./scripts/up.bash {group}"
}

main