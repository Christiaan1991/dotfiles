# Tool Selection Guide for OpenCode Agents

## Overview

Choosing the right tools for your agent is critical for both functionality and safety. This guide helps you select appropriate tools based on agent capabilities and trust level.

## Available Tools in OpenCode

### File System Tools

#### `bash`

**Purpose**: Execute shell commands  
**Risk Level**: HIGH  
**Use When**: Agent needs to run system commands, install packages, manage processes  
**Permissions Required**: `bash: true`

**Capabilities**:

- Execute any shell command
- Modify system state
- Install/remove software
- Manage services
- Network operations

**Safety Considerations**:

- HIGHEST RISK tool - can do anything the user can do
- Only grant to fully trusted agents
- Agent MUST implement safety checks before destructive operations
- Consider read-only alternatives first

**Best For**: sysadmin, devops, build-automation agents

---

#### `read`

**Purpose**: Read file contents  
**Risk Level**: MEDIUM  
**Use When**: Agent needs to examine files without modification  
**Permissions Required**: `read: true`

**Capabilities**:

- Read any file the user can access
- View file contents with line numbers
- Read specific line ranges (offset/limit)
- Access binary files

**Safety Considerations**:

- Can read sensitive files (credentials, private keys, .env files)
- Agent should warn before reading potentially sensitive locations
- Safe for analysis and auditing tasks

**Best For**: code-review, security-audit, documentation-generator agents

---

#### `write`

**Purpose**: Create new files or overwrite existing ones  
**Risk Level**: HIGH  
**Use When**: Agent needs to create files from scratch  
**Permissions Required**: `write: true`

**Capabilities**:

- Create new files
- Completely overwrite existing files
- Write to any user-accessible location

**Safety Considerations**:

- Can destroy existing file contents
- Should REQUIRE read permission first to check if file exists
- Agent MUST warn before overwriting
- Prefer `edit` for modifying existing files

**Best For**: code-generator, scaffolding, template-creator agents

---

#### `edit`

**Purpose**: Make surgical changes to existing files  
**Risk Level**: MEDIUM  
**Use When**: Agent needs to modify existing files precisely  
**Permissions Required**: `edit: true`

**Capabilities**:

- Replace exact text matches
- Preserve file structure and formatting
- Replace all occurrences with `replaceAll`
- Safer than write for modifications

**Safety Considerations**:

- Requires exact string matching - fails if text not found
- Cannot create new files (this is a safety feature)
- Safer than write because changes are explicit

**Best For**: refactoring, bug-fixing, update-automation agents

---

#### `glob`

**Purpose**: Find files by pattern matching  
**Risk Level**: LOW  
**Use When**: Agent needs to locate files by name/pattern  
**Permissions Required**: `glob: true`

**Capabilities**:

- Fast pattern matching (`**/*.js`, `src/**/*.tsx`)
- Returns file paths sorted by modification time
- Works with any codebase size

**Safety Considerations**:

- Read-only operation
- Very safe - only returns file paths
- No ability to modify files

**Best For**: Almost any agent that needs to find files

---

#### `grep`

**Purpose**: Search file contents using regex  
**Risk Level**: LOW  
**Use When**: Agent needs to find files containing specific patterns  
**Permissions Required**: `grep: true`

**Capabilities**:

- Fast content search across entire codebase
- Full regex support
- Filter by file patterns
- Returns file paths and line numbers

**Safety Considerations**:

- Read-only operation
- Very safe - only returns matches
- No ability to modify files

**Best For**: code-search, refactoring-planner, security-scanner agents

---

### Integration Tools

#### `task`

**Purpose**: Delegate complex tasks to specialized sub-agents  
**Risk Level**: VARIES (depends on sub-agent)  
**Use When**: Agent needs to delegate specialized work  
**Permissions Required**: `task: true`

**Capabilities**:

- Launch sub-agents (general, explore, frontend-developer, etc.)
- Parallel task execution
- Stateless or session-based delegation

**Safety Considerations**:

- Sub-agent inherits its own tool permissions
- Risk level depends on which sub-agent is called
- Main agent should validate results from sub-agents

