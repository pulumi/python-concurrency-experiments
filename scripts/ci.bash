#!/usr/bin/env bash
set -exuo pipefail

readonly SCRIPTS_DIRECTORY="./scripts/${EXPERIMENT}"
readonly PREPARE_SCRIPT="${SCRIPTS_DIRECTORY}/prepare.bash"
readonly UP_SCRIPT="${SCRIPTS_DIRECTORY}/up.bash"
readonly CLEANUP_SCRIPT="${SCRIPTS_DIRECTORY}/cleanup.bash"
readonly PULUMI_SRC_PATH="${PULUMI_SRC}"
# NB: This script also expects PULUMI_SRC_PATH to be set so
#     downstream scripts know where the source code is to compile.

function main {
  hyperfine \
    --warmup="${WARMUP_RUNS}" \
    --runs="${SAMPLES}" \
    --parameter-list "group" "${GROUPS}" \
    --setup="${PREPARE_SCRIPT} ${PULUMI_SRC_PATH} {group}" \
    --cleanup="${CLEANUP_SCRIPT} ${PULUMI_SRC_PATH} {group}" \
    --show-output \
    --export-json "${DATA_FILE}" \
    "${UP_SCRIPT} ${PULUMI_SRC_PATH} {group}"
}

main