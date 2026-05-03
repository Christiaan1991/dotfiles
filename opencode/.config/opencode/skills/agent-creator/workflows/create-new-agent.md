# Workflow: Creating a New Agent

This workflow guides you through creating a new OpenCode agent from scratch using the agent-creator skill.

---

## Prerequisites

- [ ] OpenCode installed and configured
- [ ] Understanding of agent purpose and scope
- [ ] List of tasks agent will perform
- [ ] Identified required tools and permissions

---

## Step 1: Define Agent Purpose

### Questions to Answer

1. **What is the agent's primary responsibility?**
   - Examples: Code review, security audit, feature development, system administration

2. **What scope will the agent have?**
   - Single focused task vs. broader capabilities
   - Read-only vs. modification capabilities
   - System access needed?

3. **Who will use this agent?**
   - Developers, system administrators, end users
   - Trust level and experience

4. **What are the success criteria?**
   - What does a successful agent execution look like?
   - What should it never do?

### Document Your Answers

```markdown
Agent Purpose Statement:

- Primary role: [e.g., Security auditor for web applications]
- Scope: [e.g., Read-only analysis of code for security vulnerabilities]
- Users: [e.g., Development team members]
- Success: [e.g., Identifies security issues without false positives]
```

---

## Step 2: Select Agent Type Pattern

Reference: `references/agent-types.md`

Choose the pattern that best matches your agent:

- **Code Reviewer**: Read-only code analysis
- **Security Auditor**: Security vulnerability scanning
- **Documentation Writer**: Generate and maintain docs
- **Refactoring Agent**: Improve existing code
- **Feature Developer**: Build new features
- **System Administrator**: Manage system and services
- **Database Administrator**: Database management
- **Testing Agent**: Create and run tests
- **DevOps Agent**: CI/CD and deployment
- **API Developer**: Build APIs

**Selected Pattern**: `_______________`

**Rationale**: `_______________`

---

## Step 3: Choose Tools and Permissions

Reference: `references/tool-selection.md` and `references/permission-patterns.md`

### Tool Checklist

Mark which tools your agent needs:

- [ ] `read` - Read files
- [ ] `write` - Create new files
- [ ] `edit` - Modify existing files
- [ ] `bash` - Execute system commands
- [ ] `glob` - Find files by pattern
- [ ] `grep` - Search file contents
- [ ] `task` - Delegate to sub-agents
- [ ] `skill` - Load reference documentation
- [ ] `webfetch` - Fetch web content
- [ ] `todoread` - Read task list
- [ ] `todowrite` - Manage task list

### Permission Pattern

Based on your tool selection, which pattern fits best?

- [ ] Read-Only Analyst (read, glob, grep, skill, todo)
- [ ] Safe Editor (read, edit, glob, grep, skill, todo)
- [ ] Full Developer (read, write, edit, glob, grep, skill, todo)
- [ ] System Administrator (bash, read, edit, glob, grep, skill, todo)
- [ ] Orchestrator (task, read, glob, grep, skill, todo)
- [ ] Research (webfetch, read, glob, grep, skill, todo)
- [ ] Custom pattern (specify below)

**Selected Pattern**: `_______________`

### Safety Verification

If `bash` is selected:

- [ ] Agent instructions include confirmation prompts for destructive operations
- [ ] Backup procedures documented
- [ ] Path verification before file operations

If `write` is selected:

- [ ] Agent checks if file exists before overwriting
- [ ] read permission also granted

If `edit` is selected:

- [ ] read permission also granted

---

## Step 4: Select Skills

Reference: `references/skills-integration.md`

### Available Skills

Check which skills are installed:

```bash
ls ~/.config/opencode/skills/
```

### Skill Selection

Which skills will enhance your agent's capabilities?

- [ ] `security-review` - Security best practices
- [ ] `vercel-react-best-practices` - React optimization patterns
- [ ] `web-design-guidelines` - UI/UX best practices
- [ ] `backend-patterns` - API and backend patterns
- [ ] `linux-sysadmin` - Linux system administration
- [ ] `omarchy` - Omarchy Linux configuration
- [ ] Other: `_______________`

> **Note:** Skills are loaded at runtime using the `skill` tool. They are NOT declared
> in agent frontmatter. The agent instructions should tell when to load specific skills.

