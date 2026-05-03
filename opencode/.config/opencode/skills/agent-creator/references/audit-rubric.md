# Agent Audit Rubric

Use this rubric to audit agent quality and best practices. Score each category from 0-5, then calculate the overall score.

---

## How to Use

1. Read the agent file completely
2. Score each category using the criteria below
3. Note findings and recommendations
4. Calculate overall score (average of all categories)
5. Provide actionable feedback

**Target Score:** 4.5+ / 5.0

---

## Scoring Categories

### 1. Frontmatter Quality (0-5)

| Score | Criteria                                                         |
| ----- | ---------------------------------------------------------------- |
| 5.0   | Description has triggers, examples, proper length (50-500 chars) |
| 4.0   | Description complete but missing one element                     |
| 3.0   | Description present but short or missing examples                |
| 2.0   | Description present but vague                                    |
| 1.0   | Description too short (<20 chars)                                |
| 0.0   | Missing description                                              |

**Check for:**

- [ ] Description length (50-500 chars optimal)
- [ ] Contains `<example>` blocks
- [ ] Contains trigger keywords ("Use when...", "Use for...")
- [ ] Mode is valid (primary/subagent/all)
- [ ] No deprecated fields (name, skills, permissions)

**Deductions:**

- -2.0: Missing description
- -0.5: Description too short
- -0.5: No `<example>` blocks
- -0.3: No trigger keywords
- -0.5: Invalid mode

---

### 2. Tool Safety (0-5)

| Score | Criteria                                                                  |
| ----- | ------------------------------------------------------------------------- |
| 5.0   | Minimal tools, appropriate permissions, deny rules for dangerous commands |
| 4.0   | Good tool selection with minor issues                                     |
| 3.0   | Some unnecessary tools or missing permissions                             |
| 2.0   | Many tools without proper controls                                        |
| 1.0   | Dangerous tools with no restrictions                                      |
| 0.0   | All tools enabled with no permissions                                     |

**Check for:**

- [ ] Only necessary tools enabled
- [ ] bash has permission patterns if enabled
- [ ] Permission patterns include deny rules for dangerous commands
- [ ] Default (\*) rule exists for bash
- [ ] read enabled if write/edit enabled

**Deductions:**

- -1.0: 9+ tools enabled (kitchen sink)
- -1.5: bash without permission patterns
- -0.5: bash without deny rules
- -0.3: bash without default (\*) rule
- -0.5: write without read
- -0.5: edit without read

**Dangerous commands that should be denied:**

```
rm -rf, rm -r, dd, mkfs, format,
chmod 777, chown, shutdown, reboot,
DROP DATABASE, DELETE FROM (without WHERE)
```

---

### 3. Instruction Quality (0-5)

| Score | Criteria                                                     |
| ----- | ------------------------------------------------------------ |
| 5.0   | Well-organized, comprehensive, clear workflow, many examples |
| 4.0   | Good organization with minor gaps                            |
| 3.0   | Basic structure, needs more detail                           |
| 2.0   | Minimal instructions, poor organization                      |
| 1.0   | Very brief, no clear structure                               |
| 0.0   | No instructions after frontmatter                            |

**Check for:**

- [ ] Clear role definition in first paragraph
- [ ] Uses ## headings for sections (at least 3)
- [ ] Has Workflow or Process section
- [ ] Has Core Responsibilities section
- [ ] Contains code/command examples (at least 2 code blocks)
- [ ] Sufficient length (50+ lines)

**Deductions:**

- -1.0: Fewer than 3 sections
- -0.5: No code examples
- -0.5: No Workflow section
- -0.3: No Responsibilities section
- -0.5: Instructions too short (<50 lines)

---

### 4. Security (0-5)

| Score | Criteria                                                              |
| ----- | --------------------------------------------------------------------- |
| 5.0   | Comprehensive safety protocols, explicit deny rules, secrets handling |
| 4.0   | Good security with minor gaps                                         |
| 3.0   | Basic security awareness                                              |
| 2.0   | Minimal security consideration                                        |
| 1.0   | Dangerous tools with poor controls                                    |
| 0.0   | No security awareness                                                 |

