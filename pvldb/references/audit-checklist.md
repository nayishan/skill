# PVLDB Umbra Audit Checklist

Use this checklist for PVLDB experiment requirements before editing Umbra code.

## Requirement Intake

- Locate the requirement under `/Users/jiamingwei/Desktop/Umbra_RPRB_Discussion_Notes/experiments`.
- Identify whether the request is an experiment knob, a measurement change, a correctness change, or an architectural request.
- Extract concrete acceptance criteria. If the file only states a vague idea, preserve it as a question rather than inventing behavior.
- Note affected files, functions, or subsystems implied by the requirement.

## Baseline Alignment

- Fetch the protected Gitee `postgres` baseline
  `origin/umbra-poc-pgmaster-rebase-20260604`.
- Fetch the GitHub `postgre_umbra` branch with the same name.
- Record both SHAs before work and verify they match.
- If the Gitee `postgres` baseline and GitHub `postgre_umbra` same-name branch
  differ, stop and report both SHAs before continuing.
- Compare the working branch with the baseline:

```bash
git rev-list --left-right --count <baseline>...HEAD
git log --oneline --cherry-pick --right-only <baseline>...HEAD
git diff --stat <baseline>...HEAD
```

- Treat commits not tied to the current experiment as drift.
- Do not silently absorb drift into the experiment.

## Correctness Questions

- Does the change preserve existing Umbra behavior when the experiment is disabled?
- Does the change affect WAL generation, WAL replay, recovery end, checkpoints, remap publication, or metadata cleanup?
- Are crash/restart, standby/recovery, and checkpoint interleavings still valid?
- Are lock ordering and memory lifetime unchanged or explicitly justified?
- Does the change alter fork, relfilenode, smgr, buffer tag, or relation mapping semantics?

## Performance Questions

- Is the changed code on a hot path such as buffer lookup, read/write, WAL insert/replay, checkpoint, smgr access, or relation open?
- Does it add syscalls, allocation, hashing, catalog lookups, branch-heavy checks, logging, or lock contention?
- Is there a cheap fast path for the normal non-experiment case?
- Can the experiment be controlled with a GUC, compile-time flag, test hook, or isolated measurement path?
- Is extra logging disabled by default or bounded?

## Implementation Boundary

- Prefer the smallest patch that makes the experiment measurable.
- Keep experiment mechanics separate from upstreamable Umbra logic when practical.
- Avoid changing public behavior, storage format, WAL records, or on-disk metadata unless the requirement explicitly needs it.
- Avoid cleanup commits mixed with experiment commits.

## Validation

- Run the narrowest relevant tests first.
- For storage/recovery changes, consider focused recovery/regression tests before broad suites.
- For performance-sensitive changes, record why the change should be neutral or name the benchmark needed.
- Compare final `HEAD` against the Gitee `postgres` baseline and list only the experiment commits as expected differences.
- Re-check that the Gitee baseline SHA matches the GitHub `postgre_umbra` same-name branch SHA.
