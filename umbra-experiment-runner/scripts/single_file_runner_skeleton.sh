#!/usr/bin/env bash
set -Eeuo pipefail

# Skeleton for Umbra experiment runners. Copy this structure into a concrete
# experiment script and fill in the TODO sections.

RUN_MODE="${RUN_MODE:-linux_paper}"   # linux_paper | mac_smoke
EXP_NAME="${EXP_NAME:-umbra_experiment}"
OS_USER="${OS_USER:-jiamingwei}"
BASE_DIR="${BASE_DIR:-}"
EXP_DIR="${EXP_DIR:-}"
PG_PORT="${PG_PORT:-55437}"
STAMP="$(date +%Y%m%d_%H%M%S)"
MATRIX_NAME="${MATRIX_NAME:-${EXP_NAME}_${RUN_MODE}_${STAMP}}"
RESULT_ROOT="${RESULT_ROOT:-}"
PGDATA_ROOT="${PGDATA_ROOT:-}"
FINAL_SUMMARY=""

LINUX_TPCC_CLIENTS="${LINUX_TPCC_CLIENTS:-10 50 200 500 1000}"
MAC_SMOKE_CLIENTS="${MAC_SMOKE_CLIENTS:-1}"
PG_BRANCH_MAC="${PG_BRANCH_MAC:-umbra-poc-pgmaster-rebase-20260604}"
VERSIONS_LIST="${VERSIONS_LIST:-mdonrelease umrelease mdoffrelease}"
DATA_PROFILE="${DATA_PROFILE:-quick}"  # quick | paper
TABLE_ROWS="${TABLE_ROWS:-auto}"

LABEL=""
FULL_PAGE_WRITES=""
EXTRA_CONF=""
PG_BIN=""
PG_DATA=""
JOB_DIR=""

log() {
    printf '[%s] %s\n' "$(date +%H:%M:%S)" "$*" >&2
}

die() {
    log "ERROR: $*"
    exit 1
}

default_table_rows() {
    if [ "$TABLE_ROWS" != "auto" ]; then
        printf '%s' "$TABLE_ROWS"
        return
    fi
    case "$RUN_MODE:$DATA_PROFILE" in
        mac_smoke:*) printf '%s' "10000" ;;
        linux_paper:quick) printf '%s' "1000000" ;;
        linux_paper:paper) printf '%s' "100000000" ;;
        *) printf '%s' "1000000" ;;
    esac
}

have_cmd() {
    command -v "$1" >/dev/null 2>&1
}

cleanup() {
    # TODO: stop local postgres processes owned by this runner only.
    :
}

sudo_pg() {
    if [ "$RUN_MODE" = "linux_paper" ]; then
        sudo -u "$OS_USER" "$@"
    else
        "$@"
    fi
}

resolve_variant() {
    local ver="$1"
    case "$ver" in
        mdonrelease)
            LABEL="md_fpw_on"
            FULL_PAGE_WRITES="on"
            EXTRA_CONF=""
            ;;
        umrelease)
            LABEL="umbra_fpw_on"
            FULL_PAGE_WRITES="on"
            EXTRA_CONF="map_compactor_enable = on"
            ;;
        mdoffrelease)
            LABEL="md_fpw_off"
            FULL_PAGE_WRITES="off"
            EXTRA_CONF=""
            ;;
        *)
            die "unknown version: $ver"
            ;;
    esac
}

resolve_paths_for_job() {
    local ver="$1"
    local case_or_clients="$2"
    resolve_variant "$ver"
    PG_BIN="$BASE_DIR/$ver/bin"
    PG_DATA="$PGDATA_ROOT/${ver}_${case_or_clients}"
    JOB_DIR="$RESULT_ROOT/${LABEL}_${case_or_clients}"
}

write_manifest() {
    TABLE_ROWS="$(default_table_rows)"
    {
        printf 'experiment=%s\n' "$EXP_NAME"
        printf 'run_mode=%s\n' "$RUN_MODE"
        printf 'os_user=%s\n' "$OS_USER"
        printf 'base_dir=%s\n' "$BASE_DIR"
        printf 'exp_dir=%s\n' "$EXP_DIR"
        printf 'pg_port=%s\n' "$PG_PORT"
        printf 'matrix_name=%s\n' "$MATRIX_NAME"
        printf 'result_root=%s\n' "$RESULT_ROOT"
        printf 'pgdata_root=%s\n' "$PGDATA_ROOT"
        printf 'timestamp=%s\n' "$STAMP"
        printf 'uname=%s\n' "$(uname -a)"
        printf 'versions=%s\n' "$VERSIONS_LIST"
        printf 'data_profile=%s\n' "$DATA_PROFILE"
        printf 'table_rows=%s\n' "$TABLE_ROWS"
        printf 'linux_tpcc_clients=%s\n' "$LINUX_TPCC_CLIENTS"
        printf 'mac_smoke_clients=%s\n' "$MAC_SMOKE_CLIENTS"
        printf 'mac_reference_branch=%s\n' "$PG_BRANCH_MAC"
        printf 'linux_path_convention=%s\n' 'experiment1_run_p0_linux_strict'
        printf 'normal_command=%s\n' "$([ "$RUN_MODE" = "linux_paper" ] && printf 'sudo ./run_<experiment>_strict.sh' || printf './run_<experiment>_strict.sh')"
    } > "$RESULT_ROOT/manifest.txt"
}

