# OpenCode Agent Frontmatter Specification

Complete reference for agent YAML frontmatter configuration.

## Required Fields

### description

**Type:** String  
**Max Length:** 1024 characters  
**Required:** Yes

What the agent does AND when to use it. Write in third person. Include `<example>` blocks.

**Format:**

```yaml
description: >-
  [What it does in 1-2 sentences]

  Use when [trigger conditions].

  <example>
  User: "[typical user request]"
  Assistant: "I'll use the `agent-name` agent to [action]."
  </example>

  <example>
  User: "[another example]"
  Assistant: "[another response]"
  </example>
```

**Best Practices:**

- Include specific trigger keywords (review, analyze, audit, create, etc.)
- Add 1-2 `<example>` blocks showing typical usage
- Use third person: "Use when..." not "You should use..."
- Be specific about scenarios, not vague
- Mention file types or domains if relevant

**Examples:**

✅ **Good:**

```yaml
description: >-
  Security auditor that analyzes authentication and authorization code.
  Checks for SQL injection, XSS, CSRF, and data exposure vulnerabilities.

  Use when reviewing security of API endpoints, authentication flows,
  or handling sensitive data.

  <example>
  User: "Audit this login endpoint for security issues"
  Assistant: "I'll use the `security-auditor` agent to review it."
  </example>
```

❌ **Bad:**

```yaml
description: Security helper
```

---

## Optional Fields

### mode

**Type:** String  
**Values:** `primary` | `subagent` | `all`  
**Default:** `all`  
**Required:** No

Determines how the agent can be used.

**Values:**

- `primary` - User switches to this agent (Tab key)
- `subagent` - Invoked by @mention or other agents via Task tool
- `all` - Can be used as both primary and subagent

**When to use:**

- `primary` - Main development agents (build, plan)
- `subagent` - Specialized agents invoked when needed (code-reviewer, security-auditor)
- `all` - Flexible agents that work in both contexts

**Example:**

```yaml
mode: subagent
```

---

### tools

**Type:** Object  
**Required:** No

Enable/disable specific tools for this agent.

**Available Tools:**

- `read` - Read files
- `write` - Write new files
- `edit` - Edit existing files
- `glob` - Find files by pattern
- `grep` - Search file contents
- `bash` - Execute shell commands
- `webfetch` - Fetch web content
- `task` - Spawn subagents
- `todowrite` - Create/update todo lists
- `todoread` - Read todo lists
- `skill` - Load skills (rarely disabled)

**Format:**

```yaml
tools:
  read: true
  write: false
  edit: false
  bash: false
```

**Inheritance:**
Agent-specific tool config overrides global config.

**Best Practices:**

- Only enable tools needed for the agent's purpose
- Disable dangerous tools (bash, write, edit) if not needed
- Read-only agents: only enable read, grep, glob
- System agents: enable bash but control with permissions

**Examples:**

Code Reviewer (read-only):

```yaml
tools:
  read: true
  grep: true
  glob: true
  write: false
  edit: false
  bash: false
```

System Administrator:

```yaml
tools:
  read: true
  write: true
  bash: true
  # edit defaults to global config
```

Documentation Writer:

```yaml
tools:
  read: true
  write: true
  edit: true
  bash: false
  webfetch: true
```

---

### permission

**Type:** Object  
**Required:** No

Control what operations the agent can perform with enabled tools.

**Permission Levels:**

- `allow` - Auto-allow without asking
- `ask` - Prompt user for approval
- `deny` - Reject operation

**Supported Tools:**

- `edit` - File editing permissions
- `bash` - Shell command permissions (supports patterns)
- `webfetch` - Web fetching permissions
- `skill` - Skill loading permissions (supports patterns)
- `task` - Subagent spawning permissions (supports patterns)

**Format:**

```yaml
permission:
  edit: ask
  bash:
    "*": ask
    "git status*": allow
    "rm *": deny
  webfetch: allow
  skill:
    "*": allow
    "experimental-*": ask
  task:
    "*": deny
    "explore": allow
```

**Bash Permission Patterns:**

Use glob patterns to control specific commands:

```yaml
permission:
  bash:
    "*": ask # Default: ask for everything
    "ls *": allow # Allow ls
    "cat *": allow # Allow cat
    "git status*": allow # Allow git status
    "git log*": allow # Allow git log
    "git diff*": allow # Allow git diff
    "rm *": deny # Never allow rm
    "sudo rm *": deny # Never allow sudo rm
    "dd *": deny # Never allow dd
    "mkfs*": deny # Never allow mkfs
```

**Rule Precedence:**
Last matching rule wins. Put `"*"` first, then specific rules.

**Best Practices:**

- Always set bash permissions if bash is enabled
- Use `ask` as safe default
- Deny dangerous commands (rm, dd, mkfs)
- Allow safe read-only commands
- Use patterns for command families

**Examples:**

