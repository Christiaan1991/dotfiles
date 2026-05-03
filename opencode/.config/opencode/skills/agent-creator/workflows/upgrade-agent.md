# Workflow: Upgrading Legacy Agents

This workflow guides you through upgrading legacy OpenCode agents (prompt-only or basic agents) to modern, full-featured agents with proper frontmatter, skills integration, and best practices.

---

## Agent Upgrade Scenarios

### Scenario 1: Prompt-Only Agent (No Frontmatter)

**Current State**: Agent has instructions but no YAML frontmatter  
**Goal**: Add complete frontmatter configuration

### Scenario 2: Minimal Agent

**Current State**: Agent has basic frontmatter but missing skills, safety protocols  
**Goal**: Enhance with skills, better permissions, safety measures

### Scenario 3: Over-Permissioned Agent

**Current State**: Agent has unnecessary permissions (kitchen sink pattern)  
**Goal**: Reduce to minimum required permissions

### Scenario 4: Unclear Agent

**Current State**: Agent purpose unclear, instructions vague  
**Goal**: Clarify purpose, improve documentation

---

## Upgrade Process

### Phase 1: Analyze Current Agent

#### Step 1: Read Current Agent

```bash
cat ~/.config/opencode/agent/agent-name.md
```

**Document Current State:**

```markdown
**Agent Name**: [name]
**Has Frontmatter**: [yes/no]
**Current Permissions**: [list or "none defined"]
**Current Skills**: [list or "none defined"]
**Instruction Quality**: [good/fair/poor]
**Issues Identified**:

- [Issue 1]
- [Issue 2]
```

---

#### Step 2: Identify Agent Purpose

**Questions to Answer:**

1. What does this agent actually do?
2. What tasks does it perform?
3. Who uses it and why?
4. What tools does it need to accomplish its goals?

**Document Agent Purpose:**

```markdown
**Primary Purpose**: [e.g., "Reviews code for security vulnerabilities"]
**Secondary Purposes**: [e.g., "Suggests improvements, generates reports"]
**Target Users**: [e.g., "Development team"]
**Core Functionality**: [e.g., "Read-only code analysis"]
```

---

#### Step 3: Determine Required Permissions

Reference: `references/tool-selection.md`

**Based on agent purpose, what tools are needed?**

**Analysis:**

```markdown
**Current Permissions**:
[List current permissions or "none"]

**Actually Needed**:

- read: [yes/no] - [reason]
- write: [yes/no] - [reason]
- edit: [yes/no] - [reason]
- bash: [yes/no] - [reason]
- glob: [yes/no] - [reason]
- grep: [yes/no] - [reason]
- task: [yes/no] - [reason]
- skill: [yes/no] - [reason]
- webfetch: [yes/no] - [reason]
- todoread: [yes/no] - [reason]
- todowrite: [yes/no] - [reason]

**Permission Changes Needed**:

- Add: [list tools to add]
- Remove: [list tools to remove]
- Keep: [list tools to keep]
```

---

### Phase 2: Design Upgrade

#### Step 4: Select Agent Pattern

Reference: `references/agent-types.md`

**Which pattern matches this agent?**

- [ ] Code Reviewer
- [ ] Security Auditor
- [ ] Documentation Writer
- [ ] Refactoring Agent
- [ ] Feature Developer
- [ ] System Administrator
- [ ] Database Administrator
- [ ] Testing Agent
- [ ] DevOps Agent
- [ ] API Developer
- [ ] Custom (describe below)

**Selected Pattern**: `_______________`

**Pattern Resources to Reference**:

- Template: `templates/[pattern-name].md`
- Permission Pattern: `references/permission-patterns.md`

---

#### Step 5: Choose Skills

Reference: `references/skills-integration.md`

**Available Skills:**

```bash
ls ~/.config/opencode/skills/
```

> **Note:** Skills are loaded at runtime, not declared in frontmatter.
> Document which skills the agent should load in its instructions.

**Skill Selection:**

```markdown
**Agent Domain**: [e.g., "web security"]

**Relevant Skills to document in instructions**:

- [ ] security-review - [relevant because...]
- [ ] vercel-react-best-practices - [relevant because...]
- [ ] backend-patterns - [relevant because...]
- [ ] linux-sysadmin - [relevant because...]
- [ ] other: **\*\***\_\_\_**\*\***
```

---

#### Step 6: Plan Safety Enhancements

Reference: `references/anti-patterns.md`

**If agent will have `bash` tool enabled:**