**Check for (if bash enabled):**

- [ ] Safety keywords present (ALWAYS, NEVER, verify, confirm, backup, check)
- [ ] At least 3 safety instructions
- [ ] Deny patterns for dangerous commands
- [ ] Confirmation prompts for destructive actions

**Check for (if write enabled):**

- [ ] Mentions checking file existence
- [ ] Mentions backup or overwrite handling

**Check for (if read/bash enabled):**

- [ ] Guidance on handling secrets/credentials
- [ ] Instructions to never expose sensitive data

**Deductions:**

- -1.5: bash enabled with few safety keywords (<3)
- -0.5: Few deny patterns for bash (<2)
- -0.5: write enabled without overwrite guidance
- -0.3: No guidance on sensitive data handling

---

### 5. Documentation (0-5)

| Score | Criteria                                                                          |
| ----- | --------------------------------------------------------------------------------- |
| 5.0   | Complete documentation: overview, responsibilities, examples, errors, limitations |
| 4.0   | Good documentation with minor gaps                                                |
| 3.0   | Basic documentation, missing some sections                                        |
| 2.0   | Minimal documentation                                                             |
| 1.0   | Very incomplete                                                                   |
| 0.0   | No meaningful documentation                                                       |

**Check for:**

- [ ] Overview or introduction
- [ ] Core responsibilities listed
- [ ] Usage examples provided
- [ ] Error handling section
- [ ] Limitations section (what agent CANNOT do)
- [ ] When to load skills (if applicable)

**Deductions:**

- -0.5: Missing overview
- -0.5: Missing responsibilities
- -0.5: Missing examples
- -0.5: Missing error handling
- -0.3: Missing limitations

---

## Risk Level Assessment

Based on tools and permissions, assess the risk level:

| Risk Level | Criteria                                                          |
| ---------- | ----------------------------------------------------------------- |
| **LOW**    | Read-only (no write, edit, or bash)                               |
| **MEDIUM** | Write/edit enabled OR bash with proper deny rules and ask default |
| **HIGH**   | Bash enabled without proper controls                              |

---

## Overall Score Calculation

```
Overall Score = (Frontmatter + Tool Safety + Instructions + Security + Documentation) / 5
```

### Score Interpretation

| Score     | Rating    | Assessment                                   |
| --------- | --------- | -------------------------------------------- |
| 4.5 - 5.0 | Excellent | Follows best practices, ready for production |
| 3.5 - 4.4 | Good      | Solid agent with minor improvements needed   |
| 2.5 - 3.4 | Fair      | Needs improvements before production use     |
| 1.5 - 2.4 | Poor      | Requires significant work                    |
| 0.0 - 1.4 | Critical  | Major issues, needs rewrite                  |

---

## Audit Report Template

When auditing an agent, produce a report like:

```markdown
## Agent Audit Report: [agent-name]

**Audit Date:** YYYY-MM-DD
**Overall Score:** X.XX / 5.00
**Risk Level:** LOW | MEDIUM | HIGH

### Detailed Scores

| Category            | Score     | Notes |
| ------------------- | --------- | ----- |
| Frontmatter Quality | X.X / 5.0 | ...   |
| Tool Safety         | X.X / 5.0 | ...   |
| Instruction Quality | X.X / 5.0 | ...   |
| Security            | X.X / 5.0 | ...   |
| Documentation       | X.X / 5.0 | ...   |

### Findings

1. [Finding 1]
2. [Finding 2]
   ...

### Recommendations

1. [Recommendation 1]
2. [Recommendation 2]
   ...

### Assessment

[ ] EXCELLENT - Ready for production
[ ] GOOD - Minor improvements recommended
[ ] FAIR - Improvements needed before production
[ ] POOR - Significant work required
```

---

## Quick Audit Checklist

For rapid audits, use this condensed checklist:

- [ ] Description has triggers and examples
- [ ] Mode is appropriate (subagent for specialists)
- [ ] Only necessary tools enabled
- [ ] Dangerous tools have permission controls
- [ ] Instructions are well-organized
- [ ] Workflow is documented
- [ ] Limitations are stated
- [ ] Safety protocols exist (if bash enabled)
