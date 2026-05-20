---
name: sonarqube
description: Detect, investigate, and fix code quality issues using SonarQube. Use this skill when users mention SonarQube, code quality, test coverage, code duplication, security vulnerabilities, code smells, or ask to improve code quality, check for issues, or review their codebase. Always use this skill for any code quality analysis or when the user wants to ensure their project meets quality standards.
---

# SonarQube Code Quality Skill

This skill helps you systematically detect, investigate, and fix code quality issues using the SonarQube MCP server. It follows a structured workflow to ensure comprehensive analysis and safe remediation.

## Quality Thresholds

Your organization has established these quality gates that all projects must meet:

- **Issues**: 0 (no bugs or code smells)
- **Security Issues**: 0 (no vulnerabilities or security hotspots)
- **Code Coverage**: ≥80%
- **Code Duplication**: ≤3%

Use these thresholds to evaluate project health and prioritize remediation efforts.

## Workflow Overview

Follow this sequence for every code quality request:

1. **Health Check** → Verify SonarQube system availability
2. **Project Discovery** → Auto-locate project from repository name
3. **Metrics Assessment** → Compare current state against thresholds
4. **Issue Analysis** → Identify and categorize problems
5. **Recommendations** → Propose specific, prioritized fixes
6. **User Approval Gate** → Wait for explicit confirmation before changing code
7. **Fix Application** → Apply approved changes
8. **Verification** → Run tests to confirm fixes work

## Step 1: System Health Check

**Always start here.** Before any other operation, verify the SonarQube instance is healthy:

```
Call sonarqube_system_health
```

If the system is unhealthy or unreachable, stop and report the issue to the user. Do not proceed with analysis.

## Step 2: Project Discovery

The SonarQube project name always contains the repository name as a substring. Use this pattern to auto-discover the correct project:

1. Get the current repository name (from git or current directory)
2. Search for SonarQube projects containing that name:
   ```
   Call sonarqube_projects
   ```
3. Filter results by matching the repo name as a substring of the project key or name
4. If multiple matches, prefer exact matches or ask the user to clarify
5. If no match found, report to the user and ask for the correct project key

**Example:** 
- Repository: `afas-client`
- SonarQube project key might be: `com.pwc.afas-client`, `afas-client-backend`, or `afas-client`
- Match any of these as valid

## Step 3: Metrics Assessment

Retrieve comprehensive metrics for the discovered project:

```
Call sonarqube_measures_component with:
  component: <project-key>
  metric_keys: [
    "bugs",
    "vulnerabilities", 
    "code_smells",
    "security_hotspots",
    "coverage",
    "duplicated_lines_density"
  ]
```

Compare results against thresholds and categorize areas:

- **Critical** (immediate attention): Security issues > 0, Bugs > 0
- **High Priority**: Coverage < 80%, Security hotspots pending review
- **Medium Priority**: Code smells > 0
- **Low Priority**: Duplication > 3%

Present a clear dashboard to the user:

```
## Code Quality Dashboard - [Project Name]

| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| Bugs | X | 0 | ✅/❌ |
| Security Issues | X | 0 | ✅/❌ |
| Code Coverage | X% | ≥80% | ✅/❌ |
| Code Duplication | X% | ≤3% | ✅/❌ |
| Code Smells | X | 0 | ✅/❌ |

### Priority Areas
1. [Critical/High/Medium/Low]: [Description]
2. ...
```

If all metrics meet thresholds, congratulate the user and ask if they want a deeper review anyway.

## Step 4: Issue Analysis

For each failing threshold, retrieve detailed issues:

### For Bugs and Code Smells:
```
Call sonarqube_issues with:
  project_key: <project-key>
  types: ["BUG"] or ["CODE_SMELL"]
  statuses: ["OPEN", "REOPENED"]
  resolved: false
```

### For Security Issues:
```
Call sonarqube_issues with:
  project_key: <project-key>
  types: ["VULNERABILITY"]
  statuses: ["OPEN", "REOPENED"]
```

### For Security Hotspots:
```
Call sonarqube_hotspots with:
  project_key: <project-key>
  status: "TO_REVIEW"
```

Group issues by:
- **Severity** (BLOCKER, CRITICAL, MAJOR, MINOR, INFO)
- **File/Component** (which files have the most issues)
- **Type** (what kind of problems are most common)

Present a digestible summary — don't overwhelm with hundreds of individual issues. Focus on patterns and high-impact items.

## Step 5: Recommendations

Based on the analysis, propose specific, actionable fixes. Prioritize by impact and effort:

### High Impact, Low Effort (Do First):
- Security vulnerabilities with known fixes
- Critical bugs with clear root causes
- Missing test coverage in critical paths

### High Impact, High Effort (Plan Carefully):
- Architectural code smells requiring refactoring
- Comprehensive test suite expansion for coverage
- Large-scale duplication removal

### Present Recommendations Like This:

```
## Recommended Actions

### Priority 1: Security (0 → Target)
1. **Fix SQL Injection in UserController.java:142**
   - Issue: Unsanitized user input in SQL query
   - Fix: Use parameterized queries
   - Estimated effort: 10 minutes
   - Files: `src/controllers/UserController.java`

2. **Update Vulnerable Dependency (CVE-2023-1234)**
   - Issue: lodash@4.17.20 has known security flaw
   - Fix: Update to lodash@4.17.21
   - Estimated effort: 5 minutes
   - Files: `package.json`

### Priority 2: Test Coverage (65% → 80%)
1. **Add tests for AuthService.java**
   - Current: 0% coverage
   - Target: 80% coverage
   - Estimated effort: 2 hours
   - Files: `src/services/AuthService.java`, create `test/services/AuthService.test.java`

[Continue for each priority area...]
```

