# Workflow: Auditing an Existing Agent

This workflow guides you through auditing an existing OpenCode agent for quality, security, and best practices compliance.

---

## Audit Types

### Quick Audit (5-10 minutes)

- Frontmatter validation
- Permission check
- Basic anti-pattern scan

### Comprehensive Audit (20-30 minutes)

- Full quality review
- Security assessment
- Performance optimization
- Documentation completeness

### Security-Focused Audit (15-20 minutes)

- Permission safety
- Sensitive operation handling
- Input validation
- Error handling

---

## Quick Audit Checklist

### 1. Frontmatter Validation

```yaml
---
description: >-
  What this agent does. Use when [triggers].

  <example>
  User: "Request"
  Assistant: "I'll use agent X."
  </example>

mode: subagent # or: primary, all

tools:
  read: true
  grep: true
  glob: true

permission:
  bash: deny
  write: deny
---
```

**Check:**

- [ ] YAML syntax is valid (no tabs, proper indentation)
- [ ] `description` field exists and is descriptive (required)
- [ ] `description` includes `<example>` blocks
- [ ] `mode` matches usage pattern (primary/subagent/all)
- [ ] `tools` enables only what's needed
- [ ] `permission` controls dangerous tools

**Common Issues:**

- ❌ Tabs instead of spaces in YAML
- ❌ Missing closing `---` marker
- ❌ Using old `name`/`skills`/`permissions` fields (deprecated)
- ❌ Missing `<example>` blocks in description

---

### 2. Permission Safety Check

Reference: `references/tool-selection.md` and `references/permission-patterns.md`

**High-Risk Tools (require `permission` controls):**

- `bash: true` - Can execute system commands
- `write: true` - Can overwrite files
- `edit: true` - Can modify files

**Check:**

- [ ] If `bash` enabled: Has `permission.bash` patterns?
- [ ] If `bash` enabled: Dangerous commands denied?
- [ ] If `write` enabled: `read` also enabled?
- [ ] If `edit` enabled: `read` also enabled?
- [ ] Tools follow principle of least privilege?
- [ ] No unnecessary tools enabled?

**Red Flags:**

- ❌ `bash: true` without `permission.bash` controls
- ❌ `write: true` without `read: true`
- ❌ All tools enabled but agent only needs a few
- ❌ Agent instructions contradict tool settings

---

### 3. Anti-Pattern Scan

Reference: `references/anti-patterns.md`

Quick scan for common issues:

**Anti-Pattern 1: Kitchen Sink Tools**

```yaml
# ❌ BAD: Enabling all tools unnecessarily
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

**Anti-Pattern 2: Missing Permission Controls**

```yaml
# ❌ BAD: bash without permission patterns
tools:
  bash: true
# Missing: permission.bash patterns in frontmatter!

# ✅ GOOD: bash with controls
tools:
  bash: true
permission:
  bash:
    "*": ask
    "ls *": allow
    "rm *": deny
```

**Anti-Pattern 3: Vague Description**

```yaml
# ❌ BAD: Unclear purpose
description: Helps with development tasks

# ✅ GOOD: Specific with examples
description: >-
  Refactors React components for performance optimization.
  Use when asked to review, optimize, or analyze React code.

  <example>
  User: "Optimize this component"
  Assistant: "I'll use react-optimizer."
  </example>
```

**Check:**

- [ ] No kitchen sink tools
- [ ] No bash without permission controls
- [ ] Description includes triggers and examples
- [ ] Tools match agent purpose
- [ ] No contradictory instructions

---

## Comprehensive Audit

### Phase 1: Structure Analysis

#### Frontmatter Quality

```markdown
**Agent**: [agent-name]

**Frontmatter Review:**

- Description: [clear with examples / unclear - feedback]
- Mode: [appropriate for use case / wrong]
- Tools: [minimal/excessive - suggestions]
- Permission: [controlled/uncontrolled - suggestions]

