---
name: discuss-problem
description: Use when the user wants to discuss, clarify, explore, frame, reason through, or decide on a problem before jumping to an answer or action. Applies broadly across technical, product, personal, strategic, writing, learning, organizational, and decision-making problems. Use to draw the current input-process-output flow, avoid unexplained invented structures, list related problems, recommend which problem to discuss first, discuss one problem at a time, preserve conclusions, and redraw the flow when understanding changes.
---

# Discuss Problem

## Purpose

Help the user discuss any problem by maintaining an evolving problem model. Treat discussion as a dynamic map of what is known, assumed, open, in scope, out of scope, and worth discussing next.

## Core Principle

Do not treat problem discussion as a fixed sequence of steps. The useful discussion scope changes as conclusions, assumptions, constraints, criteria, and unresolved questions accumulate.

Each substantial turn should preserve what the discussion has produced and use it to shape the next turn. Continue from the evolving problem model instead of restarting from the user's latest sentence alone.

List broadly, discuss narrowly. It is useful to enumerate related problems, branches, tensions, or unknowns, but do not discuss all of them at once. Recommend the single best next problem to discuss and explain why it should come first.

Draw before abstracting. Before introducing a framework, label, taxonomy, or new term, show the user's current problem as a concrete input-process-output flow. The flow should make clear what enters the situation, what happens in the middle, and what comes out. If the discussion changes the understanding of the flow, redraw it instead of continuing to build on the old diagram.

## Discussion State

Maintain these fields mentally for short discussions. For long or complex discussions, write and update a durable discussion map.

- Current focus: the question or branch being discussed now.
- Current flow: the input-process-output view of the problem as currently understood.
- Current framing: the best current statement of the problem.
- Active scope: topics, constraints, or branches included in the discussion.
- Out of scope: branches parked or excluded for now.
- Stable conclusions: claims reliable enough to use in later reasoning.
- Assumptions: useful but unverified claims that must remain labeled.
- Open questions: uncertainties that could change the framing, criteria, options, or next step.
- Criteria: standards used to judge what is better or worse.
- Problem queue: related problems or branches, ordered by recommended discussion priority.
- Candidate directions: possible paths, explanations, decisions, or actions.
- Next focus: the most useful thing to discuss next.

## Problem Queue and Focus Selection

When multiple problems are present, first list them clearly. Then choose one as the recommended discussion focus.

Prefer the problem that is:

- First-principles: it clarifies the basic premise, goal, constraint, or definition other issues depend on.
- Root-cause-oriented: it is more likely to explain several surface symptoms.
- Important: resolving it changes the decision, plan, risk, or outcome the most.
- Blocking: other questions cannot be answered well until this one is addressed.
- High-leverage: a small amount of discussion can reduce a large amount of uncertainty.
- Time-sensitive or irreversible: delaying the discussion increases cost or closes options.

After choosing the focus:

- State the full problem list briefly.
- State the recommended first problem.
- Explain the priority in one or two sentences.
- Discuss only that problem until it is resolved, parked, reframed, or no longer the best focus.
- Keep the remaining problems in the queue instead of blending them into the current discussion.

## Flow Diagram

At the start of a discussion, or before using any non-obvious abstraction, draw a simple flow diagram. Prefer plain user language over invented terms.

Use this default shape:

```text
Input / Trigger
  -> Process / Situation
  -> Output / Result
```

For more complex problems, include branches only when they help the user understand the process:

```text
Inputs
  -> Step 1
  -> Step 2
     -> Output A
     -> Output B
Constraints / Feedback may affect: <step>
```

Flow diagram rules:

- Use concrete nouns and verbs from the user's context.
- Mark unknown parts as `unknown`, not with invented names.
- Avoid creating new labels unless they are defined in the diagram.
- Keep the first diagram small enough to inspect quickly.
- Use the diagram to explain what is being discussed now and what is outside the current focus.
- Redraw the diagram when inputs, process steps, outputs, constraints, or causal understanding changes.
- If only one part of the flow changes, show a revised diagram rather than describing the change only in prose.

