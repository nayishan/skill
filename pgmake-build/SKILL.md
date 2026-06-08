---
name: pgmake-build
description: Use when compiling this PostgreSQL tree with the local pgmake wrapper and the task requires choosing between md mode and Umbra mode. Use this skill when the user asks to build, rebuild, or install PostgreSQL with pgmake, especially when md mode should use plain `pgmake` and Umbra mode should use `pgmake --with-umbra`.
---

# Pgmake Build

## Overview

Use this skill when the user wants a PostgreSQL build through the local `pgmake` wrapper instead of calling `configure` and `make` directly.

`pgmake` already performs:
- `configure`
- `make world`
- `make install-world`

## Mode Selection

- **MD mode**: run `pgmake`
- **Umbra mode**: run `pgmake --with-umbra`

Do not mix them. If the tree contains Umbra code paths and configure is run without `--with-umbra`, the link step can fail with many undefined `Map*` or `Um*` symbols.

## Workflow

1. Run from the target PostgreSQL workspace.
2. Assume `pgmake` comes from the user's local environment and uses `PGCODE`, `PGHOME`, and `PGLOG`.
3. Pick the mode explicitly:
   - md: `pgmake`
   - umbra: `pgmake --with-umbra`
4. Wait for the full wrapper to finish. It configures, builds, and installs.
5. Report:
   - whether configure selected Umbra support
   - whether `make world` passed
   - whether `make install-world` passed

## Checks

During Umbra mode, verify configure output includes:

- `checking whether to build with Umbra storage manager... yes`

If it says `no` while the tree still references Umbra storage symbols, the wrong build mode was chosen.

## Output

When reporting results, include:
- the command used
- whether it succeeded
- the high-signal failure point if it failed
- the install prefix if it succeeded