assert_mode() {
    case "$RUN_MODE" in
        linux_paper)
            [ "$(uname -s)" = "Linux" ] || die "linux_paper mode requires Linux"
            [ "$(id -u)" = "0" ] || die "linux_paper mode follows Experiment 1 and requires root for sudo/drop_caches style runners"
            ;;
        mac_smoke)
            [ "$(uname -s)" = "Darwin" ] || die "mac_smoke mode requires macOS"
            ;;
        *)
            die "unknown RUN_MODE: $RUN_MODE"
            ;;
    esac
}

configure_paths() {
    case "$RUN_MODE" in
        linux_paper)
            BASE_DIR="${BASE_DIR:-/home/jiamingwei}"
            EXP_DIR="${EXP_DIR:-$BASE_DIR/$EXP_NAME}"
            ;;
        mac_smoke)
            BASE_DIR="${BASE_DIR:-${MAC_BASE_DIR:-$PWD}}"
            EXP_DIR="${EXP_DIR:-${MAC_EXP_DIR:-$BASE_DIR/$EXP_NAME}}"
            ;;
    esac
    RESULT_ROOT="${RESULT_ROOT:-$EXP_DIR/results/$MATRIX_NAME}"
    PGDATA_ROOT="${PGDATA_ROOT:-$EXP_DIR/pgdata/$MATRIX_NAME}"
    FINAL_SUMMARY="$RESULT_ROOT/FINAL_SUMMARY.md"
    mkdir -p "$RESULT_ROOT" "$PGDATA_ROOT"
}

write_csv_headers() {
    printf 'check,status,detail\n' > "$RESULT_ROOT/validity_checks.csv"
    printf 'case,status,metric,value,unit,notes\n' > "$RESULT_ROOT/results.csv"
    printf 'case,status,reason\n' > "$RESULT_ROOT/failures.csv"
}

record_check() {
    printf '%s,%s,%s\n' "$1" "$2" "$3" >> "$RESULT_ROOT/validity_checks.csv"
}

run_experiment() {
    # TODO: implement concrete setup, workload, crash/recovery/performance cases,
    # oracles, and result recording here.
    record_check "runner_invoked" "pass" "skeleton executed"
    record_check "path_convention" "pass" "Experiment 1 style: BASE_DIR/version/bin, EXP_DIR/results, EXP_DIR/pgdata"
    printf 'smoke,pass,runner_started,1,count,replace with real case\n' >> "$RESULT_ROOT/results.csv"
}

write_final_summary() {
    {
        printf '# Final Summary: %s\n\n' "$EXP_NAME"
        printf '## Verdict\n\n'
        if [ "$RUN_MODE" = "mac_smoke" ]; then
            printf 'This is a macOS smoke run. It validates harness execution only and is not paper evidence.\n\n'
        else
            printf 'This is a Linux paper-mode run. Paper usability still depends on all validity checks passing.\n\n'
        fi

        printf '## Claim\n\n'
        printf 'TODO: state the exact correctness or performance claim this run tests.\n\n'

        printf '## Environment\n\n'
        printf '```text\n'
        cat "$RESULT_ROOT/manifest.txt"
        printf '```\n\n'

        printf '## Validity Checks\n\n'
        printf '```text\n'
        cat "$RESULT_ROOT/validity_checks.csv"
        printf '```\n\n'

        printf '## Results\n\n'
        printf '```text\n'
        cat "$RESULT_ROOT/results.csv"
        printf '```\n\n'

        printf '## Failures\n\n'
        printf '```text\n'
        cat "$RESULT_ROOT/failures.csv"
        printf '```\n\n'

        printf '## Paper-Safe Interpretation\n\n'
        printf 'TODO: say exactly what the results support, and what they do not support.\n\n'

        printf '## Raw Evidence Index\n\n'
        find "$RESULT_ROOT" -maxdepth 2 -type f | sort
    } > "$FINAL_SUMMARY"
}

main() {
    trap cleanup EXIT
    assert_mode
    configure_paths
    write_manifest
    write_csv_headers
    run_experiment
    write_final_summary
    log "wrote $FINAL_SUMMARY"
}

main "$@"