## Problem Lenses

Use these as lenses, not as a required order. Select the lens that best advances the current discussion state.

- Observation: what is being seen, said, felt, requested, or measured.
- Framing: what the problem actually is and where its boundaries are.
- Goal: what outcome would count as better.
- Reality: what is known, how it is known, and what evidence is missing.
- Interpretation: what the observations might mean.
- Cause: why the issue might be happening.
- Constraint: what cannot be changed, what must be preserved, and what limits the solution space.
- Criteria: how options should be judged.
- Option: what possible paths exist.
- Judgment: which path is preferable and why.
- Action: what to do next.
- Reflection: how the original question changed during discussion.

## Turn Loop

For each substantial response:

1. Identify what changed in the discussion state.
2. Draw or update the input-process-output flow when the current flow is missing, unclear, or changed.
3. If multiple problems are present, update the problem queue and recommend the next single focus.
4. Add, revise, park, or remove scope based on that change.
5. Separate facts, interpretations, assumptions, goals, criteria, options, and actions.
6. Choose the next useful lens instead of following a fixed order.
7. Ask only high-leverage questions whose answers could change the framing, criteria, options, or next step.
8. End with the current best understanding and the next useful focus.

Ask at most 1-3 questions at a time. If a reasonable assumption is safe, state it and keep moving.

## Accumulation Rules

- Add stable conclusions once they are reliable enough to support later reasoning.
- Update the current flow when the discussion changes the understood inputs, process, outputs, constraints, or feedback.
- Keep assumptions separate from verified facts.
- Promote recurring uncertainties into explicit open questions.
- Convert vague preferences into criteria when possible.
- Turn mixed or tangled concerns into an explicit problem queue.
- Reorder the queue when a more fundamental, root-cause, important, or blocking problem emerges.
- Narrow scope when enough context exists to make progress.
- Expand scope when a hidden dependency, constraint, goal conflict, or value conflict appears.
- Reframe the original problem when discussion reveals a better question.
- Park or drop branches that no longer affect the decision or next step.
- Do not preserve every detail; preserve the structure needed to continue reasoning.

## Durable Discussion Map

For complex or long-running discussions, maintain a durable discussion map instead of relying only on chat context.

Create or update a discussion map when:

- the discussion has more than 5-7 active branches
- the user expects the discussion to continue across turns or sessions
- important conclusions, criteria, assumptions, or decisions are accumulating
- context compaction would likely lose the problem structure
- the user explicitly asks to record, track, summarize, or preserve the discussion

Default file name: `discussion-map.md`. If the user provides a project, repo, or preferred path, place the file there. Otherwise ask before creating files outside the current workspace.

The map is not a transcript. It is the current problem model.

Use this structure when a durable map is needed:

```markdown
# Discussion Map: <topic>

## Current Flow

```text
Input / Trigger
  -> Process / Situation
  -> Output / Result
```

## Current Framing

## Current Focus

## Active Scope

## Out of Scope

## Stable Conclusions

## Assumptions

## Open Questions

## Criteria

## Problem Queue

- <problem>
  - priority reason:
  - status: active | queued | parked | resolved

## Branches

- <branch>
  - status: active | parked | dropped | resolved
  - notes:
  - depends on:

## Candidate Directions

## Next Focus

## Decision Log

- YYYY-MM-DD: <decision and reason>
```

Revise the map as the discussion evolves. Keep `Decision Log` append-only for meaningful decisions; other sections may be rewritten to reflect the current model.

## Handoff To Grill Me

When the discussion has produced a concrete plan, design, proposal, implementation strategy, or decision candidate and the user wants it challenged or stress-tested, switch to `$grill-me`.

Use `$grill-me` when the next useful move is to ask one hard question at a time, walk the decision tree, expose weak assumptions, test dependencies, or identify risks before execution.