For each recommendation, explain:
- **What** is wrong
- **Why** it matters (impact on quality/security)
- **How** to fix it (concrete steps)
- **Where** to make changes (specific files/lines)

## Step 6: User Approval Gate

**CRITICAL: Never apply fixes without explicit approval.**

After presenting recommendations, ask:

```
I've identified [X] issues across [Y] priority areas. Would you like me to:
1. Fix all recommended issues
2. Fix only specific priorities (which ones?)
3. Show me the detailed code for specific fixes first
4. Skip fixes and just track these issues

Please confirm before I make any code changes.
```

Wait for user response. Do not proceed until you receive clear approval.

## Step 7: Fix Application

Once approved, apply fixes methodically:

### For Code Changes:
1. Read the affected file
2. Apply the fix (using the Edit tool)
3. Verify the fix with LSP diagnostics
4. Document what changed

### For Dependency Updates:
1. Read package.json/pom.xml/requirements.txt
2. Update version numbers
3. Run dependency install command
4. Check for breaking changes in changelogs

### For Test Creation:
1. Analyze the code being tested
2. Identify key behaviors and edge cases
3. Write comprehensive test cases
4. Ensure tests follow existing patterns in the codebase

**Apply fixes one category at a time.** Don't mix security fixes with test additions in the same commit.

Track your progress:

```
### Fix Progress
- [x] Fixed SQL injection in UserController.java
- [x] Updated lodash dependency
- [ ] Added tests for AuthService.java (in progress...)
```

## Step 8: Verification

After applying fixes, verify they work:

### Run Tests:
```bash
# Adjust based on project type
npm test
mvn test
pytest
```

If tests fail:
1. Review the failure messages
2. Check if your fixes introduced the failure or if it was pre-existing
3. Fix any issues introduced by your changes
4. **Do not fix pre-existing test failures** unless explicitly requested

### Re-check SonarQube (Optional):
If the project has a CI/CD pipeline that runs SonarQube scans, mention to the user:

```
I've applied the fixes. The next SonarQube scan (typically triggered by CI/CD) will reflect these improvements. 
Expected improvements:
- Bugs: X → 0
- Security Issues: X → 0
- Coverage: X% → Y%
```

If the user wants immediate verification, you can't trigger a new SonarQube scan directly (that requires project re-analysis), but you can verify the code changes are correct through local testing.

## Handling Edge Cases

### Multiple Projects Match Repository:
Ask the user to choose:
```
I found multiple SonarQube projects matching this repository:
1. com.pwc.myapp-backend
2. com.pwc.myapp-frontend
3. com.pwc.myapp-integration

Which project would you like me to analyze?
```

### No Issues Found:
```
Great news! Your project meets all quality thresholds:
✅ 0 bugs
✅ 0 security issues
✅ 85% code coverage (target: 80%)
✅ 1.2% code duplication (target: ≤3%)

Would you like me to review code smells or technical debt for further improvements?
```

### Too Many Issues to Fix at Once:
Suggest a phased approach:
```
This project has 156 open issues. I recommend tackling them in phases:

Phase 1 (Today): 12 security issues + 5 critical bugs (est. 3 hours)
Phase 2 (This Week): Test coverage improvements (est. 8 hours)
Phase 3 (This Sprint): Code smells and duplication (est. 20 hours)

Which phase would you like to start with?
```

### User Rejects Some Recommendations:
```
Understood. I'll focus on:
- [Approved items]

Would you like me to mark the others as "won't fix" in SonarQube, or leave them open for later?
```

## SonarQube Issue Management

After fixing issues, you can update their status in SonarQube:

### Mark as Fixed:
```
Call sonarqube_resolveIssue with:
  issue_key: <issue-key>
  comment: "Fixed: [brief description of fix]"
```

### Mark as False Positive (if applicable):
```
Call sonarqube_markIssueFalsePositive with:
  issue_key: <issue-key>
  comment: "Explanation of why this is a false positive"
```

### Add Comments for Tracking:
```
Call sonarqube_addCommentToIssue with:
  issue_key: <issue-key>
  text: "Working on this in PR #123"
```

Only update issue statuses after fixes are applied and verified. Don't mark issues as resolved prematurely.

## Communication Style

- **Be clear about priorities**: Users need to understand what's urgent vs. nice-to-have
- **Quantify impact**: "This will reduce security risk by eliminating 3 critical vulnerabilities"
- **Estimate effort**: "This change takes ~15 minutes" helps users decide what to tackle
- **Celebrate wins**: When metrics improve, acknowledge the progress
- **Be honest about complexity**: If a fix requires architectural changes, say so upfront

## What NOT to Do

- ❌ Skip the health check
- ❌ Proceed without finding the correct project
- ❌ Apply fixes without user approval
- ❌ Fix pre-existing test failures unrelated to your changes
- ❌ Mark issues as resolved before actually fixing them
- ❌ Overwhelm the user with 200 individual issue descriptions (summarize patterns)
- ❌ Mix different types of fixes in one go (keep security separate from tests separate from refactoring)

## Summary

This skill gives you a systematic, safe approach to code quality improvement:

1. **Check** → System health
2. **Find** → Auto-discover project
3. **Assess** → Compare metrics to thresholds
4. **Analyze** → Understand what's broken
5. **Recommend** → Propose prioritized fixes
6. **Approve** → Get user consent
7. **Fix** → Apply changes carefully
8. **Verify** → Test everything works

By following this workflow, you ensure that code quality improvements are targeted, safe, and aligned with organizational standards.
