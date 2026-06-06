---
name: umbra-series-narrative
description: Use together with discuss-problem when discussing Umbra PostgreSQL upstreaming patch order, patch3 scope, whole-branch narrative, architecture-led introduction sequence, or how a local patch boundary fits into the larger RFC story before using umbra-patch-splitter to restack code.
---

# Umbra Series Narrative

Use this as a discussion companion for Umbra RFC/upstreaming work.  It answers:

```text
How should this patch fit into the whole Umbra introduction sequence?
```

It is not the execution skill for restacking code.  Use `umbra-patch-splitter`
after the narrative and patch boundary are clear.

## Pairing With discuss-problem

When both this skill and `discuss-problem` apply:

- use `discuss-problem` for the conversation mechanics;
- use this skill for Umbra-specific whole-series framing;
- discuss one patch boundary at a time;
- do not jump into code movement until the patch's role in the series is clear.

## Core Rule

Think from whole to local.

Do not define patch3, patch4, or any later patch by asking only:

```text
Which code is next?
```

Ask first:

```text
What must the whole branch introduce, in what order, so reviewers can understand
Umbra without accepting hidden correctness assumptions?
```

Patch splitting is also patch re-audit.  Correctness and readability must move
together.  If the old design has a correctness problem, prefer the simplest
local fix that restores a clear invariant.

## Branch Narrative Flow

Use this default flow unless the branch has materially changed:

```text
Goal:
  introduce Umbra into PostgreSQL in reviewable architectural layers

Order:
  1. PostgreSQL can select Umbra as an smgr implementation
  2. Umbra has a private physical file layer
  3. Umbra has relation-local metadata with a real format and bootstrap invariant
  4. Umbra uses metadata for logical-to-physical mapping
  5. mapping changes become WAL/redo/checkpoint-safe
  6. background maintenance, compaction, observability, and tests are added

Output:
  each patch proves one new architectural step without modifying unrelated modules
```

Redraw this flow when the discussion changes the order or when a proposed patch
does not fit cleanly.

## Patch Role Card

Before using `umbra-patch-splitter`, write a short role card for the patch:

```text
Patch N:
  role in whole branch:
  capability introduced:
  correctness invariant:
  owner / boundary:
  allowed modules:
  explicit non-goals:
  later patches that depend on it:
```

If the role card needs vague phrases like "some metadata stuff" or "prepare for
future work", the patch boundary is not clear enough.

## Patch3 Default Framing

For the current Umbra split, the default patch3 candidate is:

```text
Umbra relation-local metadata format and bootstrap.
```

It should prove:

```text
Umbra's private physical file layer can hold valid relation-local metadata with
a clear initial state and relation-bound lifecycle, while ordinary data-fork
semantics remain unchanged.
```

Likely in scope:

- metadata disk/page/superblock format;
- metadata creation/open/existence helpers needed by that format layer;
- bootstrap or identity state if required to make the format valid;
- relation lifecycle integration only for metadata ownership;
- minimal validation helpers needed to state the invariant.

Likely out of scope:

- ordinary data-fork remap policy;
- MAP cache;
- WAL block remap;
- redo state machine;
- checkpoint/mapwriter behavior;
- compactor;
- preallocation policy or GUCs;
- statistics and observability;
- changes to unrelated PostgreSQL modules.

## Decision Criteria

Prefer a patch boundary that:

- introduces one architectural step;
- states a simple correctness invariant;
- keeps code changes in the owning modules;
- leaves ordinary behavior unchanged unless the patch explicitly owns that change;
- avoids broad abstractions until there is a real caller;
- moves uncertain or speculative code later;
- is easy to describe in a commit message without hiding dependencies.

## Output For Execution

End the discussion with:

- the chosen patch role card;
- what must be moved into the patch;
- what must be moved out;
- the invariant to audit during implementation;
- the validation needed after restacking.
