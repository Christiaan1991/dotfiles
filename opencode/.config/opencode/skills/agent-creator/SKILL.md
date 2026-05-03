---
name: agent-creator
description: Expert guidance for creating, configuring, and refining OpenCode agents. Use when working with agent files, authoring new agents, improving existing agents, or understanding agent structure and best practices. Use PROACTIVELY when user mentions creating agents, configuring tools, setting permissions, or agent architecture.
license: MIT
compatibility: agent-skills-standard
metadata:
  category: agent-development
  version: "3.1.0"
  author: "Rodrigo Lago"
---

# Creating OpenCode Agents

Expert system for creating high-quality OpenCode agents with optimal configurations, comprehensive documentation, and skills integration.

## Core Principles

### 1. ALWAYS Write Agent Files in English

**CRITICAL:** All agent files MUST be written in English, regardless of the user's language.

- **Frontmatter**: description, examples - ALL in English
- **System prompt**: Role, responsibilities, workflows - ALL in English
- **Comments and documentation** - ALL in English

**Why?** LLMs process English more efficiently, resulting in:

- Faster response times
- Lower token usage (cost savings)
- Better model comprehension
- More consistent behavior

If the user requests an agent in another language, translate the requirements to English when writing the file. The agent can still RESPOND in the user's preferred language during conversations.

### 2. Agents Are Specialized Assistants

Only add context the agent doesn't have. Assume intelligence. Focus on configuration and behavior, not teaching basics.

### 3. Standard YAML + Markdown Format

Use YAML frontmatter + markdown body. **No XML tags** - use standard markdown headings.

```yaml
---
description: What it does + when to use + examples
mode: primary|subagent|all
tools: { read: true, write: false }
permission: { bash: ask, edit: deny }
---
You are [ROLE]. Your expertise is [DOMAIN].
```

### 4. Progressive Disclosure