---

## Step 5: Create Agent File

### Primary Method: Use Write Tool Directly

When working in OpenCode, simply use the Write tool to create:

```
~/.config/opencode/agent/your-agent-name.md
```

### Alternative: Manual Creation

```bash
vim ~/.config/opencode/agent/your-agent-name.md
```

> **Important:** The filename (without .md) becomes the agent name.
> Use kebab-case: `my-agent-name.md` becomes `@my-agent-name`

---

## Step 6: Write Agent Frontmatter

Reference: `references/frontmatter-spec.md`

```yaml
---
description: >-
  What this agent does in 1-2 sentences.

  Use when [trigger conditions like: reviewing code, auditing security, etc.].

  <example>
  User: "Review this endpoint for security issues"
  Assistant: "I'll use the `security-auditor` agent to review it."
  </example>

mode: subagent # or: primary, all

tools:
  read: true
  grep: true
  glob: true
  write: false
  edit: false
  bash: false

permission:
  edit: deny
  write: deny
  bash: deny
---
```

### Frontmatter Checklist

- [ ] `description` includes WHAT it does + WHEN to use + `<example>` blocks
- [ ] `mode` matches usage pattern (primary/subagent/all)
- [ ] `tools` enables only what's needed
- [ ] `permission` controls dangerous tools with patterns
- [ ] YAML syntax is valid (no tabs, proper indentation)

---

## Step 7: Write Agent Instructions

### Instruction Structure Template

```markdown
# Agent Name

## Overview

[1-2 paragraph description of agent purpose and capabilities]

## Core Responsibilities

1. [Primary responsibility]
2. [Secondary responsibility]
3. [Additional responsibilities...]

## Operating Principles

### Context First

Before taking action on any request:

1. **Identify what's missing** - What assumptions am I making? What constraints aren't stated?
2. **Ask targeted questions** - Be specific, prioritize by impact, group related questions
3. **Confirm understanding** - Summarize your understanding before proceeding
4. **Respect overrides** - If user says "just do it" or similar, proceed with reasonable defaults

Never proceed with significant changes based on assumptions alone.

### [Principle Category 1]

- [Guideline 1]
- [Guideline 2]

### [Principle Category 2]

- [Guideline 1]
- [Guideline 2]

## [Process/Workflow Name]

### [Step Category]

1. [Action item]
2. [Action item]

## Tool Usage Guide

### [tool-name]

[When and how to use this tool]

## Example Workflows

### Workflow 1: [Workflow Name]

\`\`\`markdown

1. [Step 1]
2. [Step 2]
3. [Step 3]
   \`\`\`

## Safety Protocols (if bash or write permissions)

- [Safety measure 1]
- [Safety measure 2]

## Limitations

[What this agent CANNOT do]
```

### Instruction Checklist

- [ ] Overview clearly explains agent purpose
- [ ] Core responsibilities are specific and actionable
- [ ] **Context First subsection** included in Operating Principles
- [ ] Operating principles provide guidance for decision-making
- [ ] Process/workflow sections give step-by-step instructions
- [ ] Tool usage guide explains when to use each tool
- [ ] Example workflows show real-world usage
- [ ] Safety protocols included (if high-risk tools granted)
- [ ] Limitations clearly stated

---

## Step 8: Add Safety Protocols (If Needed)

Reference: `references/anti-patterns.md`

### For Agents with `bash` Permission

```markdown
## Safety Protocols

### Before Destructive Operations

- ALWAYS ask user for explicit confirmation
- NEVER run `rm -rf` without verification
- CHECK disk space before large operations
- BACKUP configuration files before editing
- VERIFY paths before operations

### Confirmation Pattern

\`\`\`markdown
I'm about to execute: [command]

This will: [explanation of what it does]

Potential risks: [list risks]

Do you want to proceed? [wait for explicit yes]
\`\`\`
```

### For Agents with `write` Permission

```markdown
## Safety Protocols

### Before Writing Files

- CHECK if file already exists using read tool
- WARN user if about to overwrite existing file
- PREFER edit over write for modifications
- VERIFY file path is correct
```

---

## Step 9: Test the Agent

### Create Test Scenarios

1. **Basic Functionality Test**

   ```markdown
   Scenario: [Simple task agent should handle]
   Expected Behavior: [What agent should do]
   Success Criteria: [How to verify success]
   ```