**Best For**: orchestrator, project-manager, complex-workflow agents

---

#### `skill`

**Purpose**: Load specialized knowledge from skill files  
**Risk Level**: NONE  
**Use When**: Agent needs reference documentation or best practices  
**Permissions Required**: `skill: true`

**Capabilities**:

- Load SKILL.md files on-demand
- Access specialized knowledge bases
- Get step-by-step guidance

**Safety Considerations**:

- Completely safe - read-only knowledge access
- No file system or command execution
- Cannot modify anything

**Best For**: ANY agent that needs specialized knowledge

---

#### `webfetch`

**Purpose**: Fetch content from URLs  
**Risk Level**: LOW-MEDIUM  
**Use When**: Agent needs to retrieve web content or documentation  
**Permissions Required**: `webfetch: true`

**Capabilities**:

- Fetch URLs in markdown, text, or HTML format
- Access online documentation
- Retrieve API responses

**Safety Considerations**:

- Read-only operation
- Can access any public URL
- Risk: Could fetch malicious content (agent should validate)
- Risk: Could leak information via URL parameters

**Best For**: documentation-fetcher, api-tester, research agents

---

### Organizational Tools

#### `todowrite`

**Purpose**: Create and manage task lists  
**Risk Level**: NONE  
**Use When**: Agent handles multi-step complex tasks  
**Permissions Required**: `todowrite: true`

**Capabilities**:

- Create structured task lists
- Track task states (pending, in_progress, completed, cancelled)
- Organize complex workflows

**Safety Considerations**:

- Completely safe - only manages todo items
- No file system access
- Cannot execute commands

**Best For**: ANY agent handling 3+ step tasks

---

#### `todoread`

**Purpose**: Read current task list  
**Risk Level**: NONE  
**Use When**: Agent needs to check task status  
**Permissions Required**: `todoread: true`

**Capabilities**:

- View current todo list
- Check task states

**Safety Considerations**:

- Completely safe - read-only
- No side effects

**Best For**: ANY agent using todowrite

---

## Tool Combination Patterns

### Read-Only Analyst Pattern

```yaml
tools:
  read: true
  glob: true
  grep: true
  skill: true
  todoread: true
  todowrite: true
```

**Best For**: code-reviewer, security-auditor, documentation-analyzer  
**Risk Level**: LOW  
**Philosophy**: Can analyze and report, but cannot modify anything

---

### Safe Editor Pattern

```yaml
tools:
  read: true
  edit: true
  glob: true
  grep: true
  skill: true
  todoread: true
  todowrite: true
```

**Best For**: refactoring-agent, bug-fixer, code-updater  
**Risk Level**: MEDIUM  
**Philosophy**: Can make surgical changes to existing files only

---

### Full Developer Pattern

```yaml
tools:
  read: true
  write: true
  edit: true
  glob: true
  grep: true
  skill: true
  todoread: true
  todowrite: true
```

**Best For**: feature-developer, code-generator, scaffolding-agent  
**Risk Level**: MEDIUM-HIGH  
**Philosophy**: Can create and modify files, but no system access

---

### System Administrator Pattern

```yaml
tools:
  bash: true
  read: true
  edit: true
  glob: true
  grep: true
  skill: true
  todoread: true
  todowrite: true
```

**Best For**: sysadmin, devops, package-manager  
**Risk Level**: HIGH  
**Philosophy**: Full system control with safeguards in agent instructions

---

### Orchestrator Pattern

```yaml
tools:
  task: true
  read: true
  glob: true
  grep: true
  skill: true
  todoread: true
  todowrite: true
```

**Best For**: project-manager, multi-task-coordinator  
**Risk Level**: VARIES  
**Philosophy**: Delegates work to specialized agents

---

### Research Pattern

```yaml
tools:
  webfetch: true
  read: true
  glob: true
  grep: true
  skill: true
  todoread: true
  todowrite: true
```

**Best For**: documentation-fetcher, api-researcher, learning-agent  
**Risk Level**: LOW-MEDIUM  
**Philosophy**: Gathers information without modification

