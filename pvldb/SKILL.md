---
name: pvldb
description: Audit, plan, implement, and review PVLDB experiment-driven Umbra changes. Use when Codex works on requirements under /Users/jiamingwei/Desktop/Umbra_RPRB_Discussion_Notes/experiments, creates or evaluates experiment branches, verifies that non-experiment commits match umbra-poc-pgmaster-rebase-20260604, or checks Umbra requests for preserved logic and performance risk.
---

# PVLDB

## Core Rule

Treat the Gitee `postgres` branch
`origin/umbra-poc-pgmaster-rebase-20260604` in
`/Users/jiamingwei/gitCode/postgres` as the protected Umbra baseline. Every
PVLDB experiment branch must differ from that baseline only by the commits that
implement the explicit experiment requirement. This baseline branch must stay
commit-identical to the GitHub `postgre_umbra` branch with the same name.

Before editing code, read the relevant requirement files under:

```text
/Users/jiamingwei/Desktop/Umbra_RPRB_Discussion_Notes/experiments
```

Then audit the requested behavior. Do not assume the requirement is safe or complete.

Default to audit and analysis only. Do not write code, create commits, or modify
experiment logic unless the user explicitly asks for implementation after seeing
the audit.

## Baseline Discipline

Use the user's requested remote when specified. If unspecified, use the Gitee
remote branch `origin/umbra-poc-pgmaster-rebase-20260604` from
`/Users/jiamingwei/gitCode/postgres` as the baseline. Verify that it is
commit-identical to the GitHub `postgre_umbra` branch
`origin/umbra-poc-pgmaster-rebase-20260604` before relying on it. If those
branches differ, stop and report both SHAs before auditing or implementing an
experiment.

At the start of each task:

1. Check the current repository, remotes, current branch, and worktree state.
2. Fetch/prune the Gitee `postgres` baseline branch.
3. Fetch/prune the GitHub `postgre_umbra` branch with the same name.
4. Record both exact SHAs and verify they match.
5. Compare the experiment branch to the Gitee `postgres` baseline with `git rev-list --left-right --count` and `git log --cherry-pick --right-only`.
6. Identify which commits are experiment commits and which commits are accidental drift.

At the end of each task:

1. Re-run the baseline comparison.
2. Re-check that the Gitee `postgres` baseline SHA still matches the GitHub
   `postgre_umbra` same-name branch SHA.
3. Verify all non-experiment commits match the protected baseline.
4. Summarize the baseline SHA, GitHub parity SHA, experiment commits, and any residual drift.

Prefer creating a new experiment branch over rewriting an existing shared branch. Rewrite/reset an existing branch only when the user explicitly asks.

## Requirement Audit

Audit requirements before implementation. Use [audit-checklist.md](references/audit-checklist.md) when the request affects storage, WAL, recovery, buffer management, remap, checkpoint, or performance-sensitive code.

The audit must answer:

- What experiment result or hypothesis is being tested?
- Which Umbra invariant or subsystem is affected?
- What is the smallest code path that can satisfy the experiment?
- What existing logic must remain unchanged?
- What performance cost could appear on hot paths?
- What correctness cases must be tested?

If the requirement conflicts with existing Umbra behavior or would require broad architectural changes, stop and report the conflict instead of forcing an implementation.

## Implementation Rules

Only implement after the user explicitly approves moving beyond audit and
analysis.

Keep changes tightly scoped to the experiment.

- Do not modify original overall logic unless the requirement explicitly demands it and the audit justifies it.
- Do not add work to hot paths without a clear reason and a cheap fast path.
- Avoid broad refactors, formatting churn, and unrelated cleanup.
- Prefer feature flags, test-only hooks, or isolated experiment code when that preserves baseline behavior.
- Preserve WAL, recovery, checkpoint, remap, smgr, buffer, and metadata invariants unless the experiment is specifically about changing one.
- Add tests or focused validation proportional to risk.

When uncertain whether a change affects performance, inspect the call path and name the likely cost. For high-risk changes, recommend or run a microbenchmark/regression workload when available.

## Reporting

For each PVLDB task, report:

- Requirement files read.
- Baseline remote and SHA used, plus the GitHub `postgre_umbra` parity SHA.
- Experiment branch name and experiment commits.
- Audit conclusions and rejected risky interpretations.
- Implementation summary, tests run, and any tests not run.
- Whether the branch is cleanly aligned with `umbra-poc-pgmaster-rebase-20260604` except for experiment commits.
