# Permission Patterns Library

Reusable permission configurations for common agent types.

## Bash Permission Patterns

### Pattern: Safe by Default

Safest approach - ask for everything, allow only safe commands.

```yaml
permission:
  bash:
    "*": ask # Ask for all by default
    "ls *": allow # Safe: list files
    "cat *": allow # Safe: read files
    "grep *": allow # Safe: search
    "git status*": allow # Safe: check git status
    "git log*": allow # Safe: view history
    "git diff*": allow # Safe: view changes
```

**Use for:** General-purpose agents, untrusted contexts

---

### Pattern: Deny Dangerous

Explicitly block destructive operations.

```yaml
permission:
  bash:
    "*": ask
    "rm *": deny # Never allow rm
    "sudo rm *": deny
    "dd *": deny # Never allow dd
    "mkfs*": deny # Never allow mkfs
    "> *": deny # Never allow redirect overwrite
    "chmod 777 *": deny # Never allow 777
```

**Use for:** Production agents, safety-critical contexts

---

### Pattern: Database Operations

Control database commands with precision.

```yaml
permission:
  bash:
    "*": ask
    # PostgreSQL
    "psql -c 'SELECT*": allow # Safe: read queries
    "psql -c 'EXPLAIN*": allow # Safe: query plans
    "psql -c 'INSERT*": ask # Ask: write data
    "psql -c 'UPDATE*": ask # Ask: modify data
    "psql -c 'DELETE*": ask # Ask: remove data
    "psql -c 'DROP*": deny # Deny: destroy schema
    "psql -c 'TRUNCATE*": deny # Deny: destroy data
    # MySQL
    "mysql -e 'SELECT*": allow
    "mysql -e 'DROP*": deny
```

**Use for:** Database admin agents

---

### Pattern: Git Operations

Safe git usage with deploy protection.

```yaml
permission:
  bash:
    "*": ask
    # Safe read operations
    "git status*": allow
    "git log*": allow
    "git diff*": allow
    "git show*": allow
    "git branch*": allow
    # Ask for write operations
    "git add*": ask
    "git commit*": ask
    "git checkout*": ask
    "git merge*": ask
    # Deny dangerous operations
    "git push --force*": deny
    "git push origin main": deny
    "git push origin master": deny
    "git reset --hard*": deny
```

**Use for:** Development agents with git access

---

### Pattern: System Monitoring

Read-only system inspection.

```yaml
permission:
  bash:
    "*": ask
    # Disk
    "df *": allow
    "du *": allow
    "lsblk*": allow
    # Memory/CPU
    "free *": allow
    "top*": allow
    "htop*": allow
    "ps *": allow
    # Services
    "systemctl status *": allow
    "journalctl *": allow
    # Network
    "ip addr*": allow
    "ss *": allow
    "netstat *": allow
    # No modifications
    "systemctl start *": deny
    "systemctl stop *": deny
    "systemctl restart *": deny
```

**Use for:** Monitoring agents, system status checkers

---

### Pattern: Package Management

Controlled software installation.

```yaml
permission:
  bash:
    "*": ask
    # Safe: check for updates
    "apt update": allow
    "apt list --upgradable": allow
    "apt search *": allow
    "apt show *": allow
    # Ask: install/remove
    "apt install *": ask
    "apt upgrade*": ask
    "apt remove *": ask
    # Similar for other package managers
    "dnf check-update": allow
    "dnf install *": ask
    "pacman -Syu*": ask
```

**Use for:** System admin agents

---

## Edit/Write Permission Patterns

### Pattern: Always Confirm

Safest for file modifications.

```yaml
permission:
  edit: ask
  write: ask
```

**Use for:** Most agents, especially when first deploying

---

### Pattern: Trusted Agent

Auto-allow for well-tested agents.

```yaml
permission:
  edit: allow
  write: allow
```

**Use for:** Mature, well-tested agents in safe environments

---

### Pattern: Read-Only

No file modifications allowed.

```yaml
permission:
  edit: deny
  write: deny
```

**Use for:** Code reviewers, auditors, analyzers

---

## Skill Permission Patterns

### Pattern: Open Access

Allow loading any skill.

```yaml
permission:
  skill:
    "*": allow
```

**Use for:** General-purpose agents

---

### Pattern: Controlled Skills

Review experimental skills before loading.

```yaml
permission:
  skill:
    "*": allow
    "experimental-*": ask
    "internal-*": deny
```

**Use for:** Production agents

---

### Pattern: Curated Skills

Only specific skills allowed.

```yaml
permission:
  skill:
    "*": deny
    "security-review": allow
    "backend-patterns": allow
    "linux-sysadmin": allow
```

