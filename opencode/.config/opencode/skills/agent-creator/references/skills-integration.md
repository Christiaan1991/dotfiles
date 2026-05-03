# Skills Integration Guide for OpenCode Agents

## Overview

Skills are passive knowledge repositories that agents can load on-demand for specialized guidance. This guide covers how to effectively integrate skills into your agents.

---

## Skills vs Agents: Core Difference

### Skills (Passive Knowledge)

- **Location**: `~/.config/opencode/skills/skill-name/SKILL.md`
- **Purpose**: Provide reference documentation, best practices, step-by-step guides
- **Activation**: Loaded via `skill` tool when agent needs them
- **Characteristics**:
  - No frontmatter YAML
  - No tool permissions
  - Read-only documentation
  - Can include sub-documents in skill directory

### Agents (Active Executors)

- **Location**: `~/.config/opencode/agent/agent-name.md`
- **Purpose**: Execute tasks using tools and permissions
- **Activation**: User selects agent to perform work
- **Characteristics**:
  - Has frontmatter YAML with permissions
  - Can use tools (bash, read, write, etc.)
  - Can load skills for reference
  - Active decision-making and execution

---

## Skill Directory Structure

### Simple Skill (Single File)

```
~/.config/opencode/skills/security-review/
└── SKILL.md
```

### Complex Skill (Multiple Files)

```
~/.config/opencode/skills/agent-creator/
├── SKILL.md                          # Main entry point
├── references/                       # Reference documentation
│   ├── frontmatter-spec.md
│   ├── anti-patterns.md
│   ├── permission-patterns.md
│   ├── tool-selection.md
│   ├── agent-types.md
│   └── skills-integration.md
├── templates/                        # Example templates
│   ├── simple-agent.md
│   ├── security-auditor.md
│   └── doc-writer.md
├── workflows/                        # Step-by-step processes
│   ├── create-new-agent.md
│   ├── audit-agent.md
│   └── upgrade-agent.md
└── scripts/                          # Automation helpers
    ├── init_agent.py
    ├── validate_agent.py
    └── audit_agent.py
```

**Key Points**:

- Agent ALWAYS loads `SKILL.md` first (main entry point)
- `SKILL.md` uses progressive disclosure to reference other files
- Sub-documents organized by purpose (references/, templates/, workflows/, scripts/)

---

## Granting Skill Access to Agents

Skills are loaded at runtime using the `skill` tool. Agents do NOT declare
skills in frontmatter - instead, they use the `skill` tool when they need
reference documentation.

### How Skills Are Loaded

1. Agent encounters a task that needs specialized knowledge
2. Agent uses `skill` tool to load the relevant skill
3. Skill content is added to context
4. Agent uses the knowledge to complete the task

### Agent Configuration for Skills

Enable the skill tool in your agent:

```yaml
---
description: >-
  Security auditor that identifies vulnerabilities.
  Use when reviewing authentication, authorization, or sensitive data handling.

  <example>
  User: "Audit this login endpoint"
  Assistant: "I'll use security-auditor."
  </example>

mode: subagent

tools:
  read: true
  glob: true
  grep: true
  skill: true         # ← Enable skill loading
  todoread: true
  todowrite: true
---

You are a security auditor. When reviewing code, load the `security-review`
skill for best practices guidance.

## When to Load Skills

- Authentication code → Load `security-review`
- React components → Load `vercel-react-best-practices`
- API endpoints → Load `backend-patterns`
- System administration → Load `linux-sysadmin`
```

**Advantages**:

- Agent decides when to load skills (context-aware)
- Only loads what's needed for current task
- Keeps context size manageable
- Flexible - can load any available skill

**When to Use**: When agent has well-defined scope (security auditor, React developer, etc.)

---

## How Agents Use Skills

### Loading a Skill

When agent has `skill: true` in tools:

```markdown
I need to review this authentication code for security issues.
Let me load the security-review skill for guidance.

[Agent uses skill tool to load "security-review"]

According to the security-review skill, I should check for:

1. Hardcoded credentials
2. Weak password hashing
3. Missing input validation
   ...
```

### Progressive Skill Loading

Complex skills use progressive disclosure:

**SKILL.md (Main Entry)**:

```markdown
# Agent Creator Skill

## Quick Start

- [Create New Agent](#creating-agents)
- [Audit Existing Agent](#auditing-agents)

## In-Depth References

For detailed information, see:

- `references/frontmatter-spec.md` - Complete YAML specification
- `references/tool-selection.md` - Choosing the right tools
- `references/agent-types.md` - Common agent patterns
```

**Agent Workflow**:

1. Load `SKILL.md` - Get overview and navigation
2. Based on task, load specific reference file
3. Follow step-by-step process
4. Reference templates for examples

---

## Skill Discovery

### Listing Available Skills

Users can see installed skills:

```bash
ls ~/.config/opencode/skills/
```

