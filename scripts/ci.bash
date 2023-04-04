#!/usr/bin/env bash
set -exuo pipefail

readonly SCRIPTS_DIRECTORY="./scripts/${EXPERIMENT}"
readonly PREPARE_SCRIPT="${SCRIPTS_DIRECTORY}/prepare.bash"
readonly UP_SCRIPT="${SCRIPTS_DIRECTORY}/up.bash"
readonly CLEANUP_SCRIPT="${SCRIPTS_DIRECTORY}/cleanup.bash"

function main {
  hyperfine \
    --warmup="${WARMUP_RUNS}" \
    --runs="${SAMPLES}" \
    --parameter-list "group" "${GROUPS}" \
    --setup="${PREPARE_SCRIPT} {group}" \
    --cleanup="${CLEANUP_SCRIPT} {group}" \
    --show-output \
    --export-json "${DATA_FILE}" \
    "${UP_SCRIPT} {group}"
}

main