---

## Decision Tree

### Start Here: What does your agent need to DO?

```
1. Only analyze/review code?
   → Read-Only Analyst Pattern

2. Fix bugs or refactor existing code?
   → Safe Editor Pattern

3. Generate new features or scaffold projects?
   → Full Developer Pattern

4. Manage system, install packages, run services?
   → System Administrator Pattern

5. Coordinate multiple specialized tasks?
   → Orchestrator Pattern

6. Fetch documentation or research online?
   → Research Pattern
```

## Principle of Least Privilege

**ALWAYS start with the minimum tools needed**, then add more only if necessary.

### Questions to Ask:

1. **Can the agent work with read-only access?**  
   → Start with read, glob, grep only

2. **Does it need to modify existing files?**  
   → Add edit (safer than write)

3. **Does it need to create new files?**  
   → Add write (with safeguards)

4. **Does it need to run system commands?**  
   → Add bash (with STRONG safeguards and confirmation prompts)

5. **Does it need specialized knowledge?**  
   → Add skill (always safe)

6. **Will it handle complex multi-step tasks?**  
   → Add todowrite, todoread (always safe)

## Tool Dependency Chain

Some tools should almost always be granted together:

```
todowrite → todoread (if agent writes todos, it should read them)
write → read (if agent writes files, it should read them first)
edit → read (if agent edits files, it must read them first)
bash → read (system agents need to read config files)
```

## Anti-Patterns

### ❌ DON'T: Grant bash without safety instructions

```yaml
tools:
  bash: true
# MISSING: Agent instructions on safety checks, confirmations, etc.
```

### ✅ DO: Grant bash with comprehensive safeguards

```yaml
tools:
  bash: true
```

```markdown
## Safety Protocols

- ALWAYS ask for confirmation before destructive operations
- NEVER execute rm -rf without explicit user approval
- CHECK disk space before large operations
- VERIFY paths before deletion
```

---

### ❌ DON'T: Grant write without read

```yaml
tools:
  write: true
# MISSING: read permission to check if file exists first
```

### ✅ DO: Grant write with read

```yaml
tools:
  read: true
  write: true
```

---

### ❌ DON'T: Grant all tools "just in case"

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

### ✅ DO: Grant only what's needed

```yaml
tools:
  read: true
  edit: true
  glob: true
  grep: true
  skill: true
```

---

## Testing Tool Configurations

After selecting tools, verify:

1. **Can the agent complete its core tasks?**  
   Test with typical use cases

2. **Is the agent blocked by missing permissions?**  
   Check error messages when running

3. **Can the agent accidentally cause damage?**  
   Think about worst-case scenarios

4. **Are there redundant tools?**  
   Remove tools that aren't actually used

## Progressive Permission Enhancement

Start restrictive, then expand if needed:

**Phase 1: Read-Only**

```yaml
tools:
  read: true
  glob: true
  grep: true
```

**Phase 2: Add Safe Editing** (if analysis isn't enough)

```yaml
tools:
  read: true
  edit: true
  glob: true
  grep: true
```

**Phase 3: Add File Creation** (if editing isn't enough)

```yaml
tools:
  read: true
  write: true
  edit: true
  glob: true
  grep: true
```

**Phase 4: Add System Access** (only if absolutely necessary)

```yaml
tools:
  bash: true
  read: true
  write: true
  edit: true
  glob: true
  grep: true
```

## Summary Checklist

Before finalizing tool selection:

- [ ] Agent has minimum tools needed for core functionality
- [ ] No redundant or unused tools
- [ ] If bash is granted, comprehensive safety instructions included
- [ ] If write is granted, read is also granted
- [ ] If edit is granted, read is also granted
- [ ] If todowrite is granted, todoread is also granted
- [ ] Tool combination matches a proven pattern (or has good justification)
- [ ] Tested with realistic use cases
- [ ] Considered worst-case abuse scenarios
- [ ] Documented why each tool was selected

---

**Remember**: It's easier to grant more permissions later than to recover from accidental damage caused by excessive permissions.
