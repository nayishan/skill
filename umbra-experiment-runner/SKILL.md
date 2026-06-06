---
name: umbra-experiment-runner
description: Build, audit, or revise correctness-first Umbra/PostgreSQL database experiment scripts and result summaries. Use when Codex is asked to design or implement Umbra paper experiments, crash-recovery experiments, checkpoint/WAL/reclaim experiments, TPC-C/TPC-B style database benchmarks, Linux paper runners, macOS smoke runners, or single-file experiment summaries for the Umbra/RPRB work.
---

# Umbra Experiment Runner

Use this skill to write or audit Umbra experiment automation. Treat correctness as the first priority; treat performance as meaningful only after the validity checks prove the run exercised the intended mechanism.

## Priorities

1. Define the claim before writing the runner.
2. Define the experimental group, control group, independent variables, controlled variables, and oracles before collecting metrics.
3. Prefer strict correctness evidence over throughput curves.
4. Preserve raw evidence, but make the final answer inspectable from one summary file.
5. Make Linux the authoritative paper environment. Use macOS only for smoke validation that the script starts, builds, runs basic SQL, writes results, and fails cleanly.

## Required Modes

Every generated runner should expose explicit modes:

```text
RUN_MODE=linux_paper   # authoritative final experiment mode
RUN_MODE=mac_smoke     # local harness validation only
```

Rules:

- `linux_paper` is the only mode that can produce paper evidence.
- `mac_smoke` may use the local PostgreSQL source tree and the branch `umbra-poc-pgmaster-rebase-20260604`, but must be labeled smoke-only in the summary.
- Do not silently substitute macOS smoke results for Linux paper results.
- Do not modify the user's PostgreSQL source tree branch without checking worktree status first.

## Known Umbra Context

Use these defaults unless the user's current files say otherwise:

```text
macOS source branch: umbra-poc-pgmaster-rebase-20260604
Linux TPC-C client matrix: 10,50,200,500,1000
Linux OS user: jiamingwei
Linux base dir: /home/jiamingwei
```

For correctness experiments, prefer small deterministic data sets. For performance experiments, use the established Linux client matrix when comparing to prior TPC-C results.

## PostgreSQL Build Recipe

When a runner or smoke test is asked to build PostgreSQL from source, follow the
local `pgmake` convention unless the experiment explicitly requires a different
build. Do not treat a bare incremental `make && make install` as equivalent when
debugging crashes that may involve generated headers or stale objects.

Required environment shape:

```bash
PGCODE=/path/to/postgres-source
PGHOME=/path/to/install-prefix
PGLOG=/path/to/build-logs
```

Validate `PGCODE` exists, create `PGHOME` and `PGLOG` if missing, and run from
`$PGCODE`. Pass experiment-specific configure flags such as `--with-umbra` as
the final extra argument.

macOS/Darwin configure baseline:

```bash
./configure --prefix="$PGHOME" \
  --enable-cassert --enable-tap-tests --without-icu \
  --with-libs=/usr/local/lib --with-includes=/usr/local/include \
  CFLAGS='-g -O0 -fno-omit-frame-pointer' \
  LDFLAGS='-Wl,-rpath,@executable_path/../lib' \
  $EXTRA_CONFIGURE_FLAGS | tee "$PGLOG/configure.out"
```

Linux configure baseline:

```bash
./configure --prefix="$PGHOME" \
  --with-zlib --enable-nls --enable-integer-datetimes --enable-cassert \
  --with-libxml --with-uuid=e2fs --enable-debug \
  CFLAGS='-O0 -g' \
  $EXTRA_CONFIGURE_FLAGS | tee "$PGLOG/configure.out"
```

Full build/install baseline:

```bash
make world | tee "$PGLOG/compile.log"
rm -rf "$PGHOME"/*
make install-world | tee "$PGLOG/install.log"
```

Use this full recipe before concluding that a bootstrap or startup crash is an
Umbra runtime bug. Incremental builds are acceptable only for quick local script
iteration and must be reported as incremental in the final summary.

## Linux Path Convention

For Linux paper runners, follow the path style from Experiment 1
`/Users/jiamingwei/Desktop/Umbra_RPRB_Discussion_Notes/experiments/01_checkpoint_first_dirty/run_p0_linux_strict.sh`
unless the target experiment has a stronger local convention. Use this as the
path reference, not a generic TPC-C script:

```bash
OS_USER="${OS_USER:-jiamingwei}"
BASE_DIR="${BASE_DIR:-/home/jiamingwei}"
EXP_DIR="${EXP_DIR:-$BASE_DIR/<experiment_root>}"
PG_PORT="${PG_PORT:-5432}"

MATRIX_NAME="${MATRIX_NAME:-<short_name>_$(date +%Y%m%d_%H%M)}"
RESULT_ROOT="$EXP_DIR/results/$MATRIX_NAME"
PGDATA_ROOT="$EXP_DIR/pgdata/$MATRIX_NAME"
```

Version binaries should normally resolve like Experiment 1:

```bash
VERSIONS_LIST="${VERSIONS_LIST:-mdonrelease umrelease mdoffrelease}"
PG_BIN="$BASE_DIR/$ver/bin"
PG_DATA="$PGDATA_ROOT/${ver}_${case_or_clients}"
JOB_DIR="$RESULT_ROOT/${LABEL}_${case_or_clients}"
```

Use the same label mapping unless the experiment intentionally differs:

```text
mdonrelease  -> md_fpw_on     full_page_writes=on
umrelease    -> umbra_fpw_on  full_page_writes=on, map_compactor_enable=on
mdoffrelease -> md_fpw_off    full_page_writes=off
```

Linux paper scripts may require root when they use `sudo -u $OS_USER`, write
under `/proc/sys/vm/drop_caches`, inspect `/sys/class/block`, or chown result
trees. State that requirement in the script and summary.

For macOS smoke runners, do not create `/home/jiamingwei/...`. Rebase paths to
the local working directory or an explicit `MAC_BASE_DIR`, while preserving the
same logical layout:

```text
<mac-base>/<experiment_root>/results/$MATRIX_NAME
<mac-base>/<experiment_root>/pgdata/$MATRIX_NAME
```

## Runner Shape

Prefer one self-contained shell runner per experiment:

```text
run_<experiment>_strict.sh
```

The runner should generate a result root containing raw files, but the user should normally need to read only:

```text
FINAL_SUMMARY.md
```

If the existing experiment has a separate summarizer, it can remain as raw
support, but the new runner should still produce or call into a final one-file
summary. Do not require the user to manually inspect `runs.csv`, `server.log`,
or `waldump` files to know whether the experiment is usable.

`FINAL_SUMMARY.md` must include:

- experiment claim and mode;
- build identity, branch, commit, binary paths, OS, CPU, memory if available;
- experimental group and baselines;
- variable matrix;
- validity checks with pass/fail status;
- case/metric table;
- failure reasons and unusable-run reasons;
- paper-safe interpretation;
- raw evidence index with paths.

Use the bundled skeleton at `scripts/single_file_runner_skeleton.sh` as a structure reference when creating a new runner.

## Correctness First Checklist

Before implementing or approving an experiment runner, require:

```text
claim=<specific mechanism claim>
experimental_group=<Umbra variant>
control_group=<PostgreSQL/MD variant or justified none>
independent_variables=<client count, case id, crash point, etc.>
controlled_variables=<checkpoint settings, WAL settings, vacuum, data size, build>
oracle_sql=<SQL-visible expected state>
oracle_internal=<WAL/MAP/frontier/remap/reclaim evidence, if relevant>
invalid_run_rules=<when a run cannot be used>
summary_file=FINAL_SUMMARY.md
```

If internal evidence is unavailable, label the result as smoke or SQL-only evidence. Do not let SQL-only success support a mechanism claim that requires WAL/MAP/frontier/reclaim proof.

## Umbra Crash-Recovery Rules

For RPRB crash-recovery experiments:

- Require WAL flush proof before crashes that depend on replay.
- Require deterministic crash-point markers where the claim depends on an internal window.
- Require parseable remap facts for `old_pblk`, `new_pblk`, logical block, and frontier when claiming RPRB mechanism correctness.
- Require MAP/frontier dumps after recovery when claiming mapping/frontier correctness.
- For damaged-`new_pblk` cases, damage only the resolved physical target and record path, offset, block size, and pattern.
- For checkpoint-barrier cases, use a pause/release hook; timing stress alone is supplemental.
- Mark a case blocked or smoke-only when required hooks are missing. Do not approximate the missing internal evidence.

## Performance Rules

For Linux paper performance experiments:

- Use the known TPC-C client matrix `10 50 200 500 1000` unless the user intentionally changes it.
- Keep all performance curves behind validity gates: no unexpected checkpoint window, no WAL flush lag when forbidden, no failed runs, no missing logs.
- Report repeats separately and summarize medians/percentiles only after validity passes.
- Preserve throughput, latency, WAL bytes, FPI/remap counts, checkpoint timing, device write counters if relevant, and failure rows.

For macOS smoke:

- Use a tiny matrix, for example `CLIENTS=1` or `CASES=C1`.
- Confirm the script can initialize, start, run SQL, stop, write CSV, and write `FINAL_SUMMARY.md`.
- Mark every macOS result as non-paper.

## Script Standards

Generated scripts should be shell-based unless the user approves another dependency.

Use:

```bash
set -Eeuo pipefail
trap cleanup EXIT
psql -v ON_ERROR_STOP=1
timeout where available
explicit CSV headers
manifest files
stable result directories
```

Avoid:

- Python/R/notebooks by default;
- manual post-run inspection as a required step;
- sleeps as proof of WAL flush or checkpoint position;
- destructive operations outside the experiment result directory;
- averaging correctness cases into a single score;
- changing existing experiment scripts when the user asked for a new script.

## Output Standard

After writing or auditing a runner, report:

```text
created/updated files
whether macOS smoke is supported
whether Linux paper mode is supported
which validity gates are implemented
which claims are still blocked by missing hooks or interfaces
how to run the single command
where FINAL_SUMMARY.md will be written
```