**Score**: [1-5] ⭐
**Issues Found**: [count]
```

#### Instruction Organization

**Check:**

- [ ] Has clear "Overview" or intro section
- [ ] Core responsibilities listed
- [ ] Operating principles defined
- [ ] Process/workflow sections included
- [ ] Tool usage guide present
- [ ] Examples provided
- [ ] Limitations documented

**Structure Score**: [1-5] ⭐

---

### Phase 2: Quality Assessment

#### Clarity

**Questions:**

1. Can a new user understand what the agent does?
2. Are instructions clear and actionable?
3. Are examples realistic and helpful?
4. Is technical jargon explained?

**Rating**: [Clear / Somewhat Clear / Unclear]

**Improvements Needed:**

- [ ] Simplify complex explanations
- [ ] Add more examples
- [ ] Define technical terms
- [ ] Improve structure

---

#### Completeness

**Check:**

- [ ] All granted tools have usage guidance
- [ ] Common use cases covered
- [ ] Error handling explained
- [ ] Edge cases addressed
- [ ] Limitations clearly stated

**Missing Elements:**

- [List what's missing]

**Completeness Score**: [1-5] ⭐

---

#### Consistency

**Check:**

- [ ] Permissions match tool usage in instructions
- [ ] Description matches actual capabilities
- [ ] Examples align with core responsibilities
- [ ] No contradictory guidance

**Inconsistencies Found:**

- [List inconsistencies]

**Consistency Score**: [1-5] ⭐

---

### Phase 3: Security Assessment

#### Permission Review

**Granted Permissions:**

- [List all permissions]

**Risk Level:** [LOW / MEDIUM / HIGH]

**Security Checklist:**

- [ ] Permissions follow least privilege principle
- [ ] High-risk permissions (bash, write) justified
- [ ] Safety protocols match risk level
- [ ] Input validation addressed (if applicable)
- [ ] Sensitive data handling covered (if applicable)

**Security Issues:**

- [List any security concerns]

**Security Score**: [1-5] ⭐

---

#### Safety Protocol Review

**For agents with `bash: true`:**

- [ ] Confirmation prompts before destructive operations
- [ ] Path verification before file operations
- [ ] Disk space checks before large operations
- [ ] Backup procedures documented
- [ ] Rollback procedures documented

**For agents with `write: true`:**

- [ ] File existence checks before overwriting
- [ ] Warning before overwriting existing files
- [ ] Preference for `edit` over `write` for modifications

**Safety Protocol Score**: [1-5] ⭐

---

### Phase 4: Performance & Optimization

#### Skill Loading

Skills are loaded at runtime via the `skill` tool, not declared in frontmatter.

**Check:**

- [ ] Agent has `skill: true` in tools if it needs to load skills
- [ ] Instructions explain when to load which skills
- [ ] Skills are loaded only when needed (not preemptively)

**Example guidance in agent instructions:**

```markdown
## When to Load Skills

Load skills at runtime based on the task:

- Security reviews → Load `security-review`
- React code → Load `vercel-react-best-practices`
- API design → Load `backend-patterns`
```

---

#### Tool Efficiency

**Check:**

- [ ] Uses appropriate tool for each task (grep vs bash grep)
- [ ] Avoids redundant tool operations
- [ ] Leverages todowrite for complex multi-step tasks
- [ ] Uses glob/grep for searches instead of bash find

**Optimization Suggestions:**

- [List improvements]

---

### Phase 5: Documentation Review

#### User-Facing Documentation

**Check:**

- [ ] Agent purpose clearly explained
- [ ] Common use cases documented
- [ ] Example workflows provided
- [ ] Limitations clearly stated
- [ ] When to use this agent vs. others

**Documentation Score**: [1-5] ⭐

---

#### Internal Documentation

**Check:**

- [ ] Operating principles guide agent behavior
- [ ] Decision-making criteria clear
- [ ] Tool selection rationale provided
- [ ] Error handling procedures documented

**Internal Doc Score**: [1-5] ⭐

---

## Security-Focused Audit

### Critical Security Checks

#### 1. Exposed Secrets Risk

**If agent has `read` or `bash`:**

- [ ] Instructions warn against logging sensitive files
- [ ] .env files handled carefully
- [ ] Credentials not exposed in output
- [ ] API keys not logged

---

#### 2. Destructive Operation Safety

**If agent has `bash` or `write`:**

- [ ] Confirmation required before:
  - [ ] File deletion
  - [ ] Database operations
  - [ ] System configuration changes
  - [ ] Package installation/removal
- [ ] Backup procedures documented
- [ ] Rollback procedures available

---

#### 3. Input Validation

**If agent processes user input:**

- [ ] Input sanitization addressed
- [ ] Path traversal prevention (file paths)
- [ ] Command injection prevention (bash commands)
- [ ] SQL injection prevention (database queries)

---

#### 4. Privilege Escalation

**If agent has `bash`:**

- [ ] sudo usage controlled
- [ ] User confirmation required for privileged operations
- [ ] Principle of least privilege followed

---

### Security Risk Matrix

| Risk Area            | Level   | Mitigated? | Notes |
| -------------------- | ------- | ---------- | ----- |
| Data exposure        | [H/M/L] | [Y/N]      |       |
| Destructive ops      | [H/M/L] | [Y/N]      |       |
| Privilege escalation | [H/M/L] | [Y/N]      |       |
| Input validation     | [H/M/L] | [Y/N]      |       |

**Overall Security Risk**: [LOW / MEDIUM / HIGH]

---

## Audit Report Template

```markdown
# Agent Audit Report: [agent-name]

