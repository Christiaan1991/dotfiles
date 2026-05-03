# Agent Validation Checklist

Use this checklist to validate an agent file before deployment. The agent can read the target file and verify each item.

---

## How to Use

When validating an agent, read the agent file and check each item below. Mark issues as:

- **Error** - Must fix before use
- **Warning** - Should fix for quality
- **Info** - Optional improvement

---

## 1. File Structure

### Frontmatter Presence

- [ ] File starts with `---`
- [ ] Has closing `---` after YAML block
- [ ] YAML parses without errors
- [ ] Content exists after frontmatter

**Error if:** No frontmatter or invalid YAML syntax

---

## 2. Required Fields

### description (Required)

- [ ] Field exists and is a string
- [ ] Length is 20-1024 characters
- [ ] Contains trigger keywords ("Use when...", "Use for...", "Invoke when...")
- [ ] Contains at least one `<example>` block

**Validation:**

```yaml
# Good
description: >-
  Reviews code for security vulnerabilities.

  Use when asked to audit code, check for security issues,
  or review authentication implementations.

  <example>
  User: "Check this login code for vulnerabilities"
  Assistant: "I'll use the security-auditor agent."
  </example>

# Bad - too short, no triggers, no examples
description: Security helper
```

---

## 3. Optional Fields

### mode

- [ ] If present, value is one of: `primary`, `subagent`, `all`
- [ ] Default is `all` if not specified

**Validation:**

```yaml
# Valid
mode: subagent

# Invalid
mode: helper  # Error: not a valid mode
```

### tools

- [ ] If present, is a dictionary/object
- [ ] All keys are valid tool names
- [ ] All values are boolean (true/false)

**Valid tool names:**

```
bash, read, write, edit, glob, grep,
task, skill, webfetch, todoread, todowrite
```

**Validation:**

```yaml
# Good
tools:
  read: true
  glob: true
  grep: true
  skill: true

# Bad
tools:
  read: "yes"     # Error: must be boolean
  search: true    # Error: invalid tool name
```

### permission

- [ ] If present, is a dictionary/object
- [ ] Values are either: string (`allow`, `ask`, `deny`) or pattern dictionary
- [ ] Pattern dictionaries have valid permission levels

**Validation:**

```yaml
# Good - simple permissions
permission:
  edit: ask
  write: ask
  bash: deny

# Good - pattern-based permissions
permission:
  bash:
    "*": ask
    "git *": allow
    "rm -rf *": deny

# Bad
permission:
  bash: maybe        # Error: invalid level
  edit:
    "*": sometimes   # Error: invalid level
```

### model

- [ ] If present, is a string
- [ ] Format is `provider/model-id` (e.g., `anthropic/claude-sonnet-4`)

### temperature

- [ ] If present, is a number
- [ ] Value is between 0.0 and 1.0

### maxSteps

- [ ] If present, is an integer
- [ ] Value is at least 1

### hidden

- [ ] If present, is a boolean
- [ ] Only meaningful when `mode: subagent`

---

## 4. Deprecated Fields

These fields should NOT be present:

| Field         | Status     | Replacement                           |
| ------------- | ---------- | ------------------------------------- |
| `name`        | Deprecated | Name comes from filename              |
| `skills`      | Deprecated | Load skills at runtime via skill tool |
| `permissions` | Renamed    | Use `permission` (singular)           |

**Error if:** Any deprecated field is present

---

## 5. Tool Safety Patterns

### Check for Anti-Patterns

- [ ] Not all tools enabled (tool overload)
- [ ] If `bash: true`, has permission patterns
- [ ] If `write: true`, also has `read: true`
- [ ] If `edit: true`, also has `read: true`

**Warning if:**

- 9+ tools enabled
- bash without permission configuration
- write/edit without read

---

## 6. Body Content

### Structure

- [ ] Has content after frontmatter
- [ ] Uses `##` headings for organization
- [ ] Has at least 3 sections

### Recommended Sections

- [ ] Role definition (first paragraph)
- [ ] Core Responsibilities
- [ ] Workflow or Process
- [ ] Limitations (what agent CANNOT do)

### Safety (if bash enabled)

- [ ] Contains safety keywords: ALWAYS, NEVER, verify, confirm, backup, check
- [ ] Has at least 3 safety-related instructions

---

## 7. Quick Validation Summary

```markdown
## Validation Report for [agent-name]

### Errors (Must Fix)

- [ ] ...

### Warnings (Should Fix)

- [ ] ...

### Info (Optional)

- [ ] ...

### Result

[ ] PASS - No errors
[ ] FAIL - Has errors that must be fixed
```

---

## Example Validation

When asked to validate an agent, output a report like:

```markdown
## Validation Report: code-reviewer.md

### Errors

None

### Warnings

1. Description could include more trigger keywords

### Info

1. Consider adding error handling section

### Result: PASS

Agent is valid and ready for use.
```