**Use for:** Specialized agents with narrow focus

---

## Task (Subagent) Permission Patterns

### Pattern: No Subagents

Agent works alone.

```yaml
permission:
  task:
    "*": deny
```

**Use for:** Simple agents, leaf nodes in agent hierarchy

---

### Pattern: Controlled Delegation

Specific subagents only.

```yaml
permission:
  task:
    "*": deny
    "explore": allow
    "code-reviewer": ask
    "security-auditor": ask
```

**Use for:** Orchestrator agents

---

### Pattern: Full Delegation

Can spawn any subagent.

```yaml
permission:
  task:
    "*": allow
```

**Use for:** High-level orchestrators, complex workflows

---

## Combined Patterns

### Security Auditor

Read-only analysis, can fetch security docs.

```yaml
tools:
  read: true
  grep: true
  glob: true
  webfetch: true
  write: false
  edit: false
  bash: false

permission:
  webfetch: allow
  skill:
    "security-review": allow
    "backend-patterns": allow
```

---

### System Administrator

Controlled bash, confirm modifications.

```yaml
tools:
  read: true
  write: true
  bash: true
  webfetch: true

permission:
  bash:
    "*": ask
    "sudo *": ask
    "ls *": allow
    "cat *": allow
    "git status*": allow
    "rm *": deny
    "dd *": deny
  write: ask
  skill:
    "linux-sysadmin": allow
    "security-review": allow
```

---

### Documentation Writer

File operations, web research, no code execution.

```yaml
tools:
  read: true
  write: true
  edit: true
  webfetch: true
  bash: false

permission:
  write: ask
  edit: ask
  webfetch: allow
  skill:
    "*": allow
```

---

### Code Reviewer

Read-only analysis, load relevant skills.

```yaml
tools:
  read: true
  grep: true
  glob: true
  write: false
  edit: false
  bash: false

permission:
  skill:
    "react-best-practices": allow
    "security-review": allow
    "backend-patterns": allow
```

---

### Database Administrator

Database operations with safety controls.

```yaml
tools:
  read: true
  write: true
  bash: true

permission:
  bash:
    "*": ask
    "psql -c 'SELECT*": allow
    "psql -c 'DROP*": deny
    "psql -c 'TRUNCATE*": deny
  write: ask
```

---

## Permission Decision Tree

```
Does agent modify files?
├─ No  → edit: deny, write: deny
└─ Yes → edit: ask, write: ask (or allow if trusted)

Does agent execute commands?
├─ No  → bash: false
└─ Yes → bash: true + patterns
         ├─ Safe commands → allow
         ├─ Destructive commands → deny
         └─ Others → ask

Does agent need web access?
├─ No  → webfetch: false
└─ Yes → webfetch: ask (or allow if safe)

Does agent load skills?
├─ All skills → skill: {"*": "allow"}
├─ Specific skills → skill: {"skill-name": "allow", "*": "deny"}
└─ No skills → skill: false

Does agent spawn subagents?
├─ Never → task: {"*": "deny"}
├─ Specific → task: {"subagent-name": "allow", "*": "deny"}
└─ Freely → task: {"*": "allow"}
```

---

## Validation Checklist

Before deploying, verify:

- [ ] Bash enabled? → Permissions configured with patterns
- [ ] Edit/write enabled? → Permission level set (ask/allow/deny)
- [ ] Destructive commands? → Explicitly denied
- [ ] Safe commands? → Can be allowed
- [ ] Task permissions? → Match agent's orchestration needs
- [ ] Skill permissions? → Match agent's knowledge needs

---

## Testing Permissions

After configuring permissions, test:

1. **Trigger allowed operations** - Should execute without asking
2. **Trigger ask operations** - Should prompt for approval
3. **Trigger denied operations** - Should reject with clear message
4. **Test edge cases** - Verify pattern matching works correctly

Example test sequence for bash permission:

```bash
@my-agent run ls -la          # Should allow (if configured)
@my-agent run git status      # Should allow (if configured)
@my-agent run rm test.txt     # Should deny (if configured)
@my-agent run sudo apt update # Should ask (if configured)
```

---

## Common Mistakes

1. ❌ `bash: allow` without patterns → Too permissive
2. ❌ Not denying rm/dd/mkfs → Dangerous
3. ❌ Forgetting sudo in patterns → sudo bypasses
4. ❌ Using `"*"` as last rule → Overrides specific rules
5. ❌ No permission config when tool enabled → Defaults may be wrong

✅ Always use patterns for bash
✅ Explicitly deny dangerous commands
✅ Cover both command and `sudo command`
✅ Put `"*"` first, specific rules after
✅ Document permission strategy in agent prompt