- **SKILL.md** < 650 lines (core decisions + quick reference tables)
- **references/** detailed documentation (loaded when needed)
- **templates/** ready-to-use agent templates
- **workflows/** step-by-step processes

### 5. Effective Descriptions

Include **WHEN to use** (triggers) and **WHAT it does**. Write in third person. Add `<example>` blocks.

### 6. Context First (Critical Context Gathering)

**CRITICAL:** Every agent MUST gather context before taking action.

Include a "Context First" subsection in Operating Principles:

```markdown
### Context First

Before taking action on any request:

1. **Identify what's missing** - What assumptions am I making? What constraints aren't stated?
2. **Ask targeted questions** - Be specific, prioritize by impact, group related questions
3. **Confirm understanding** - Summarize your understanding before proceeding
4. **Respect overrides** - If user says "just do it" or similar, proceed with reasonable defaults

Never proceed with significant changes based on assumptions alone.
```

**Why?** Agents that act on incomplete information cause more harm than good. Gathering context:

- Prevents mistakes from wrong assumptions
- Builds user trust through clarification
- Results in better outcomes with less rework

### 7. Verification Loop (Post-Action Validation)

**CRITICAL:** Every agent that makes changes MUST verify results.

Include a "Verification Loop" section for agents that modify files or run commands:

```markdown
## Verification Loop

After completing any changes:

1. **Syntax Check** - Validate file syntax (YAML, JSON, code)
2. **Functional Test** - Run relevant commands to verify behavior
3. **Permission Test** - Confirm access controls work as expected

IF any check fails:
→ Fix the issue
→ Re-run verification
→ Do NOT report completion until all pass
```

**Why?** Professional systems (Claude Code, Codex, Gemini CLI) all require verification loops. Benefits:

- Catches errors before user sees them
- Builds trust through reliability
- Reduces back-and-forth corrections

## Quick Start

**What would you like to do?**

1. **Create new agent** → Use the `Write` tool to create `~/.config/opencode/agent/<name>.md`
2. **Audit existing agent** → Use the `Read` tool to review, then apply fixes with `Edit`
3. **Upgrade prompt to agent** → Read the prompt, then create proper agent file
4. **Get guidance** → Continue reading below

> **Important:** This skill is **passive knowledge**. When creating agents, use OpenCode's
> `Write` and `Edit` tools directly to create/modify agent files. Do NOT require users
> to run scripts manually. The scripts in `scripts/` are optional CLI utilities for
> validation - the primary workflow is direct file creation.

**Example Workflow:**

```
User: "Create an agent for reviewing database schemas"
    ↓
1. Agent loads this skill for guidance
2. Agent reads templates/references as needed
3. Agent uses Write tool to create ~/.config/opencode/agent/db-schema-reviewer.md
4. Done! User can now use @db-schema-reviewer
```

## Agent Structure

### Required Frontmatter

| Field         | Required          | Max Length | Example                      |
| ------------- | ----------------- | ---------- | ---------------------------- |
| `description` | Yes               | 1024 chars | What + when + examples       |
| `mode`        | No (default: all) | -          | primary, subagent, all       |
| `tools`       | No                | -          | `{read: true, write: false}` |
| `permission`  | No                | -          | Permission overrides         |
| `model`       | No                | -          | `anthropic/claude-sonnet-4`  |
| `temperature` | No                | -          | 0.1 - 1.0                    |
| `maxSteps`    | No                | -          | 5, 10, 250                   |
| `hidden`      | No                | -          | true (subagents only)        |

See [references/frontmatter-spec.md](references/frontmatter-spec.md) for complete specification.

### Naming Conventions

Use **gerund form** (verb + -ing) or **noun-role**:

✅ **Good:**

- `analyzing-security`
- `reviewing-code`
- `security-auditor`
- `doc-writer`
- `db-admin`

❌ **Avoid:**

- `helper`, `utils`, `tool`
- `claude-*`, `opencode-*`
- Vague names like `agent1`, `my-agent`

### Body Structure

```markdown
---
[frontmatter]
---

You are [ROLE/PERSONA]. Your expertise is [DOMAIN].

## Core Responsibilities

1. [PRIMARY RESPONSIBILITY]
2. [SECONDARY RESPONSIBILITY]

## Operating Principles

### Context First

Before taking action on any request:

1. **Identify what's missing** - What assumptions am I making?
2. **Ask targeted questions** - Be specific, prioritize by impact
3. **Confirm understanding** - Summarize before proceeding
4. **Respect overrides** - If user says "just do it", proceed with defaults

### Safety First

- ALWAYS [RULE]
- NEVER [ANTI-RULE]

## Workflow

1. **Understand** - Clarify requirements
2. **Plan** - Design approach
3. **Execute** - Implement
4. **Verify** - Validate results

## Common Tasks

[Examples with commands]
```

## Agent Types

See [references/agent-types.md](references/agent-types.md) for detailed guide.

**Quick Reference:**

| Type           | Mode     | Tools          | Permissions          | Use Case         |
| -------------- | -------- | -------------- | -------------------- | ---------------- |
| **Builder**    | primary  | all            | edit=ask, bash=ask   | Full development |
| **Planner**    | primary  | read, grep     | edit=deny, bash=deny | Analysis only    |
| **Reviewer**   | subagent | read, grep     | write=deny           | Code review      |
| **Executor**   | subagent | bash, read     | bash=patterns        | System tasks     |
| **Researcher** | subagent | read, webfetch | write=deny           | Documentation    |

## Agent Complexity Scale

Choose the right size for your agent:

| Complexity      | Lines   | Tools | maxSteps | When to Use                                    |
| --------------- | ------- | ----- | -------- | ---------------------------------------------- |
| **🟢 Micro**    | 50-100  | 1-2   | 5-10     | Single task (git helper, format checker)       |
| **🟡 Simple**   | 100-200 | 2-4   | 10-25    | Focused specialist (code reviewer, doc writer) |
| **🟠 Standard** | 200-400 | 4-6   | 25-50    | Full workflow (developer, tester)              |
| **🔴 Complex**  | 400+    | 6+    | 50-250   | Orchestrator, multi-domain coordinator         |

**Decision Logic:**

```
IF single, focused task → Micro
ELSE IF one domain, few tools → Simple
ELSE IF full workflow with verification → Standard
ELSE IF coordinates other agents → Complex

DEFAULT: Start with Micro/Simple. Upgrade only when proven necessary.
```

**Why Smaller is Better:**

- Faster to invoke (less prompt parsing)
- Cheaper to run (fewer tokens)
- Easier to maintain
- More predictable behavior

## Security Risk Levels

Categorize agents by risk to choose appropriate permissions:

| Level        | Icon | Tools Allowed    | Permission Pattern      | Examples                 |
| ------------ | ---- | ---------------- | ----------------------- | ------------------------ |
| **Safe**     | 🟢   | read, grep, glob | All write/bash = deny   | Reviewers, analyzers     |
| **Moderate** | 🟡   | +write, edit     | bash = deny, edit = ask | Doc writers, refactorers |
| **Elevated** | 🟠   | +bash (patterns) | Specific allows only    | Build agents, testers    |
| **High**     | 🔴   | +bash (broad)    | ask for all dangerous   | DevOps, DB admins        |

**Risk Assessment Questions:**

1. Can this agent delete files? → 🟠 Elevated or higher
2. Can this agent run arbitrary commands? → 🔴 High
3. Can this agent access secrets/credentials? → 🔴 High
4. Is this agent read-only? → 🟢 Safe

**Rule:** Default to 🟢 Safe. Justify each risk escalation in the agent's documentation.

## Tone Calibration Guide

Configure agent communication style based on type:

| Agent Type     | Verbosity     | Response Length        | Style                   |
| -------------- | ------------- | ---------------------- | ----------------------- |
| **Reviewer**   | Detailed      | Long (findings report) | Critical, thorough      |
| **Builder**    | Concise       | As needed              | Practical, code-focused |
| **Researcher** | Comprehensive | Medium-Long            | Informative, cited      |
| **Executor**   | Minimal       | Short                  | Direct, action-focused  |
| **Planner**    | Detailed      | Long                   | Analytical, structured  |

**Include in every agent:**

```markdown
## Tone and Style

- **Verbosity**: [minimal | concise | moderate | detailed | comprehensive]
- **Response length**: [short: 5-10 lines | medium: 10-30 lines | long: 30+ lines | as needed]
- **Voice**: [2-3 adjectives describing communication style]
```

**Examples by Type:**

```markdown
# Reviewer Agent

## Tone and Style

- Verbosity: detailed - include all findings with evidence
- Response length: long - comprehensive audit reports
- Voice: critical, thorough, objective

# Builder Agent

## Tone and Style

- Verbosity: concise - code speaks, minimal commentary
- Response length: as needed for implementation
- Voice: technical, precise, practical

# Executor Agent

## Tone and Style

- Verbosity: minimal - status updates only
- Response length: short - 5 lines max unless error
- Voice: direct, action-focused, efficient
```

## Cost Optimization Guide

Optimize agent configuration for performance and cost:

### Model Selection

| Task Type             | Recommended Model | Tokens/Response | Cost Level  |
| --------------------- | ----------------- | --------------- | ----------- |
| Simple routing/triage | claude-3-haiku    | ~500            | 💰 Low      |
| Code review/analysis  | claude-sonnet-4   | ~2000           | 💰💰 Medium |
| Complex reasoning     | claude-opus-4     | ~4000           | 💰💰💰 High |
| Quick lookups         | claude-3-haiku    | ~200            | 💰 Low      |

**Rule:** Use the smallest model that achieves acceptable quality.

### maxSteps Configuration

| Agent Type           | maxSteps | Rationale                          |
| -------------------- | -------- | ---------------------------------- |
| Reviewer (read-only) | 5-10     | Limited scope, no iteration needed |
| Doc writer           | 10-25    | Create and verify                  |
| Builder/Developer    | 25-50    | Iterative implementation           |
| Tester               | 25-50    | Run multiple test cycles           |
| Orchestrator         | 50-250   | Multi-agent coordination           |

**Warning:** Higher maxSteps = higher potential cost. Set limits appropriate to task.

### Temperature Guide

| Use Case         | Temperature | Behavior                  |
| ---------------- | ----------- | ------------------------- |
| Code generation  | 0.1 - 0.3   | Deterministic, consistent |
| Analysis/Review  | 0.3 - 0.5   | Balanced, thorough        |
| Documentation    | 0.5 - 0.7   | Natural, readable         |
| Creative writing | 0.7 - 0.9   | Varied, expressive        |

**Default:** 0.3 for most technical agents.

### Cost-Saving Patterns

1. **Lazy Loading**: Don't enable tools you rarely use
2. **Early Exit**: Add clear completion criteria
3. **Scope Limits**: Define what's out of scope explicitly
4. **Batch Operations**: Group related file operations
5. **Cache Results**: Reference previous findings instead of re-analyzing

## Tool Selection

See [references/tool-selection.md](references/tool-selection.md) for detailed guide.

**Quick Decision Tree:**

- Need to **read** files? → `read: true`
- Need to **search** content? → `grep: true, glob: true`
- Need to **modify** files? → `write: true, edit: true`
- Need to **execute** commands? → `bash: true`
- Need **web access**? → `webfetch: true`
- Need to **spawn subagents**? → `task: true`
- Need **task tracking**? → `todowrite: true, todoread: true`

**Rule:** Start minimal. Only enable tools needed for the agent's purpose.

## Permission Patterns

See [references/permission-patterns.md](references/permission-patterns.md) for complete library.

**Quick Examples:**

```yaml
# Safe by default
permission:
  bash:
    "*": ask                    # Ask for all
    "git status*": allow        # Allow safe commands
    "rm *": deny                # Deny dangerous

# Read-only agent
permission:
  edit: deny
  write: deny
  bash: deny

# Task-specific (database admin)
permission:
  bash:
    "*": ask
    "psql -c 'SELECT*": allow
    "psql -c 'DROP*": deny
```

## Validation Checklist

Before creating an agent, verify:

- [ ] **Written entirely in English** (frontmatter, prompt, examples)
- [ ] Valid YAML frontmatter with description and examples
- [ ] Description includes triggers + `<example>` blocks
- [ ] Tools match agent purpose
- [ ] Dangerous tools have permission controls
- [ ] System prompt defines clear responsibilities
- [ ] **Context First subsection** in Operating Principles
- [ ] Workflow is documented
- [ ] Tested with real tasks

See [workflows/audit-agent.md](workflows/audit-agent.md) for complete rubric.

## Post-Creation Verification Loop

**CRITICAL:** After creating any agent, verify it works correctly.

### Verification Steps

```bash
# 1. Syntax Check - Validate YAML frontmatter
head -50 ~/.config/opencode/agent/<name>.md | yq .
# Should parse without errors

# 2. File Check - Verify file was created
ls -la ~/.config/opencode/agent/<name>.md
```

### Functional Tests

| Test                 | How                    | Expected                     |
| -------------------- | ---------------------- | ---------------------------- |
| **Invocation**       | Type `@agent-name`     | Agent responds appropriately |
| **Permission Deny**  | Request blocked action | Agent refuses or asks        |
| **Permission Allow** | Request allowed action | Action succeeds              |
| **Out of Scope**     | Request unrelated task | Agent declines or redirects  |
| **Edge Case**        | Empty/ambiguous input  | Agent asks for clarification |

### Verification Decision Tree

```
1. Create agent file
   ↓
2. Syntax valid?
   NO → Fix YAML errors → retry
   YES ↓
3. Invoke with simple request
   ↓
4. Agent responds correctly?
   NO → Edit prompt/tools → retry from step 3
   YES ↓
5. Test permission boundaries
   ↓
6. Permissions work as expected?
   NO → Fix permission config → retry from step 3
   YES ↓
7. ✅ Agent ready for use
```

### Report Template

After verification, report:

```markdown
## Agent Created: {name}

### Configuration

- Mode: {primary|subagent}
- Tools: {list}
- Risk Level: {🟢|🟡|🟠|🔴}

### Verification

- [x] YAML syntax valid
- [x] Invocation works
- [x] Permissions tested
- [x] Edge cases handled

### Usage

- Invoke: `@{name}` or Tab to switch
- Purpose: {brief description}
```

## Anti-Patterns

See [references/anti-patterns.md](references/anti-patterns.md) for complete list.

**Common Mistakes:**

1. ❌ **Non-English Content** - Writing agents in other languages (always use English)
2. ❌ **Tool Overload** - Enabling all tools "just in case"
3. ❌ **Permission Promiscuity** - `bash: allow` without controls
4. ❌ **Vague Description** - "Helps with coding tasks"
5. ❌ **Missing Examples** - No `<example>` blocks
6. ❌ **Wrong Mode** - Security auditor as primary instead of subagent
7. ❌ **No Workflow** - Pile of instructions without process
8. ❌ **Skipping Verification** - Not testing agent after creation
9. ❌ **Wrong Complexity** - Building Complex agent for Simple task
10. ❌ **No Tone Calibration** - Verbose agent for quick tasks
11. ❌ **Ignoring Cost** - Using opus for simple routing tasks
12. ❌ **Missing Context First** - Agent acts without gathering requirements

## Templates

Ready-to-use templates in [templates/](templates/) directory:

### Basic Templates

- **[simple-agent.md](templates/simple-agent.md)** - Basic template with TODOs (starting point)

### Specialized Templates

- **[security-auditor.md](templates/security-auditor.md)** - Security review without changes (read-only)
- **[doc-writer.md](templates/doc-writer.md)** - Documentation specialist
- **[db-admin.md](templates/db-admin.md)** - Database operations with safe permissions
- **[code-reviewer.md](templates/code-reviewer.md)** - Code quality analysis (read-only)
- **[refactoring-agent.md](templates/refactoring-agent.md)** - Code structure improvements
- **[testing-agent.md](templates/testing-agent.md)** - Automated testing specialist
- **[api-developer.md](templates/api-developer.md)** - REST/GraphQL API development
- **[devops-agent.md](templates/devops-agent.md)** - CI/CD and infrastructure automation
- **[frontend-dev.md](templates/frontend-dev.md)** - React/Next.js frontend development

## Agent Creation Process

For the complete step-by-step workflow, see **[workflows/create-new-agent.md](workflows/create-new-agent.md)**.

### Quick Summary

```
1. UNDERSTAND → Ask: purpose, triggers, mode (primary/subagent)
2. CATEGORIZE → Determine: type, complexity (🟢-🔴), risk level
3. CREATE     → Write file to ~/.config/opencode/agent/<name>.md
4. CONFIGURE  → Set: description, tools, permissions, tone
5. VERIFY     → Run: syntax check, invocation test, permission test
6. REPORT     → Confirm creation with usage instructions
```

### Primary Method: Direct File Creation

When a user asks you to create an agent:

1. **Gather requirements** (ask clarifying questions)
2. **Read relevant template** from `templates/*.md`
3. **Use Write tool** to create `~/.config/opencode/agent/<name>.md` for a
   general agent, or create in `.opencode/agent/<name>.md` for a project
   specific agent
4. **Run verification loop** (syntax + invocation test)
5. **Report completion** with `@agent-name` usage

**Example:**

```
User: "Create an agent for database migrations"

Agent:
1. Read templates/db-admin.md
2. Customize for migrations (safety rules, allowed commands)
3. Write to ~/.config/opencode/agent/db-migrator.md
4. Verify: yq frontmatter, test @db-migrator
5. Report: "Created db-migrator. Use @db-migrator to invoke."
```

## Success Criteria

A well-structured agent:

- ✅ **Written entirely in English** (critical for LLM efficiency)
- ✅ Has valid YAML frontmatter with descriptive name and description
- ✅ Description includes trigger keywords and `<example>` blocks
- ✅ Uses standard markdown headings (not XML tags)
- ✅ Has appropriate tools for its purpose (not all tools)
- ✅ Has safe permission controls for dangerous tools
- ✅ **Includes Context First subsection** in Operating Principles
- ✅ **Includes Verification Loop** for agents that make changes
- ✅ **Has Tone and Style section** with calibrated verbosity
- ✅ **Appropriate complexity level** (start small, scale up)
- ✅ **Cost-optimized** (right model, maxSteps, temperature)
- ✅ Documents workflow and responsibilities clearly
- ✅ Includes usage examples
- ✅ Has been tested with real tasks (post-creation verification)

## Reference Documentation

For detailed guidance, see:

- **[frontmatter-spec.md](references/frontmatter-spec.md)** - Complete YAML specification
- **[tool-selection.md](references/tool-selection.md)** - Tool selection guide
- **[permission-patterns.md](references/permission-patterns.md)** - Permission examples library
- **[agent-types.md](references/agent-types.md)** - Agent type patterns and use cases
- **[anti-patterns.md](references/anti-patterns.md)** - What to avoid with examples
- **[skills-integration.md](references/skills-integration.md)** - How to integrate skills
- **[validation-checklist.md](references/validation-checklist.md)** - Field-by-field validation
- **[audit-rubric.md](references/audit-rubric.md)** - Quality scoring rubric

## Workflows

Step-by-step processes:

- **[create-new-agent.md](workflows/create-new-agent.md)** - Create agent from scratch
- **[audit-agent.md](workflows/audit-agent.md)** - Audit existing agent
- **[upgrade-agent.md](workflows/upgrade-agent.md)** - Migrate prompt to agent

## Philosophy

> "A great agent is like a skilled specialist:
>
> - Clear about their expertise (description with triggers)
> - Equipped with the right tools (minimal tool config)
> - Careful with dangerous operations (permission patterns)
> - Knows when to consult references (skills integration)
> - Focused on doing one thing well (single responsibility)"

Create agents that are **focused**, **safe**, and **well-documented**.

## Additional Resources

- **OpenCode Docs**: https://opencode.ai/docs/agents/
- **Agent Examples**: Check ~/.config/opencode/agent/
- **Skills Library**: Check ~/.config/opencode/skills/
- **Permission Guide**: https://opencode.ai/docs/permissions/