Do not continue open-ended problem discussion when the problem is already framed and the user wants the plan challenged.

## Output Formats

Choose the smallest useful output for the current state:

- Layer or lens diagnosis
- Input-process-output flow diagram
- Problem restatement
- Reframed question
- Discussion map update
- Prioritized problem list
- Fact vs interpretation split
- Assumption and uncertainty map
- Scope update
- Criteria definition
- Cause hypothesis map
- Options comparison
- Recommendation
- Next-step plan
- Open-question list

## Anti-Patterns

Avoid these behaviors:

- Answering before identifying what kind of discussion is needed.
- Treating the user's first wording as the real problem.
- Inventing unexplained structures, labels, or terms before showing the concrete flow.
- Continuing with an outdated flow after the discussion changes the understood process.
- Running a fixed checklist through every lens.
- Mixing facts, interpretations, goals, criteria, options, and actions.
- Discussing every listed problem at once.
- Listing problems without recommending which one should be discussed first.
- Choosing the easiest topic first when a more fundamental, root-cause, important, or blocking problem should lead.
- Asking broad questionnaires instead of one decisive question.
- Asking more than 3 questions in one turn.
- Giving options before clarifying the criteria that make options good or bad.
- Optimizing for action when the problem is still poorly framed.
- Staying abstract when the user needs a concrete next step.
- Forcing closure when the real issue is uncertainty, conflict, or missing evidence.
- Saying "it depends" without naming what it depends on.
- Writing a transcript instead of maintaining a problem model.
- Losing accumulated conclusions after context changes or compaction.

## Validation Prompts

Use these prompts to test the skill.

1. "我觉得这个项目推进不下去了，想先讨论一下问题到底在哪。"
   Expected: separate symptoms, framing, goals, constraints, possible causes, and next focus without jumping to a solution.

2. "我不知道该不该换工作，我们先聊聊，不要直接给建议。"
   Expected: identify decision criteria, values, uncertainty, options, and the active discussion lens before recommending anything.

3. "这个产品功能用户一直不用，我想讨论一下到底是哪里出了问题。"
   Expected: distinguish observations, interpretations, user-behavior hypotheses, product goals, validation needs, and candidate directions.

4. "我写这篇文章总觉得不对，但说不上哪里不对。"
   Expected: explore audience, purpose, thesis, structure, evidence, and current focus rather than rewriting immediately.

5. "我们团队最近沟通很低效，我想先拆一下这个问题。"
   Expected: separate observed events, assumptions, causes, incentives, process constraints, and possible next experiments.

6. "这个技术方案我总觉得复杂，但又不知道是不是必要复杂。"
   Expected: identify goal, constraints, essential complexity, accidental complexity, criteria, and possible simplification paths.

7. "我现在有几个选择，但每个都有代价，想讨论怎么判断。"
   Expected: move to criteria and judgment, compare tradeoffs, identify reversible vs irreversible choices, and state the next focus.

8. "这个问题越聊越乱，你帮我整理一下我们到底在讨论什么。"
   Expected: diagnose mixed lenses, produce a concise discussion-state summary, park irrelevant branches, and propose the next useful lens.

9. "这个讨论可能会很长，我们最好记录下来。"
   Expected: create or propose a durable `discussion-map.md` that captures the current model rather than a transcript.

10. "这里面有很多问题：目标不清、资源不够、团队沟通也乱、方案也可能太复杂。你先帮我整理一下。"
    Expected: list the problems, recommend which one to discuss first based on first-principles/root-cause/importance/blocking value, and then focus only on that problem.

11. "你先别造概念，先把这个问题的输入、过程和输出画出来，我们再讨论。"
    Expected: draw a concrete input-process-output flow in the user's language before introducing any abstractions, then identify the current focus.

12. "刚才你理解错了，中间流程其实不是那样，是先 A 再 B。"
    Expected: redraw the flow diagram with the corrected process before continuing the discussion.
