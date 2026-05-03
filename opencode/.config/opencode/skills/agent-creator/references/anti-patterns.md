# Agent Anti-Patterns

Common mistakes to avoid when creating OpenCode agents.

## 1. Tool Overload

**Problem:** Enabling all tools "just in case" without considering if they're actually needed.

❌ **Bad:**

```yaml
tools:
  read: true
  write: true
  edit: true
  bash: true
  webfetch: true
  task: true
  todowrite: true
  todoread: true
  # Agent only reads and analyzes files!
```

✅ **Good:**

```yaml
tools:
  read: true
  grep: true
  glob: true
  # Only what's needed for analysis
```

**Why it's bad:**

- Increases attack surface
- Confuses the agent with too many options
- Makes permission management complex
- Violates principle of least privilege

**Rule:** Only enable tools essential for the agent's purpose.

---

## 2. Permission Promiscuity

**Problem:** Giving dangerous permissions without controls.

❌ **Bad:**

```yaml
tools:
  bash: true
permission:
  bash: allow # Allows `rm -rf /` without asking!
```

✅ **Good:**

```yaml
tools:
  bash: true
permission:
  bash:
    "*": ask # Ask for all by default
    "git status*": allow # Allow safe commands
    "ls *": allow
    "cat *": allow
    "rm *": deny # Deny dangerous
    "sudo rm *": deny
```

**Why it's bad:**

- System can be damaged
- Data can be lost
- Security vulnerabilities
- No user oversight

**Rule:** Always control bash and edit permissions with patterns.

---

## 3. Vague Description

**Problem:** Description doesn't explain when to use the agent.

❌ **Bad:**

```yaml
description: Helps with coding tasks
```

❌ **Also Bad:**

```yaml
description: General purpose development agent
```

✅ **Good:**

```yaml
description: >-
  Reviews React components for performance issues including
  bundle size, re-renders, and waterfall patterns.

  Use when asked to review, optimize, or analyze React/Next.js code.

  <example>
  User: "Review this component for performance bottlenecks"
  Assistant: "I'll use the `react-reviewer` agent."
  </example>
```

**Why it's bad:**

- Agent won't be auto-selected correctly
- User doesn't know when to invoke it
- Other agents don't know when to delegate to it

**Rule:** Description must include specific triggers and `<example>` blocks.

---

## 4. Missing Examples

**Problem:** No `<example>` blocks in description showing typical usage.

❌ **Bad:**

```yaml
description: Security auditing agent for code review
```

✅ **Good:**

```yaml
description: >-
  Security auditor for authentication and authorization code.

  <example>
  User: "Audit this login endpoint"
  Assistant: "I'll use the `security-auditor` agent."
  </example>

  <example>
  User: "Check this API for security issues"
  Assistant: "Let me invoke `security-auditor` to review it."
  </example>
```

**Why it's bad:**

- Other agents don't know how to invoke it
- Unclear what requests should trigger it
- Harder to discover and use

**Rule:** Always include 1-2 `<example>` blocks showing invocation.

---

## 5. Wrong Mode

**Problem:** Using wrong mode for agent's purpose.

❌ **Bad:**

```yaml
# Security auditor as primary - user must Tab to it!
description: Security auditor
mode: primary
```

✅ **Good:**

```yaml
# Security auditor as subagent - invoked when needed
description: Security auditor for...
mode: subagent
```

**Mode Selection Guide:**

- `primary` - Main development agents (build, plan)
- `subagent` - Specialized tasks (@security-auditor, @doc-writer)
- `all` - Flexible agents that work both ways

**Why it's bad:**

- Primary agents compete for Tab key
- Subagents are more composable
- Wrong mode breaks workflow

**Rule:** Use `subagent` for specialized agents, `primary` only for main workflows.

---

## 6. No Workflow Documentation

**Problem:** Agent has instructions but no clear process.

❌ **Bad:**

```markdown
You are a code reviewer. Review code for quality.
Check for bugs. Look for performance issues.
Suggest improvements. Write good code.
```

✅ **Good:**

```markdown
You are a code reviewer.

## Review Process

1. **Understand Context** - Read relevant files
2. **Analyze Code** - Check for issues:
   - Bugs and edge cases
   - Performance problems
   - Security vulnerabilities
   - Best practice violations
3. **Categorize Findings**:
   - 🔴 Critical (must fix)
   - 🟡 Important (should fix)
   - 🔵 Nice-to-have (consider)
4. **Report** - Provide actionable feedback
```

**Why it's bad:**

- No clear execution path
- Inconsistent results
- Hard to debug issues
- Can't improve systematically

**Rule:** Document clear step-by-step workflow.

---

## 7. Punting to Model

**Problem:** Vague instructions that rely on model to figure out details.

❌ **Bad:**

```markdown
Handle errors appropriately.
Use best practices.
Be careful with permissions.
```

✅ **Good:**

```markdown
## Error Handling

When a command fails:

1. Read the error message carefully
2. Check common issues:
   - Permissions? Run with sudo or check file ownership
   - Disk space? Run `df -h`
   - Dependencies? Check if package is installed
3. Consult man page: `man <command>`
4. Propose 2-3 specific solutions
5. Ask user which approach to try
```

**Why it's bad:**

- Inconsistent behavior
- Model has to guess intent
- Results vary by model
- Harder to maintain

**Rule:** Provide specific, actionable instructions.

---

## 8. Mixed Responsibilities

**Problem:** Agent tries to do too many unrelated things.

❌ **Bad:**