```markdown
**Permission Patterns to Add**:
permission:
bash:
"_": ask
"safe-command_": allow
"dangerous-command\*": deny

**Safety Protocols for Instructions**:

- [ ] Confirmation prompts before destructive operations
- [ ] Path verification before file operations
- [ ] Disk space checks before large operations
- [ ] Backup procedures documentation
- [ ] Rollback procedures documentation
```

**If agent will have `write` tool enabled:**

```markdown
**Safety Protocols to Add**:

- [ ] File existence checks before overwriting
- [ ] Warning before overwriting existing files
- [ ] Prefer edit over write where possible
```

---

### Phase 3: Create Upgrade

#### Step 7: Backup Original Agent

```bash
cp ~/.config/opencode/agent/agent-name.md \
   ~/.config/opencode/agent/agent-name.md.backup
```

**Backup Verification:**

- [ ] Backup file created
- [ ] Backup contains original content
- [ ] Backup timestamp: `_______________`

---

#### Step 8: Add or Update Frontmatter

Reference: `references/frontmatter-spec.md`

**For Prompt-Only Agents (No Frontmatter):**

Add frontmatter at the very beginning of the file:

```yaml
---
description: >-
  Clear description of what agent does.

  Use when [trigger conditions].

  <example>
  User: "Typical request"
  Assistant: "I'll use agent-name."
  </example>

mode: all # or: primary, subagent

tools:
  read: true
  glob: true
  grep: true

permission:
  bash: deny
  write: deny
---
# Agent Name

[Rest of existing content...]
```

**For Agents with Existing Frontmatter:**

Update to the correct OpenCode format:

```yaml
---
description: >- # ← Add triggers and examples
  Better description here.
  Use when [triggers].
  <example>...</example>

mode: subagent # ← Set appropriate mode

tools: # ← Replaces old 'permissions'
  read: true
  edit: true
  glob: true
  grep: true

permission: # ← Add for dangerous tools
  bash:
    "*": ask
    "safe-cmd*": allow
---
```

> **Note:** Old format fields like `name`, `skills`, `permissions` are deprecated.
> Use `description`, `mode`, `tools`, and `permission` instead.

---

#### Step 9: Reorganize Instructions

Reference: `workflows/create-new-agent.md` for structure

**Standard Agent Structure:**

```markdown
---
[frontmatter here]
---

# Agent Name

## Overview

[What this agent does - 1-2 paragraphs]

## Core Responsibilities

1. [Responsibility 1]
2. [Responsibility 2]
3. [Responsibility 3]

## Operating Principles

### [Category 1]

- [Principle 1]
- [Principle 2]

### [Category 2]

- [Principle 1]
- [Principle 2]

## [Process/Workflow Name]

### [Step Category]

1. [Step 1]
2. [Step 2]

## Tool Usage Guide

### [tool-name]

[When and how to use this tool]

## Example Workflows

### Workflow 1: [Name]

\`\`\`markdown

1. [Step 1]
2. [Step 2]
   \`\`\`

## Safety Protocols

[If bash or write permissions]

## Limitations

[What this agent CANNOT do]
```

**Reorganization Checklist:**

- [ ] Added clear Overview section
- [ ] Listed Core Responsibilities
- [ ] Defined Operating Principles
- [ ] Documented processes/workflows
- [ ] Added Tool Usage Guide
- [ ] Included Example Workflows
- [ ] Added Safety Protocols (if needed)
- [ ] Documented Limitations

---

#### Step 10: Add Missing Sections

**Common Missing Sections:**

**1. Tool Usage Guide**

```markdown
## Tool Usage Guide

### read

Use to examine:

- [Example 1]
- [Example 2]

### glob

Use to find:

- `**/*.js` - [What this finds]
- `src/**/*.tsx` - [What this finds]

### grep

Use to search for:

- [Pattern 1] - [What it finds]
- [Pattern 2] - [What it finds]
```

**2. Example Workflows**

```markdown
## Example Workflows

### Workflow 1: [Common Task]

\`\`\`markdown

1. [Step with specific action]
2. [Step with specific action]
3. [Step with specific action]
4. [Expected result]
   \`\`\`

### Workflow 2: [Another Common Task]

\`\`\`markdown

1. [Step]
2. [Step]
3. [Result]
   \`\`\`
```

**3. Safety Protocols** (if bash or write)

```markdown
## Safety Protocols

### Before Destructive Operations

- ALWAYS ask for explicit confirmation
- VERIFY paths before operations
- CHECK disk space before large operations
- BACKUP files before modifications

### Confirmation Pattern

\`\`\`
I'm about to execute: [command]
This will: [explanation]
Potential risks: [risks]
Proceed? [wait for yes]
\`\`\`
```

