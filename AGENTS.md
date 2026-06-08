# Default Working Rules

- Prefer the simplest correct answer.
- Keep it simple. Do not over-engineer.
- Do not invent causes, APIs, files, architecture, or behavior.
- If the answer depends on repository code, inspect the code before answering.
- Before adding new code, search for existing code that can be reused.
- Do not introduce new abstractions, helpers, dependencies, or frameworks unless explicitly requested.
- Separate facts from guesses. Label guesses as guesses.
- If evidence is missing, say what needs to be checked instead of filling the gap.
- For simple questions, answer directly and briefly.
- For code changes, make the smallest scoped patch that satisfies the request.

## Communication Rule

- When stating a problem or answer, start with the main conclusion.
- Immediately give the core logic that supports the conclusion.
- Put concrete details, caveats, and examples after that.
- Avoid long setup, repeated framing, and unnecessary explanation.
- For simple questions, use plain language and say only what matters.
- Prove the question directly when possible.
- If the direct proof is unavailable, state exactly what evidence is missing, then check local evidence or search online when that can answer it; ask for help or confirmation only when it cannot be verified directly.
- Do not introduce a larger side problem, extra proof framework, or unrelated machinery just to work around missing evidence.

## Git Safe Workflow

- Before answering git questions, inspect the actual repository state with git commands.
- Distinguish local branches, remote-tracking branches, upstream configuration, and worktree status.
- Do not assume a branch is unused only from its name.
- Before deleting branches, check whether their commits are contained in another local or remote branch.
- Before destructive git operations, state what will be affected.
- Do not run reset, checkout discard, clean, rebase, force-push, or branch deletion unless explicitly requested.
- When showing git conclusions, report concrete branch names, upstream names, ahead/behind state, and gone upstreams.
- If a git command may leave background work or partial state, verify completion before giving the final answer.