```yaml
description: >-
  Code reviewer, database admin, documentation writer,
  and security auditor all in one.
```

✅ **Good:**
Create separate agents:

- `code-reviewer` - Code quality only
- `db-admin` - Database operations only
- `doc-writer` - Documentation only
- `security-auditor` - Security only

**Why it's bad:**

- Violates single responsibility principle
- Hard to configure tools/permissions
- Unclear when to use
- Difficult to maintain

**Rule:** One agent, one clear purpose.

---

## 9. Hardcoded Paths

**Problem:** Using OS-specific or absolute paths.

❌ **Bad:**

```markdown
Check configuration in C:\Users\Name\.config\app\config.json
```

❌ **Also Bad:**

```markdown
Look for configs in /home/username/.config
```

✅ **Good:**

```markdown
Check configuration in `~/.config/app/config.json`

Or check project-local config in `.config/app.json`
```

**Why it's bad:**

- Doesn't work across systems
- Breaks for different users
- Not portable

**Rule:** Use `~` for home, relative paths for projects, forward slashes always.

---

## 10. Time-Sensitive Information

**Problem:** Including information that will become outdated.

❌ **Bad:**

```markdown
Use React 18.2.0 - the latest version as of 2024.
```

✅ **Good:**

```markdown
Use the latest stable React version.

## Legacy Patterns (Deprecated)

React <18: Use `ReactDOM.render()`
React 18+: Use `ReactDOM.createRoot()`
```

**Why it's bad:**

- Becomes inaccurate over time
- Requires constant updates
- Confuses users with old info

**Rule:** Use "latest" or document as legacy/deprecated sections.

---

## 11. No Permission Documentation

**Problem:** Bash enabled but permissions not documented.

❌ **Bad:**

```yaml
tools:
  bash: true
permission:
  bash: ask
```

No explanation in the prompt about what commands are allowed.

✅ **Good:**

```yaml
tools:
  bash: true
permission:
  bash:
    "*": ask
    "git status*": allow
    "rm *": deny
```

And in the prompt:

```markdown
## Command Permissions

**Allowed without asking:**

- `git status`, `git log`, `git diff` - Safe git read commands
- `ls`, `cat`, `grep` - File read operations

**Requires confirmation:**

- All other commands

**Denied:**

- `rm *` - File deletion (too dangerous)
```

**Why it's bad:**

- Agent confused about what it can do
- Users don't know what will trigger prompts
- Inconsistent behavior

**Rule:** Document permission strategy in the prompt.

---

## 12. Inconsistent Naming

**Problem:** Agent name doesn't follow conventions.

❌ **Bad:**

- `my-helper-agent`
- `tool-utils`
- `claude-security`
- `helper1`
- `NEW_AGENT`

✅ **Good:**

- `security-auditor` (noun-role)
- `reviewing-code` (gerund form)
- `doc-writer` (noun-role)
- `analyzing-performance` (gerund form)

**Why it's bad:**

- Harder to discover
- Inconsistent with ecosystem
- Unprofessional

**Rule:** Use gerund form (verb-ing) or noun-role pattern. Lowercase with hyphens.

---

## 13. Non-English Content

**Problem:** Writing agent files in languages other than English.

❌ **Bad:**

```yaml
description: >-
  Agente para revisar código y encontrar errores.
  Usar cuando necesites una revisión de calidad.
```

```markdown
# Revisor de Código

Eres un revisor de código experto. Tu trabajo es:

- Encontrar errores
- Sugerir mejoras
```

✅ **Good:**

```yaml
description: >-
  Reviews code for bugs, security issues, and best practices.
  Use when asked to review, audit, or analyze code quality.

  <example>
  User: "Review this code for issues"
  Assistant: "I'll use the code-reviewer agent."
  </example>
```

```markdown
# Code Reviewer

You are an expert code reviewer. Your responsibilities:

- Find bugs and edge cases
- Suggest improvements
```

**Why it's bad:**

- LLMs process English more efficiently (faster inference)
- Lower token usage = lower costs
- Better comprehension and consistency
- Less likely to hallucinate or misunderstand
- Not portable across multilingual teams

**Important:** The agent can still RESPOND in the user's preferred language during conversations. Only the agent FILE (frontmatter + instructions) should be in English.

**Rule:** Always write agent files in English, regardless of user's language.

---

## Quick Checklist

Before creating an agent, verify you're NOT doing:

- [ ] ❌ Writing agent files in non-English languages
- [ ] ❌ Enabling all tools "just in case"
- [ ] ❌ `bash: allow` or `edit: allow` without patterns
- [ ] ❌ Vague description without triggers
- [ ] ❌ Missing `<example>` blocks
- [ ] ❌ Wrong mode (primary vs subagent)
- [ ] ❌ No workflow documentation
- [ ] ❌ Vague instructions ("handle appropriately")
- [ ] ❌ Mixed responsibilities
- [ ] ❌ Hardcoded paths
- [ ] ❌ Time-sensitive information
- [ ] ❌ Undocumented permissions
- [ ] ❌ Inconsistent naming

If any are checked, fix before proceeding!

---

## Learn from Good Examples

Check these well-structured agents:

```bash
# In your OpenCode agent directory
ls ~/.config/opencode/agent/

# Read good examples:
cat ~/.config/opencode/agent/frontend-developer.md
cat ~/.config/opencode/agent/linux-sysadmin.md
```

Study their structure:

- Clear description with examples
- Appropriate tools for purpose
- Safe permission controls
- Well-documented workflow
- Single responsibility