**4. Limitations**

```markdown
## Limitations

This agent **CANNOT**:

- [Limitation 1]
- [Limitation 2]
- [Limitation 3]

For these tasks, use:

- [Alternative agent or approach]
```

---

### Phase 4: Validate Upgrade

#### Step 11: Syntax Validation

**Manual Check:**

```bash
# Check YAML frontmatter syntax
cat ~/.config/opencode/agent/agent-name.md | head -20
```

**Validation Checklist:**

- [ ] Opening `---` present
- [ ] Closing `---` present
- [ ] No tabs in YAML (spaces only)
- [ ] Proper indentation (2 spaces)
- [ ] Boolean values are `true/false` (not `yes/no`)
- [ ] Skills array uses `-` prefix
- [ ] Permissions use boolean values

**Automated Check** (if available):

```bash
cd ~/.config/opencode/skills/agent-creator/scripts
python3 validate_agent.py ~/.config/opencode/agent/agent-name.md
```

---

#### Step 12: Test Upgraded Agent

**Test Scenarios:**

**Test 1: Basic Functionality**

```markdown
Task: [Simple task agent should handle]
Expected: [What should happen]
Result: [What actually happened]
Pass/Fail: [Pass/Fail]
```

**Test 2: Tool Usage**

```markdown
Task: [Task requiring specific tool]
Expected: [Agent uses correct tool]
Result: [Agent behavior]
Pass/Fail: [Pass/Fail]
```

**Test 3: Safety Protocols** (if applicable)

```markdown
Task: [Potentially risky operation]
Expected: [Agent asks for confirmation]
Result: [Agent behavior]
Pass/Fail: [Pass/Fail]
```

**Test Results:**

- [ ] All tests passed
- [ ] Some tests failed (document issues below)
- [ ] Major issues found (revert and redesign)

**Issues Found:**

- [Issue 1]
- [Issue 2]

---

#### Step 13: Compare Before/After

**Comparison Matrix:**

| Aspect           | Before    | After     | Improvement         |
| ---------------- | --------- | --------- | ------------------- |
| Has Frontmatter  | No/Yes    | Yes       | ✓/-                 |
| Permissions      | [list]    | [list]    | [Better/Worse/Same] |
| Skills           | [list]    | [list]    | [Better/Worse/Same] |
| Safety Protocols | [yes/no]  | Yes       | ✓/-                 |
| Documentation    | [quality] | [quality] | [Better/Same]       |
| Structure        | [quality] | Good      | ✓                   |

**Overall Improvement**: [Significant / Moderate / Minimal]

---

### Phase 5: Deploy and Monitor

#### Step 14: Deploy Upgraded Agent

**Deployment:**

```bash
# Upgraded agent is already in place
# Original backed up to agent-name.md.backup
```

**Verification:**

- [ ] Agent loads in OpenCode
- [ ] No syntax errors
- [ ] Permissions work as expected
- [ ] Skills load correctly

---

#### Step 15: Document Changes

**Create Change Log:**

```markdown
# Agent Upgrade Log: [agent-name]

**Upgrade Date**: [date]
**Upgraded By**: [name]
**Version**: [old version] → [new version]

## Changes Made

### Frontmatter

- Added: [what was added]
- Removed: [what was removed]
- Modified: [what was changed]

### Permissions

- Added: [permissions added]
- Removed: [permissions removed]
- Reason: [why changes were made]

### Skills

- Added: [skills added]
- Reason: [why needed]

### Instructions

- Added sections: [list]
- Improved sections: [list]
- Removed sections: [list]

### Safety Enhancements

- [Enhancement 1]
- [Enhancement 2]

## Testing Results

- [Test 1]: Pass/Fail
- [Test 2]: Pass/Fail

## Known Issues

- [Issue 1 if any]

## Rollback Procedure

If issues arise:
\`\`\`bash
cp ~/.config/opencode/agent/agent-name.md.backup \
 ~/.config/opencode/agent/agent-name.md
\`\`\`

## Next Steps

- [ ] Monitor usage for issues
- [ ] Gather user feedback
- [ ] Further refinements if needed
```

---

#### Step 16: Monitor and Iterate

**Monitoring Plan:**

```markdown
**Week 1**: Daily check

- Verify agent works as expected
- Collect user feedback
- Fix critical issues immediately

**Week 2-4**: Weekly check

- Review any reported issues
- Assess if improvements needed
- Plan future enhancements

**Ongoing**: Monthly review

- Check if skills need updates
- Verify permissions still appropriate
- Update documentation as needed
```