2. **Edge Case Test**

   ```markdown
   Scenario: [Unusual or edge case]
   Expected Behavior: [How agent should handle it]
   Success Criteria: [Verification method]
   ```

3. **Safety Test** (if applicable)
   ```markdown
   Scenario: [Potentially dangerous operation]
   Expected Behavior: [Agent should ask for confirmation]
   Success Criteria: [Doesn't execute without approval]
   ```

### Execute Tests

```bash
# Select your agent in OpenCode
# Run each test scenario
# Document results
```

### Test Checklist

- [ ] Agent loads successfully
- [ ] Basic functionality works
- [ ] Agent uses correct tools
- [ ] Safety protocols trigger when expected
- [ ] Error handling is appropriate
- [ ] Output is clear and actionable

---

## Step 10: Review Against Best Practices

Reference: `references/anti-patterns.md`

### Anti-Pattern Check

- [ ] Agent doesn't have overly broad permissions
- [ ] Doesn't grant bash without safety protocols
- [ ] Doesn't grant write without read
- [ ] Frontmatter YAML is valid
- [ ] Description is clear and specific
- [ ] Name follows naming conventions
- [ ] Instructions are clear and actionable
- [ ] No contradictory instructions
- [ ] Tool usage is explained
- [ ] Limitations are documented

### Quality Check

- [ ] Agent has single, clear purpose
- [ ] Instructions are organized logically
- [ ] Examples are provided for complex tasks
- [ ] Safety measures are appropriate for risk level
- [ ] Agent can be used by intended audience
- [ ] Documentation is complete

---

## Step 11: Document and Deploy

### Create Agent Documentation

If this agent will be shared, create documentation:

```markdown
# Agent Name

## Purpose

[What this agent does]

## Use Cases

- [Use case 1]
- [Use case 2]

## Prerequisites

- [Requirement 1]
- [Requirement 2]

## Usage Examples

### Example 1: [Task]

\`\`\`markdown
User: [Request]
Agent: [Response and actions]
\`\`\`

## Limitations

[What agent cannot do]

## Safety Considerations

[Important safety notes]
```

### Add to Agent Repository

If sharing publicly:

1. Create git repository
2. Add agent file
3. Add README with usage instructions
4. Add LICENSE file
5. Push to GitHub

### Share with Team

If internal use:

1. Add to team's shared agents directory
2. Document in team wiki
3. Add to onboarding materials

---

## Completion Checklist

- [ ] Agent purpose is clearly defined
- [ ] Agent type pattern selected and applied
- [ ] Tools and permissions are minimal but sufficient
- [ ] Skills are selected and integrated
- [ ] Frontmatter YAML is valid and complete
- [ ] Instructions are clear and comprehensive
- [ ] Safety protocols included (if needed)
- [ ] Agent tested with real scenarios
- [ ] Reviewed against anti-patterns
- [ ] Documentation created
- [ ] Agent deployed and accessible

---

## Common Issues and Solutions

### Issue: Agent doesn't load

**Solutions**:

- Check YAML frontmatter syntax (no tabs, proper indentation)
- Verify file is in `~/.config/opencode/agent/` directory (singular, not agents)
- Ensure file has `.md` extension
- Check for syntax errors in frontmatter
- Verify `description` field exists (required)

### Issue: Agent has permission errors

**Solutions**:

- Verify `tools` section enables required tools
- Check `permission` patterns for bash/edit/write
- Ensure permission names are spelled correctly
- Remember: `tools` enables, `permission` controls

### Issue: Agent behavior is unclear

**Solutions**:

- Add more specific examples
- Clarify operating principles
- Add step-by-step workflows
- Reference relevant skills

### Issue: Agent is too risky

**Solutions**:

- Reduce permissions (especially bash, write)
- Add safety protocols
- Require explicit user confirmation
- Create read-only version first

---

## Next Steps

After creating your agent:

1. **Gather Feedback**: Use the agent and collect feedback
2. **Iterate**: Improve based on real-world usage
3. **Share**: Contribute to agent repositories
4. **Create Skills**: Extract reusable knowledge into skills
5. **Build More**: Create specialized variants

---

**Congratulations!** You've created a new OpenCode agent. Continue refining it based on usage and feedback.
