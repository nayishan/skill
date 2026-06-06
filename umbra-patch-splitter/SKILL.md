---
name: umbra-patch-splitter
description: Use when working on the Umbra PostgreSQL RFC/upstreaming branch and the task is to split or restack patches, reshape patch boundaries for community review, write or improve patch/commit messages, prepare v3-style RFC submission material, or align Umbra patches with community feedback about reviewability, fork abstraction, CFBot packaging, remap/checkpoint correctness, smgr boundaries, or metadata/umfile separation.
---

# Umbra Patch Splitter

Use this skill for Umbra upstreaming work where the output must be a correct,
reviewable PostgreSQL patch series, not just working code.

Patch splitting is also a patch re-audit.  Treat each split as a chance to
re-check correctness, ownership, and architectural boundaries.

## First Checks

Start by reading local context, in this order:

1. Current branch and remotes:

```bash
git status --short --branch
git branch -vv
git remote -v
```

2. Current series shape:

```bash
git log --oneline --decorate --reverse <base>..HEAD
git diff --stat <base>..HEAD
```

3. Community notes, if present:

```text
/Users/jiamingwei/Desktop/umbra-community/V3_REVIEW_BURDEN.md
/Users/jiamingwei/Desktop/umbra-community/PATCH_SPLIT_NOTES.md
/Users/jiamingwei/Desktop/umbra-community/FORK_ABSTRACTION_DISCUSSION.md
/Users/jiamingwei/Desktop/umbra-community/REMAP_CHECKPOINT_BUG_NOTES_ZH.md
```

Read only the files relevant to the current change. Treat them as working
notes, not source-of-truth code.

## Review Standard

The target is a reviewable RFC series for PostgreSQL community discussion.
Do not treat the job as only "make the branch build" or "write longer commit
messages".

Correctness is the first reviewability feature.  If the previous design has a
correctness problem, prefer the simplest fix that restores a clear invariant.
Do not introduce a wider framework, extra cross-module hooks, or speculative
abstractions when a local, architecture-aligned fix is enough.

Keep the series architecture-led:

- modify only modules that belong to the current patch boundary;
- do not touch unrelated PostgreSQL subsystems just to make a patch look tidy;
- move code later rather than widening an early patch's responsibility;
- keep interfaces narrow and private until a later patch has a real caller;
- delete or defer proof-of-concept scaffolding that does not support the current
  invariant.

Each patch must answer:

- what capability this patch introduces;
- why it belongs at this point in the series;
- what state or abstraction is introduced;
- who owns that state;
- what invariant keeps it valid;
- what later patches depend on it;
- what is intentionally not solved yet.

If one patch asks reviewers to evaluate multiple independent design questions,
split it.

If a patch cannot state its invariant simply, either split it further or simplify
the implementation.

## Current Umbra Split Direction

Prefer these review units unless the code has materially changed:

1. smgr implementation boundary
   - `--with-umbra` build selection
   - Umbra as a separate smgr implementation
   - `SMgrRelationData.smgr_private` ownership boundary
   - ordinary relation operations still forward to `md.c`
   - no MAP, WAL, redo, checkpoint, or compactor semantics

2. physical `umfile` layer
   - `umfile.c`, `umfile.h`, `um_defs.h`
   - `UmbraFileContext`
   - backend-local file/context registry keyed by `RelFileLocatorBackend`
   - segment open/create/close/read/write/extend/zeroextend/truncate/sync/unlink helpers
   - private physical fork slot/path convention if needed by `umfile`
   - no public `UmMetadata*` API, no MAP page format, no superblock bootstrap,
     no data-fork remapping, no WAL/redo, no metadata lifecycle integration

3. metadata format/bootstrap
   - metadata disk format
   - MAP superblock bootstrap or identity bootstrap
   - public `UmMetadata*` surface only when used by the metadata format layer
   - relation lifecycle integration for creating/removing metadata fork

Later patches may cover MAP cache, access policy, WAL/redo, checkpoint/mapwriter,
compaction, tests, and cleanup. Keep each patch as one defensible review unit.

## Community Requirements

Always preserve these requirements in patch work:

- avoid macOS AppleDouble `._*` files in generated patch tarballs;
- make commit messages useful enough to guide review;
- keep cover-letter text explicit about intended review targets;
- distinguish core lifecycle/block operation framework from owner-defined fork
  content interpretation;
- describe Umbra MAP as storage/remap-layer-owned metadata, not a generic
  table/index AM semantic fork;
- avoid exposing Umbra-private internals through core smgr APIs unless the patch
  explicitly argues for that boundary;
- keep CFBot consumability separate from source-code correctness.

## Commit Message Template

For each patch, write a message with this shape:

```text
umbra: <short review-unit title>

Introduce <capability>.  <One sentence saying what changes now.>

This patch is placed here because <dependency/order reason>.  It lets reviewers
evaluate <review target> before <later concepts>.

The ownership boundary is: <owner A owns X>; <owner B owns Y>.  <Who must not
interpret what?>

Correctness invariants for this patch are: <small invariant list in prose>.

Later patches depend on this to <future dependency>.  This patch intentionally
does not <explicit non-goals>.
```

Keep the body concrete and code-grounded. Do not paste an architecture essay
into every commit.

## Splitting Workflow

1. Identify the base.
   - Prefer the known upstream/base commit for the branch.
   - Use `git merge-base` when unsure.

2. Create or confirm a working branch.
   - Do not rewrite a branch the user did not ask to rewrite.
   - Preserve dirty user changes; stop if tracked changes would be overwritten.

3. Classify changed files by review unit.
   - Use `git diff --name-status <base>..HEAD`.
   - Use `git show --stat` and focused diffs for each candidate patch.

4. Audit correctness while classifying.
   - Identify the invariant introduced by the patch.
   - Check failure paths, ownership/lifetime, resource cleanup, and recovery
     semantics before deciding the boundary is acceptable.
   - If correctness relies on later patches, say so explicitly or move the code
     later.
   - Prefer small local fixes over broad infrastructure when both are correct.

5. Move code by boundary, not by filename alone.
   - A file can contain hunks for multiple patches.
   - Split hunks when a file mixes physical substrate, metadata semantics,
     WAL/redo, checkpoint, or background maintenance.

6. Restack with small commits.
   - Use non-interactive git where possible.
   - Use `git cherry-pick -n`, `git reset -p`, `git add -p`, or equivalent
     careful staging when splitting.
   - Avoid losing original authorship/context unless the user asks.

7. Write or amend commit messages using the template.

8. Validate after each meaningful restack.

## Validation Checklist

Minimum checks:

```bash
git diff --check <base>..HEAD
git log --oneline --decorate --reverse <base>..HEAD
```

For buildable points:

```bash
make distclean
PGCODE=$PWD pgmake
make world
```

For full matrix, use the `postgres-test-matrix` skill.

Before generating patch files or tarballs, check:

```bash
find . -name '._*' -print
```

If creating a tarball on macOS, use `COPYFILE_DISABLE=1`.

## Reporting

When done, report:

- branch name and base;
- old patch count and new patch count;
- patch list with one-line purpose for each;
- intentional non-goals left for later patches;
- validation performed and failures;
- any untracked files left untouched.
