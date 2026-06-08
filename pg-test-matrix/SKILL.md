---
name: pg-test-matrix
description: Use when running or explaining the PostgreSQL test matrix for md mode and Umbra mode in this repository. Use this skill when the task is to execute, verify, or report the matrix consisting of `make check` and `make -C src/test/recovery check` under md mode and under Umbra mode.
---

# Pg Test Matrix

## Overview

Use this skill when the user wants the standard local test matrix for this PostgreSQL tree, split by build mode.

The matrix has two modes:
- **md mode**
- **Umbra mode**

For each mode, run:
- `make check`
- `make -C src/test/recovery check`

## Mode Commands

### MD mode

1. Clean any previous build artifacts:
   - `make distclean`
2. Build/install with:
   - `pgmake`
3. Run core checks:
   - `make check`
4. Run recovery checks:
   - `make -C src/test/recovery check`

### Umbra mode

1. Clean any previous build artifacts:
   - `make distclean`
2. Build/install with:
   - `pgmake --with-umbra`
3. Run core checks:
   - `make check`
4. Run recovery checks:
   - `make -C src/test/recovery check`

## Execution Rules

- Run the matrix serially unless the user explicitly asks to parallelize.
- Always run `make distclean` immediately before each mode's build command, including when switching from md to Umbra or from Umbra to md.
- Report mode by mode.
- If build fails, stop that mode and report the first high-signal failure point.
- If `make check` fails, report the failing test name and log path if available.
- If recovery `make check` fails, report the failing recovery test and log path if available.

## Important Differences

- md mode must use plain `pgmake`.
- Umbra mode must use `pgmake --with-umbra`.
- Do not compare recovery total test counts directly between md and Umbra without noting that Umbra can include Umbra-only recovery cases.

## Output

For each mode, report:
- build command used
- whether build passed
- whether `make check` passed
- whether recovery `make check` passed
- the first failing test or log path if anything failed
