# Coding Standards

> Write code for the next person to read. Clarity and correctness over cleverness.

---

## Core Principles

- Simple and explicit beats clever and implicit.
- If code needs a comment to be understood, consider rewriting it first.
- Consistency beats personal preference — follow the patterns already in the codebase.
- Leave code cleaner than you found it. Don't mix refactoring with feature changes.
- Optimise for readability at the call site, not just at the definition.

---

## Naming

- Names should reveal intent. A good name makes a comment unnecessary.
- Booleans read as assertions: `isActive`, `hasPermission`, `canRetry`.
- Avoid abbreviations unless they're universally understood (`id`, `url`, `err`).
- Avoid redundancy: don't repeat the type or parent name in a variable name.
- Longer scope = longer name. Single-letter variables are only acceptable in tiny, obvious scopes.
- Name constants — no magic numbers or unexplained string literals in logic.

---

## Functions

- A function does one thing. If you need "and" to describe it, split it.
- Keep functions short. Long functions are a signal to refactor, not a style choice.
- Return early on errors and edge cases to avoid deep nesting.
- Avoid side effects that aren't obvious from the function's name or signature.
- Pure functions (same input → same output, no side effects) are easier to test and reason about. Prefer them where practical.

---

## Error Handling

- Never silently ignore errors.
- Always add context when propagating an error — it should be traceable without a debugger.
- Distinguish between errors the caller can handle and ones that are truly unrecoverable.
- Validate inputs at the boundary (API, CLI, config) and trust them internally.

---

## Code Structure

- Keep files and modules focused. If a file is doing too many things, split it.
- Business logic must not leak into transport, persistence, or UI layers.
- Depend on abstractions (interfaces/protocols), not concrete implementations.
- Avoid circular dependencies — they're a sign of unclear boundaries.
- Configuration and environment details belong at the entry point, not buried in logic.

---

## Comments

- Comments explain _why_, not _what_. The code already says what.
- All public/exported symbols must have a doc comment.
- TODO comments must include context: what needs doing and ideally why it wasn't done now.
- Delete commented-out code. That's what version control is for.

---

## Testing

- Every non-trivial piece of logic has a test.
- Test behaviour, not implementation — tests should survive refactoring.
- Use table-driven or parameterised tests for functions with multiple input/output cases.
- Tests are first-class code. Apply the same standards to them.
- Slow or external tests (DB, network) must be clearly separated and skippable.
- A test that never fails is not a test.

---

## Performance

- Don't optimise prematurely. Profile before you tune.
- Benchmark before and after any performance-motivated change.
- Avoid unnecessary allocations and copies in hot paths.
- Favour clarity over micro-optimisation unless profiling proves otherwise.

---

## Git & Reviews

- Commits are atomic — one logical change per commit.
- Commit messages use imperative mood: `Add retry logic`, not `Added retry logic`.
- PRs should be reviewable in one sitting. Break large changes into a stack.
- A PR that touches formatting, refactoring, and a feature is three PRs.