Security Auditor (no modifications):

```yaml
permission:
  edit: deny
  write: deny
  bash: deny
```

System Administrator (controlled bash):

```yaml
permission:
  bash:
    "*": ask
    "sudo *": ask
    "git status*": allow
    "ls *": allow
    "cat *": allow
    "rm *": deny
  edit: ask
  write: ask
```

Research Agent (web access):

```yaml
permission:
  edit: deny
  bash: deny
  webfetch: allow
```

---

### model

**Type:** String  
**Format:** `provider/model-id`  
**Required:** No

Override the model for this agent.

**Format:**

```yaml
model: anthropic/claude-sonnet-4-20250514
```

**Common Models:**

- `anthropic/claude-sonnet-4` - Balanced performance
- `anthropic/claude-haiku-4` - Fast, cheaper
- `anthropic/claude-opus-4` - Most capable
- `openai/gpt-5` - OpenAI flagship
- `opencode/gpt-5.1-codex` - Via OpenCode Zen

**When to Override:**

- Cheaper model for simple agents (haiku for planner)
- More capable model for complex agents (opus for architect)
- Specific model requirements

**Example:**

```yaml
# Use cheaper model for planning
model: anthropic/claude-haiku-4-20250514
```

---

### temperature

**Type:** Number  
**Range:** 0.0 - 1.0  
**Default:** Model-specific (typically 0 or 0.55)  
**Required:** No

Control randomness and creativity of responses.

**Ranges:**

- **0.0 - 0.2** - Very focused, deterministic (code analysis, planning)
- **0.3 - 0.5** - Balanced (general development)
- **0.6 - 1.0** - Creative, varied (brainstorming, writing)

**Examples:**

Code Reviewer (precise):

```yaml
temperature: 0.1
```

General Builder (balanced):

```yaml
temperature: 0.3
```

Creative Writer (varied):

```yaml
temperature: 0.7
```

---

### maxSteps

**Type:** Number  
**Required:** No

Maximum agentic iterations before forcing text-only response.

**When to Use:**

- Cost control
- Prevent runaway iterations
- Quick agents with limited scope

**Example:**

```yaml
maxSteps: 10 # Stop after 10 iterations
```

When limit reached, agent receives system prompt to summarize work and recommend remaining tasks.

---

### hidden

**Type:** Boolean  
**Default:** false  
**Required:** No  
**Only for:** `mode: subagent`

Hide subagent from @ autocomplete menu.

**When to Use:**

- Internal helper agents
- Programmatically invoked agents
- Agents only called by other agents via Task tool

**Example:**

```yaml
mode: subagent
hidden: true
```

User can't see in @ menu, but other agents can still invoke via Task tool if permissions allow.

---

## Complete Example

Full-featured agent configuration:

```yaml
---
description: >-
  Software architecture specialist for system design, scalability,
  and technical decision-making.

  Use PROACTIVELY when planning new features, refactoring large systems,
  or making architectural decisions.

  <example>
  User: "Design the architecture for a new payment system"
  Assistant: "I'll use the `architect` agent for this."
  </example>

mode: subagent

tools:
  read: true
  grep: true
  glob: true
  write: false
  edit: false
  bash: false
  webfetch: true

permission:
  webfetch: allow
  skill:
    "backend-patterns": allow
    "security-review": allow

model: anthropic/claude-opus-4-20250514

temperature: 0.2

maxSteps: 50
---
You are a senior software architect...
```

---

## Validation Rules

**Filename (Agent Name):**

- 1-64 characters
- Lowercase alphanumeric + hyphens
- No consecutive `--`
- Must not start/end with `-`
- Regex: `^[a-z0-9]+(-[a-z0-9]+)*$`
- Examples: `code-reviewer.md`, `security-auditor.md`, `db-admin.md`

> **Note:** The agent name comes from the filename, not a YAML field.
> File `~/.config/opencode/agent/code-reviewer.md` creates agent `code-reviewer`.

**Description:**

- 1-1024 characters
- Must include trigger keywords
- Should include `<example>` blocks
- Third person voice

**Mode:**

- Must be: `primary`, `subagent`, or `all`

**Tools:**

- Only valid tool names
- Boolean values

**Permission:**

- Valid permission levels: `allow`, `ask`, `deny`
- Bash patterns: valid glob syntax

**Model:**

- Format: `provider/model-id`

**Temperature:**

- Number between 0.0 and 1.0

---

## Quick Reference

```yaml
---
# Required
description: >-
  What it does. Use when [triggers].
  <example>...</example>

# Optional
mode: primary|subagent|all # default: all
tools: # default: global config
  read: true
  write: false
permission: # default: none
  bash:
    "*": ask
    "git status*": allow
  edit: ask
model: provider/model-id # default: global model
temperature: 0.1 # default: model default
maxSteps: 10 # default: unlimited
hidden: false # default: false (subagent only)
---
```