### Skill Naming Conventions

Use clear, descriptive names:

✅ **Good Names**:

- `security-review`
- `vercel-react-best-practices`
- `backend-patterns`
- `linux-sysadmin`
- `web-design-guidelines`

❌ **Poor Names**:

- `skill1`
- `my-skill`
- `helper`
- `utils`

---

## Creating Skills for Your Agents

### When to Create a New Skill

Create a skill when:

1. **Reusable knowledge**: Multiple agents would benefit
2. **Reference material**: Best practices, checklists, guidelines
3. **Step-by-step processes**: Complex workflows
4. **Domain expertise**: Specialized knowledge (security, design, etc.)

### When NOT to Create a Skill

Don't create a skill when:

1. **Agent-specific logic**: Put in agent instructions instead
2. **One-time use**: Not reusable across agents
3. **Simple task**: Agent can handle without external reference
4. **Execution logic**: Skills are for knowledge, not execution

---

## Skill Creation Example

### Scenario: Multiple agents need React testing best practices

**Step 1: Create skill directory**

```bash
mkdir -p ~/.config/opencode/skills/react-testing-patterns
```

**Step 2: Create SKILL.md**

```markdown
# React Testing Patterns

## Overview

Best practices for testing React components using Jest and React Testing Library.

## Testing Principles

1. Test user behavior, not implementation details
2. Query by accessibility attributes
3. Avoid testing library internals
4. Keep tests simple and focused

## Common Patterns

### Testing User Interactions

\`\`\`javascript
import { render, screen, fireEvent } from '@testing-library/react';

test('button click updates counter', () => {
render(<Counter />);
const button = screen.getByRole('button', { name: /increment/i });
fireEvent.click(button);
expect(screen.getByText('Count: 1')).toBeInTheDocument();
});
\`\`\`

### Testing Async Operations

\`\`\`javascript
import { render, screen, waitFor } from '@testing-library/react';

test('loads and displays data', async () => {
render(<DataFetcher />);
await waitFor(() => {
expect(screen.getByText(/loaded/i)).toBeInTheDocument();
});
});
\`\`\`

## Anti-Patterns

- ❌ Don't query by class names or IDs
- ❌ Don't test component state directly
- ❌ Don't use `wrapper.instance()`
- ✅ Do query by accessible roles and labels
- ✅ Do test user-visible behavior
```

**Step 3: Reference in agent instructions**

```yaml
---
description: >-
  Creates comprehensive tests for React components.
  Use when asked to write tests for React components.

  <example>
  User: "Write tests for this Button component"
  Assistant: "I'll use react-test-writer."
  </example>

mode: subagent

tools:
  bash: true
  read: true
  write: true
  glob: true
  grep: true
  skill: true
  todoread: true
  todowrite: true

permission:
  bash:
    "*": ask
    "npm test*": allow
    "npx jest*": allow
---

You are a React testing expert.

## When to Load Skills

When writing React tests, load these skills:
- `react-testing-patterns` - Testing best practices
- `vercel-react-best-practices` - Component patterns
```

---

## Skill Composition Patterns

### Pattern 1: Layered Skills

Agent instructions direct loading complementary skills:

```markdown
## When to Load Skills

For backend API development:

- `security-review` - Security best practices
- `backend-patterns` - API design patterns

For database operations:

- `backend-patterns` - Query patterns
```

**Use Case**: Backend API developer that needs security, design, and performance knowledge

---

### Pattern 2: Specialized + General

Combine specific and general knowledge:

```markdown
## When to Load Skills

For React testing tasks:

- `react-testing-patterns` - Testing specifics
- `vercel-react-best-practices` - General React patterns
```

**Use Case**: React testing agent that needs both general React knowledge and testing specifics

---

### Pattern 3: Workflow + Reference

Combine process with reference material:

```markdown
## When to Load Skills

When creating agents:

- Load `agent-creator` skill for workflow and templates

When the agent handles security:

- Also load `security-review` for security patterns
```

**Use Case**: Creating a security-focused agent using agent-creator workflow

---

## Skill Maintenance

### Updating Skills

Skills are documentation, so update them when:

- Best practices change
- New patterns emerge
- Frameworks release new versions
- User feedback identifies gaps

**Update Process**:

```bash
# Edit the skill
vim ~/.config/opencode/skills/skill-name/SKILL.md

# No need to restart OpenCode - skills load on-demand
```

---

### Versioning Skills

For major changes, consider versioning:

```
~/.config/opencode/skills/
├── react-best-practices/         # Latest
├── react-best-practices-v17/     # React 17 specific
└── react-best-practices-v18/     # React 18 specific
```

---

## Installing Community Skills

### From GitHub

Many developers share skills on GitHub:

```bash
# Clone skill repository
cd /tmp
git clone https://github.com/username/skill-repo

# Copy to OpenCode skills directory
cp -r skill-repo/skill-name ~/.config/opencode/skills/

# Verify installation
ls ~/.config/opencode/skills/skill-name/SKILL.md
```

