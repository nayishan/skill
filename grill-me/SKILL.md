---
name: grill-me
description: Use when the user wants Codex to stress-test a plan, design, architecture, implementation strategy, or decision by asking focused questions one at a time. Trigger when the user says "grill me", asks to be challenged, wants a plan reviewed through a decision tree, or wants dependencies, weak assumptions, risks, and missing evidence exposed before execution.
---

# Grill Me

## Purpose

Stress-test the user's plan by walking one decision branch at a time until the important assumptions, dependencies, risks, and unresolved decisions are explicit.

Use this skill after the user already has a plan, design, proposal, implementation strategy, or decision candidate. If the user is still trying to understand what the problem is, use `$discuss-problem` first.

## Core Rules

Ask exactly one question at a time.

Before asking, identify the highest-priority unresolved branch. Prefer branches that are blocking, root-cause-related, high-risk, irreversible, dependency-heavy, or likely to change the plan.

For each question, include:

- the question
- why it matters
- your recommended tentative answer
- what would change if the user disagrees

Label recommended answers as tentative unless proven by code, tests, docs, logs, or prior user answers.

## Codebase Rule

If a question can be answered by inspecting the local codebase, inspect the relevant code first instead of asking the user.

When using codebase evidence:

- prefer targeted reads and searches over broad exploration
- cite files, symbols, commands, or tests when relevant
- separate verified facts from inferences
- do not edit code unless the user switches from grilling to implementation

## Decision Tree State

Maintain the plan as a decision tree:

- Current plan: the latest version of the user's plan.
- Current branch: the branch being challenged now.
- Resolved decisions: decisions with enough agreement or evidence to proceed.
- Open questions: important unresolved branches.
- Deferred questions: branches intentionally postponed.
- Blocking assumptions: assumptions that could invalidate the plan.
- Evidence: user answers, codebase facts, tests, docs, logs, or measurements.
- Recommended next branch: the next branch to challenge.

For long grilling sessions, record this state in the user's existing planning document or in a compact `grill-map.md` if the user asks for persistent tracking.

## Question Loop

1. Restate the current plan briefly.
2. Identify the unresolved decision branches.
3. Choose the highest-priority branch.
4. Ask exactly one question.
5. Provide a recommended tentative answer.
6. Wait for the user's answer.
7. Update the decision tree.
8. Continue until important branches are resolved, deferred, or accepted as risk.

Do not ask a batch of questions. Do not continue to a new branch until the current branch is resolved, parked, or explicitly deferred.

## Priority Rules

Choose the next question by this order:

1. A question that could invalidate the whole plan.
2. A question that resolves a dependency for several later decisions.
3. A question about irreversible or expensive choices.
4. A question about missing evidence for a key assumption.
5. A question about failure modes, rollback, or observability.
6. A question about implementation details only after strategic branches are clear.

## Stop Condition

Stop grilling when:

- the plan's key assumptions are explicit
- blocking decisions are resolved or accepted as risks
- important dependencies are known
- remaining questions are non-blocking or intentionally deferred
- the next implementation or validation step is clear

End with:

- agreed plan
- resolved decisions
- remaining risks
- deferred questions
- recommended next action

## Handoff To Discuss Problem

If grilling reveals that the user does not yet have a clear problem, goal, flow, or plan candidate, stop grilling and suggest switching to `$discuss-problem`.

Use `$discuss-problem` when the next useful move is to draw the input-process-output flow, clarify the problem framing, list related problems, or choose which problem to discuss first.

## Anti-Patterns

Avoid these behaviors:

- asking multiple questions at once
- asking questions already answerable from the codebase
- pursuing every minor branch equally
- inventing concerns without explaining their impact
- continuing after the plan is clear enough to act
- presenting tentative answers as proven facts
- editing files during grilling
- jumping into implementation details before the plan-level assumptions are clear

## Validation Prompts

Use these prompts to test the skill.

1. "Grill me on this API migration plan before I implement it."
   Expected: identify the highest-risk migration branch and ask one question with a tentative recommended answer.

2. "我准备把这个服务拆成两个服务，你来拷打我。"
   Expected: challenge the split boundary, data ownership, deployment risk, rollback, and operational cost one branch at a time.

3. "Here is my refactor plan. Ask me the hard questions."
   Expected: inspect code first for questions answerable from the codebase, then ask one unresolved high-impact question.

4. "我还没想清楚问题是什么，只是觉得这个方案不对。"
   Expected: stop grilling and hand off to `$discuss-problem`.

5. "Grill me on whether this launch plan is safe."
   Expected: prioritize rollback, observability, blast radius, and acceptance criteria before minor execution details.