---

## Common Upgrade Scenarios

### Scenario 1: Adding Frontmatter to Prompt-Only Agent

**Before:**

```markdown
# My Agent

This agent does XYZ...

## How to Use

...
```

**After:**

```yaml
---
description: >-
  Does XYZ tasks with specific focus on ABC.

  Use when [trigger conditions].

  <example>
  User: "Do XYZ"
  Assistant: "I'll use my-agent."
  </example>

mode: all

tools:
  read: true
  glob: true
  grep: true
  skill: true
---

# My Agent

This agent does XYZ...

## When to Load Skills

- For [task type 1] → Load `relevant-skill`

## How to Use
...
```

---

### Scenario 2: Reducing Over-Permissions

**Before:**

```yaml
tools:
  bash: true
  read: true
  write: true
  edit: true
  glob: true
  grep: true
  task: true
  skill: true
  webfetch: true
  todoread: true
  todowrite: true
```

**After** (for read-only analyst):

```yaml
tools:
  read: true
  glob: true
  grep: true
  skill: true
  todoread: true
  todowrite: true
```

---

### Scenario 3: Adding Skills Integration

> **Note:** Skills are loaded at runtime using the `skill` tool, not declared in frontmatter.
> Document when to load skills in the agent's instructions.

**Before:**

```markdown
# Agent without skill guidance

## Responsibilities

...
```

**After:**

```markdown
# Agent with skill guidance

## Responsibilities

...

## When to Load Skills

Load skills at runtime based on the task:

- Security reviews → Load `security-review`
- API design → Load `backend-patterns`
- React components → Load `vercel-react-best-practices`
```

---

### Scenario 4: Adding Safety Protocols

**Before:**

```yaml
tools:
  bash: true
  # No permission controls
```

**After:**

```yaml
tools:
  bash: true

permission:
  bash:
    "*": ask
    "ls *": allow
    "cat *": allow
    "rm -rf *": deny
```

And in the instructions:

## Safety Protocols

### Before Destructive Operations

- ALWAYS ask user for explicit confirmation
- VERIFY paths before deletion
- CHECK disk space before large operations
- NEVER run `rm -rf` without verification

### Confirmation Pattern

Before executing risky commands, present:

- Command to be executed
- What it will do
- Potential risks
- Request explicit approval

````

---

## Troubleshooting Upgrades

### Issue: YAML Syntax Error

**Symptoms**: Agent won't load, YAML parsing error

**Common Causes**:
- Tabs instead of spaces
- Missing closing `---`
- Incorrect indentation
- `yes/no` instead of `true/false`

**Solution**:
```bash
# Validate YAML
python3 -c "import yaml; yaml.safe_load(open('agent-name.md'))"
````

---

### Issue: Agent Behavior Changed

**Symptoms**: Agent does things differently after upgrade

**Possible Causes**:

- Permissions changed
- Skills affecting behavior
- Instructions conflicting with permissions

**Solution**:

- Review permission changes
- Check skill integration
- Test with simpler tasks first

---

### Issue: Permission Denied Errors

**Symptoms**: Agent can't perform operations it could before

**Cause**: Permissions too restrictive

**Solution**:

- Review needed permissions
- Add back necessary permissions
- Verify permissions in frontmatter

---

## Rollback Procedure

If upgrade causes issues:

```bash
# Restore original agent
cp ~/.config/opencode/agent/agent-name.md.backup \
   ~/.config/opencode/agent/agent-name.md

# Verify restoration
cat ~/.config/opencode/agent/agent-name.md | head -20
```

---

## Post-Upgrade Checklist

- [ ] Frontmatter added/updated
- [ ] Permissions optimized
- [ ] Skills integrated
- [ ] Safety protocols added (if needed)
- [ ] Documentation improved
- [ ] Structure organized
- [ ] Validation passed
- [ ] Testing completed
- [ ] Original backed up
- [ ] Changes documented
- [ ] Monitoring plan in place

---

## Success Criteria

An upgrade is successful when:

1. **Functionality Preserved**: Agent still performs core tasks
2. **Safety Improved**: Better safeguards for risky operations
3. **Clarity Enhanced**: Purpose and usage are clearer
4. **Maintainability Better**: Easier to understand and update
5. **Best Practices Followed**: Adheres to patterns and conventions

---

**Upgrading agents ensures they remain secure, maintainable, and aligned with best practices as the project evolves.**