### Popular Skill Repositories

1. **ComposioHQ/awesome-claude-skills**
   - Large collection of general skills
   - Skills.sh compatible format

2. **affaan-m/everything-claude-code**
   - `backend-patterns`
   - `security-review`

3. **vercel-labs/agent-skills**
   - `react-best-practices`
   - `web-design-guidelines`

4. **robzolkos/omarchy-skill**
   - `omarchy` (Linux system configuration)

---

## Skill Loading Performance

### Optimization Tips

1. **Load skills only when needed**

   Agent instructions should specify WHEN to load each skill:

   ```markdown
   ## When to Load Skills

   - Authentication code → Load `security-review`
   - React components → Load `vercel-react-best-practices`
   - API endpoints → Load `backend-patterns`
   ```

   This is more efficient than loading everything upfront.

2. **Keep SKILL.md under 500 lines**
   - Use progressive disclosure
   - Link to reference files for details
   - Agent loads SKILL.md first, then references as needed

3. **Organize complex skills into sections**
   ```
   references/     # Loaded on-demand
   templates/      # Loaded when creating
   workflows/      # Loaded when following process
   ```

---

## Debugging Skill Loading

### Skill Not Found

**Error**: "Skill 'xyz' not found"

**Solutions**:

1. Check skill directory exists:

   ```bash
   ls ~/.config/opencode/skills/xyz/
   ```

2. Verify SKILL.md exists:

   ```bash
   cat ~/.config/opencode/skills/xyz/SKILL.md
   ```

3. Check skill name spelling when using the `skill` tool

---

### Skill Permission Denied

**Error**: Agent can't load skill

**Solutions**:

1. Verify agent has `skill: true` in tools:

   ```yaml
   tools:
     skill: true
   ```

2. Check file permission:
   ```bash
   ls -la ~/.config/opencode/skills/skill-name/
   ```

---

## Skill Best Practices Summary

### DO ✅

- Keep SKILL.md as navigation hub (< 500 lines)
- Use progressive disclosure for complex skills
- Name skills descriptively
- Enable `skill: true` in agent tools
- Include examples and code snippets
- Update skills when best practices change
- Organize complex skills with subdirectories
- Document WHEN to load each skill in agent instructions

### DON'T ❌

- Put agent execution logic in skills
- Create skills for one-time use
- Load all skills for every task
- Create massive single-file skills (> 1000 lines)
- Duplicate content across skills
- Forget to document skill purpose
- Use generic skill names

---

## Example: Agent Using Multiple Skills

### Agent Definition

```yaml
---
description: >-
  Develops secure REST APIs with proper validation and auth.
  Follows security best practices for authentication and data handling.

  Use when creating API endpoints that handle sensitive data or require auth.

  <example>
  User: "Create a user registration endpoint"
  Assistant: "I'll use `secure-api-developer` to build this securely."
  </example>

mode: subagent

tools:
  bash: true
  read: true
  write: true
  edit: true
  glob: true
  grep: true
  skill: true
  todoread: true
  todowrite: true

permission:
  bash:
    "*": ask
    "curl *": allow
    "npm test*": allow
---

# Secure API Developer Agent

## Core Responsibilities
1. Design RESTful API endpoints following best practices
2. Implement authentication and authorization
3. Add input validation and sanitization
4. Ensure security compliance

## When to Load Skills

Load skills at runtime based on the task:
- API design questions → Load `backend-patterns`
- Security concerns → Load `security-review`
- Both for auth endpoints → Load both skills

## Development Process
1. Analyze requirements
2. Load `backend-patterns` skill for API design guidance
3. Load `security-review` skill for security checklist
4. Design endpoint with proper HTTP methods and status codes
5. Implement authentication middleware
6. Add input validation
7. Test for common vulnerabilities
```

### Agent Workflow

```markdown
User: "Create a user registration endpoint"

Agent: Let me create a secure user registration endpoint.
I'll reference backend-patterns for API design and
security-review for security requirements.

[Loads backend-patterns skill]

- API design: POST /api/users
- Return 201 Created on success
- Include Location header

[Loads security-review skill]

- Validate email format
- Hash password with bcrypt
- Check for SQL injection
- Implement rate limiting
- Return sanitized user data (no password)

[Creates implementation following both skills]
```

---

## Checklist: Adding Skills to Agent

- [ ] Agent has `skill: true` in tools configuration
- [ ] Skills are installed in `~/.config/opencode/skills/`
- [ ] Agent instructions document WHEN to load each skill
- [ ] Skill names match directory names exactly
- [ ] SKILL.md exists in each skill directory
- [ ] Skills are complementary, not redundant

---

**Remember**: Skills are your agent's knowledge base. Agents are the executors.
Skills are loaded at runtime using the `skill` tool - NOT declared in frontmatter.