**Audit Date**: [date]
**Audit Type**: [Quick / Comprehensive / Security]
**Auditor**: [name or "Agent Creator Skill"]

---

## Executive Summary

**Overall Score**: [X/5] ⭐

**Risk Level**: [LOW / MEDIUM / HIGH]

**Key Findings**:

- [Major finding 1]
- [Major finding 2]
- [Major finding 3]

**Recommendation**: [Pass / Pass with changes / Needs significant work]

---

## Detailed Findings

### Frontmatter Quality: [X/5] ⭐

**Issues**:

- [Issue 1]
- [Issue 2]

**Recommendations**:

- [Recommendation 1]
- [Recommendation 2]

---

### Permission Safety: [X/5] ⭐

**Current Permissions**:
\`\`\`yaml
permissions:
bash: true
read: true
...
\`\`\`

**Issues**:

- [Issue 1]
- [Issue 2]

**Recommended Changes**:
\`\`\`yaml
permissions:
read: true
edit: true
...
\`\`\`

---

### Instruction Quality: [X/5] ⭐

**Strengths**:

- [Strength 1]
- [Strength 2]

**Weaknesses**:

- [Weakness 1]
- [Weakness 2]

**Improvements**:

- [Improvement 1]
- [Improvement 2]

---

### Security Assessment: [X/5] ⭐

**Security Risks Identified**:

- [Risk 1]
- [Risk 2]

**Mitigation Required**:

- [Mitigation 1]
- [Mitigation 2]

---

### Documentation: [X/5] ⭐

**Missing Documentation**:

- [Missing item 1]
- [Missing item 2]

---

## Priority Action Items

### Critical (Fix Immediately)

1. [Critical issue]
2. [Critical issue]

### High Priority (Fix Soon)

1. [High priority issue]
2. [High priority issue]

### Medium Priority (Improve When Possible)

1. [Medium priority issue]
2. [Medium priority issue]

### Low Priority (Nice to Have)

1. [Low priority issue]
2. [Low priority issue]

---

## Recommended Changes

### Frontmatter

## \`\`\`yaml

name: improved-agent-name
description: More specific description here
skills:

- relevant-skill-1
  permissions:
  read: true
  edit: true

---

\`\`\`

### Instructions

\`\`\`markdown

## Add Missing Section

[Content to add]
\`\`\`

---

## Follow-Up Actions

- [ ] Implement critical fixes
- [ ] Review security mitigations
- [ ] Update documentation
- [ ] Re-audit after changes
- [ ] Test with real use cases

---

## Conclusion

[Summary of audit findings and path forward]
```

---

## Common Audit Findings

### Finding 1: Over-Permissioned Agent

**Issue**: Agent has more permissions than needed  
**Fix**: Remove unused permissions, follow least privilege principle

### Finding 2: Missing Safety Protocols

**Issue**: Agent with bash permission lacks safety checks  
**Fix**: Add confirmation prompts, backup procedures, verification steps

### Finding 3: Vague Instructions

**Issue**: Instructions are unclear or too general  
**Fix**: Add specific examples, step-by-step workflows, clarify expected behavior

### Finding 4: Missing Skill Integration

**Issue**: Agent doesn't explain when to load skills  
**Fix**: Add "When to Load Skills" section with runtime loading guidance

### Finding 5: Incomplete Documentation

**Issue**: Missing sections like limitations, examples, or tool usage  
**Fix**: Add comprehensive documentation following template structure

### Finding 6: Security Gaps

**Issue**: Sensitive operations lack proper safeguards  
**Fix**: Add input validation, sanitization, confirmation prompts

---

## Post-Audit Actions

1. **Implement Fixes**: Address critical and high-priority issues
2. **Test Changes**: Verify fixes don't break functionality
3. **Update Documentation**: Reflect changes in agent docs
4. **Re-Audit**: Run audit again to verify improvements
5. **Share Findings**: If applicable, share learnings with team

---

## Reference

For detailed scoring criteria, see:

- [`references/validation-checklist.md`](../references/validation-checklist.md) - Field-by-field validation
- [`references/audit-rubric.md`](../references/audit-rubric.md) - Scoring rubric with deductions

---

**Regular audits ensure agents remain secure, efficient, and maintainable over time.**
