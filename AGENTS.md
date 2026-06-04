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

## Git Safe Workflow

- Before answering git questions, inspect the actual repository state with git commands.
- Distinguish local branches, remote-tracking branches, upstream configuration, and worktree status.
- Do not assume a branch is unused only from its name.
- Before deleting branches, check whether their commits are contained in another local or remote branch.
- Before destructive git operations, state what will be affected.
- Do not run reset, checkout discard, clean, rebase, force-push, or branch deletion unless explicitly requested.
- When showing git conclusions, report concrete branch names, upstream names, ahead/behind state, and gone upstreams.
- If a git command may leave background work or partial state, verify completion before giving the final answer.
