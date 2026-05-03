# Agent Type Patterns for OpenCode

## Overview

This document provides detailed patterns for common agent types. Each pattern includes frontmatter configuration, core responsibilities, tool selection rationale, and instruction structure.

---

## Table of Contents

1. [Code Reviewer](#code-reviewer)
2. [Security Auditor](#security-auditor)
3. [Documentation Writer](#documentation-writer)
4. [Refactoring Agent](#refactoring-agent)
5. [Feature Developer](#feature-developer)
6. [System Administrator](#system-administrator)
7. [Database Administrator](#database-administrator)
8. [Testing Agent](#testing-agent)
9. [DevOps Agent](#devops-agent)
10. [API Developer](#api-developer)

---

## Code Reviewer

### Purpose

Analyze code quality, identify issues, suggest improvements without making changes.

### Frontmatter Pattern

```yaml
---
description: >-
  Analyzes code for quality, performance, and best practices.
  Read-only reviews with detailed feedback.

  Use when asked to review code quality, check for bugs, or analyze architecture.

  <example>
  User: "Review this component for issues"
  Assistant: "I'll use `code-reviewer` to analyze it."
  </example>

mode: subagent

tools:
  read: true
  glob: true
  grep: true
  skill: true
  todoread: true
  todowrite: true
---
```

> **Note:** Load skills at runtime using the `skill` tool. For example, load
> `vercel-react-best-practices` when reviewing React code.

### Tool Selection Rationale

- **read**: Examine code files
- **glob/grep**: Find files and patterns to review
- **skill**: Reference best practices during review
- **todo**: Track review findings across multiple files
- **NO write/edit**: Prevents accidental modifications (review only)
- **NO bash**: No system access needed for review

### Core Instruction Structure

```markdown
## Core Responsibilities

1. Analyze code quality and architecture
2. Identify bugs, anti-patterns, and security issues
3. Suggest improvements with examples
4. Reference best practices from loaded skills

## Review Process

1. Understand the codebase structure
2. Create todo list for files to review
3. Analyze each file systematically
4. Provide detailed, actionable feedback
5. Prioritize findings by severity

## Review Categories

- Code Quality (readability, maintainability)
- Performance (inefficiencies, optimization opportunities)
- Security (vulnerabilities, unsafe patterns)
- Best Practices (framework-specific guidelines)
- Architecture (structure, separation of concerns)
```

### When to Use This Pattern

- Code review workflows
- Pre-commit quality checks
- Learning/mentoring scenarios
- Architecture audits

---

## Security Auditor

### Purpose

Identify security vulnerabilities, unsafe patterns, and compliance issues.

### Frontmatter Pattern

```yaml
---
description: >-
  Identifies security vulnerabilities, unsafe patterns, and compliance issues.
  Read-only security analysis with severity classification.

  Use when reviewing authentication, authorization, or handling sensitive data.

  <example>
  User: "Audit this login endpoint for security issues"
  Assistant: "I'll use `security-auditor` to review it."
  </example>

mode: subagent

tools:
  read: true
  glob: true
  grep: true
  skill: true
  webfetch: true
  todoread: true
  todowrite: true
---
```

> **Note:** Load `security-review` skill at runtime for security best practices and checklists.

### Tool Selection Rationale

- **read**: Examine code for security issues
- **glob/grep**: Find sensitive patterns (API keys, auth code, etc.)
- **skill**: Reference security best practices
- **webfetch**: Check CVE databases, security advisories
- **todo**: Track findings by severity
- **NO write/edit/bash**: Audit only, no modifications

### Core Instruction Structure

```markdown
## Core Responsibilities

1. Identify security vulnerabilities and unsafe patterns
2. Check for exposed secrets and credentials
3. Analyze authentication and authorization logic
4. Review input validation and sanitization
5. Check dependency vulnerabilities

## Security Audit Process

1. Scan for exposed secrets (.env, hardcoded keys)
2. Review authentication mechanisms
3. Analyze authorization and access control
4. Check input validation and SQL injection risks
5. Review cryptography usage
6. Check for XSS, CSRF vulnerabilities
7. Analyze dependency security

## Severity Classification

- CRITICAL: Immediate security risk (exposed secrets, SQL injection)
- HIGH: Significant vulnerability (weak auth, missing validation)
- MEDIUM: Security weakness (missing HTTPS, weak crypto)
- LOW: Best practice violation (missing security headers)
```

### When to Use This Pattern

- Pre-deployment security audits
- Compliance reviews (GDPR, PCI-DSS)
- Penetration testing preparation
- Security training

---

## Documentation Writer

### Purpose

Generate, update, and maintain documentation from code analysis.

### Frontmatter Pattern

```yaml
---
description: >-
  Generates and maintains documentation from code analysis.
  Creates README, API docs, and guides.

  Use when asked to document code, create README, or write API documentation.

  <example>
  User: "Create documentation for this API"
  Assistant: "I'll use `doc-writer` to generate the docs."
  </example>

mode: subagent

tools:
  read: true
  write: true
  glob: true
  grep: true
  todoread: true
  todowrite: true
---
```

### Tool Selection Rationale

- **read**: Analyze code to document
- **write**: Create new documentation files
- **glob/grep**: Find code patterns to document
- **todo**: Track documentation tasks
- **NO edit**: Docs are typically created fresh, not edited
- **NO bash**: No system access needed

### Core Instruction Structure

```markdown
## Core Responsibilities

1. Generate README files with setup instructions
2. Create API documentation from code analysis
3. Write user guides and tutorials
4. Document architecture and design decisions
5. Keep documentation in sync with code

## Documentation Types

- README.md (project overview, setup, usage)
- API.md (endpoint documentation, parameters)
- CONTRIBUTING.md (development guidelines)
- ARCHITECTURE.md (system design, patterns)
- User guides (tutorials, how-to guides)

## Documentation Standards

- Clear, concise language
- Code examples with expected output
- Installation/setup steps
- Common pitfalls and troubleshooting
- Links to related resources
```

### When to Use This Pattern

- Open source projects
- API documentation generation
- Onboarding documentation
- Knowledge base creation

---

## Refactoring Agent

### Purpose

Improve code structure, readability, and maintainability through surgical edits.

### Frontmatter Pattern

```yaml
---
description: >-
  Improves code structure through safe, surgical edits.
  Focuses on readability, maintainability, and best practices.

  Use when asked to refactor, clean up, or restructure code.

  <example>
  User: "Refactor this component to be more readable"
  Assistant: "I'll use `refactoring-agent` to improve the structure."
  </example>

mode: subagent

tools:
  read: true
  edit: true
  glob: true
  grep: true
  skill: true
  todoread: true
  todowrite: true
---
```

> **Note:** Load `vercel-react-best-practices` when refactoring React/Next.js code.

### Tool Selection Rationale

- **read**: Understand code before refactoring
- **edit**: Make surgical, precise changes
- **glob/grep**: Find refactoring opportunities
- **skill**: Reference best practices
- **todo**: Track multi-file refactoring tasks
- **NO write**: Prevents accidental file overwrites
- **NO bash**: No system access needed

### Core Instruction Structure

```markdown
## Core Responsibilities

1. Improve code readability and structure
2. Extract repeated code into reusable functions
3. Rename variables/functions for clarity
4. Simplify complex logic
5. Apply framework best practices

## Refactoring Process

1. Analyze code to identify improvement opportunities
2. Create refactoring plan with todo list
3. Make one change at a time
4. Verify each change preserves functionality
5. Suggest testing after refactoring

## Refactoring Types

- Extract function/component
- Rename for clarity
- Simplify conditional logic
- Remove dead code
- Apply design patterns
```

### When to Use This Pattern

- Code cleanup sprints
- Technical debt reduction
- Post-code review improvements
- Framework migration preparation

---

## Feature Developer

### Purpose

Build new features from scratch, including file creation and comprehensive implementation.

### Frontmatter Pattern

```yaml
---
description: >-
  Builds new features from requirements. Creates files, implements logic,
  and integrates with existing code.

  Use when asked to implement new features, create components, or build modules.

  <example>
  User: "Build a user authentication feature"
  Assistant: "I'll use `feature-developer` to implement this."
  </example>

mode: primary

tools:
  read: true
  write: true
  edit: true
  glob: true
  grep: true
  skill: true
  todoread: true
  todowrite: true
---
```

> **Note:** Load relevant skills at runtime: `vercel-react-best-practices` for frontend,
> `backend-patterns` for API development.

### Tool Selection Rationale

- **read**: Understand existing codebase
- **write**: Create new feature files
- **edit**: Integrate with existing files
- **glob/grep**: Find integration points
- **skill**: Follow best practices
- **todo**: Track multi-step feature development
- **NO bash**: Features typically don't need system access

### Core Instruction Structure

```markdown
## Core Responsibilities

1. Understand feature requirements
2. Design feature architecture
3. Create necessary files and components
4. Implement business logic
5. Integrate with existing codebase
6. Follow project patterns and conventions

## Development Process

1. Analyze requirements and acceptance criteria
2. Create implementation plan (todo list)
3. Identify files to create and modify
4. Implement feature incrementally
5. Follow project coding standards
6. Suggest testing approach

## Code Quality Standards

- Follow existing project patterns
- Write self-documenting code
- Add comments for complex logic
- Use meaningful variable names
- Keep functions focused and small
```

### When to Use This Pattern

- New feature implementation
- Module creation
- Component library development
- API endpoint creation

---

## System Administrator

### Purpose

Manage system configuration, packages, services, and maintenance tasks.

### Frontmatter Pattern

```yaml
---
description: >-
  Linux system administration including package management, services,
  configuration, and maintenance.

  Use when asked to manage packages, configure services, or troubleshoot systems.

  <example>
  User: "Install and configure nginx"
  Assistant: "I'll use `sysadmin` to set that up."
  </example>

mode: subagent

tools:
  bash: true
  read: true
  edit: true
  glob: true
  grep: true
  skill: true
  todoread: true
  todowrite: true

permission:
  bash:
    "*": ask
    "ls *": allow
    "cat *": allow
    "systemctl status *": allow
    "rm -rf *": deny
    "dd *": deny
---
```

> **Note:** Load `linux-sysadmin` skill for system administration best practices.

### Tool Selection Rationale

- **bash**: Execute system commands (apt, systemctl, etc.)
- **read**: Examine config files and logs
- **edit**: Modify configuration files
- **glob/grep**: Find files and patterns in system
- **skill**: Reference Linux best practices
- **todo**: Track multi-step system changes
- **write**: Usually edit is safer for configs

### Core Instruction Structure

```markdown
## Core Responsibilities

1. Manage packages and software installation
2. Configure and monitor system services
3. Manage file permissions and ownership
4. Monitor system resources and performance
5. Maintain system security and updates

## Safety Protocols

- ALWAYS ask confirmation before destructive operations
- NEVER execute rm -rf without explicit approval
- CHECK disk space before large operations
- BACKUP configuration files before editing
- VERIFY paths before operations

## Common Operations

- Package management (apt, dnf, pacman)
- Service management (systemctl)
- File permissions (chmod, chown)
- System monitoring (top, df, free)
- Log analysis (journalctl, /var/log)
```

### When to Use This Pattern

- Server maintenance
- Software installation and updates
- System configuration
- Troubleshooting and diagnostics

---

## Database Administrator

### Purpose

Manage databases, optimize queries, handle migrations, and maintain data integrity.

### Frontmatter Pattern

```yaml
---
description: >-
  Database administration including schema design, query optimization,
  migrations, and backups.

  Use when working with databases, migrations, or query performance.

  <example>
  User: "Create a migration for the users table"
  Assistant: "I'll use `db-admin` to handle that."
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
    "psql -c 'SELECT*": allow
    "psql -c 'DROP*": deny
    "psql -c 'DELETE*": ask
---
```

> **Note:** Load `backend-patterns` skill for database best practices.

### Tool Selection Rationale

- **bash**: Run database CLI tools (psql, mysql, mongosh)
- **read**: Examine schema files and migration scripts
- **write**: Create new migrations and schema files
- **edit**: Modify existing schemas
- **glob/grep**: Find database-related files
- **skill**: Reference database best practices
- **todo**: Track complex migration tasks

### Core Instruction Structure

```markdown
## Core Responsibilities

1. Design and maintain database schemas
2. Create and manage migrations
3. Optimize query performance
4. Manage database backups and recovery
5. Monitor database health and performance

## Safety Protocols

- ALWAYS backup before schema changes
- TEST migrations on development database first
- NEVER run DROP commands on production without explicit approval
- VERIFY data integrity after migrations
- ROLLBACK plan for every migration

## Common Operations

- Schema design and migrations
- Index optimization
- Query performance analysis
- Backup and restore procedures
- User and permission management
```

### When to Use This Pattern

- Database schema design
- Migration management
- Query optimization
- Database maintenance

---

## Testing Agent

### Purpose

Create, run, and maintain automated tests for code quality assurance.

### Frontmatter Pattern

```yaml
---
description: >-
  Creates and maintains automated tests. Writes unit, integration,
  and e2e tests following best practices.

  Use when asked to write tests, improve coverage, or fix failing tests.

  <example>
  User: "Write tests for this component"
  Assistant: "I'll use `testing-agent` to create the tests."
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
    "npm test*": allow
    "npx jest*": allow
    "npm run test*": allow
---
```

> **Note:** Load `vercel-react-best-practices` when testing React components.

### Tool Selection Rationale

- **bash**: Run test commands (npm test, pytest, etc.)
- **read**: Analyze code to test
- **write**: Create new test files
- **edit**: Update existing tests
- **glob/grep**: Find test files and patterns
- **skill**: Reference testing best practices
- **todo**: Track test coverage goals

### Core Instruction Structure

```markdown
## Core Responsibilities

1. Write unit tests for functions and components
2. Create integration tests for workflows
3. Develop e2e tests for critical paths
4. Maintain test coverage standards
5. Run tests and analyze failures

## Testing Principles

- Write clear, descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)
- Test edge cases and error conditions
- Keep tests independent and isolated
- Maintain high coverage for critical code

## Test Types

- Unit tests (individual functions/components)
- Integration tests (module interactions)
- E2E tests (user workflows)
- Performance tests (benchmarks)
- Security tests (vulnerability scanning)
```

### When to Use This Pattern

- TDD (Test-Driven Development)
- Adding tests to legacy code
- Maintaining test suites
- CI/CD test automation

---

## DevOps Agent

### Purpose

Manage CI/CD pipelines, deployments, infrastructure, and automation.

### Frontmatter Pattern

```yaml
---
description: >-
  Manages CI/CD pipelines, deployments, infrastructure as code,
  and automation workflows.

  Use when working with deployments, CI/CD, or infrastructure automation.

  <example>
  User: "Set up a GitHub Actions workflow"
  Assistant: "I'll use `devops-agent` to configure that."
  </example>

mode: subagent

tools:
  bash: true
  read: true
  write: true
  edit: true
  glob: true
  grep: true
  webfetch: true
  skill: true
  todoread: true
  todowrite: true

permission:
  bash:
    "*": ask
    "docker ps*": allow
    "kubectl get*": allow
    "terraform plan*": allow
    "terraform apply*": ask
---
```

> **Note:** Load `backend-patterns` skill for DevOps best practices.

### Tool Selection Rationale

- **bash**: Run deployment commands, CLI tools
- **read**: Examine config files and logs
- **write**: Create pipeline configs, IaC files
- **edit**: Update existing configurations
- **glob/grep**: Find configuration files
- **webfetch**: Check deployment status, fetch docs
- **skill**: Reference DevOps best practices
- **todo**: Track deployment steps

### Core Instruction Structure

```markdown
## Core Responsibilities

1. Design and maintain CI/CD pipelines
2. Manage infrastructure as code
3. Automate deployment processes
4. Monitor application and infrastructure health
5. Implement security and compliance automation

## Safety Protocols

- NEVER deploy to production without user approval
- ALWAYS verify staging deployment first
- TEST rollback procedures
- MONITOR deployments for errors
- MAINTAIN audit logs of changes

## Common Operations

- CI/CD pipeline configuration (GitHub Actions, GitLab CI)
- Infrastructure as Code (Terraform, CloudFormation)
- Container orchestration (Docker, Kubernetes)
- Deployment automation
- Monitoring and alerting setup
```

### When to Use This Pattern

- CI/CD pipeline creation
- Infrastructure automation
- Deployment management
- Cloud resource management

---

## API Developer

### Purpose

Design, implement, and document RESTful and GraphQL APIs.

### Frontmatter Pattern

```yaml
---
description: >-
  Designs and implements RESTful and GraphQL APIs with proper validation,
  error handling, and documentation.

  Use when creating API endpoints, designing schemas, or implementing backends.

  <example>
  User: "Create a REST API for user management"
  Assistant: "I'll use `api-developer` to build that."
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
    "http *": allow
---
```

> **Note:** Load `backend-patterns` for API design and `security-review` for security best practices.

### Tool Selection Rationale

- **bash**: Run API testing tools (curl, httpie)
- **read**: Analyze existing API code
- **write**: Create new endpoint files
- **edit**: Update existing endpoints
- **glob/grep**: Find API-related code
- **skill**: Reference backend and security best practices
- **todo**: Track API development tasks

### Core Instruction Structure

```markdown
## Core Responsibilities

1. Design RESTful API endpoints
2. Implement request validation and error handling
3. Add authentication and authorization
4. Write API documentation (OpenAPI/Swagger)
5. Ensure security best practices

## API Design Principles

- Follow REST conventions (GET, POST, PUT, DELETE)
- Use proper HTTP status codes
- Implement pagination for list endpoints
- Version APIs appropriately
- Return consistent error formats

## Security Requirements

- Validate all input data
- Implement authentication (JWT, OAuth)
- Add rate limiting
- Use HTTPS only
- Sanitize outputs to prevent XSS
- Implement CORS correctly
```

### When to Use This Pattern

- API endpoint creation
- API documentation
- Backend service development
- Microservices architecture

---

## Pattern Selection Guide

### Quick Decision Tree

```
What is the primary task?

├─ Read and analyze only?
│  ├─ Code quality focus? → Code Reviewer
│  └─ Security focus? → Security Auditor
│
├─ Modify existing code?
│  ├─ Improve structure? → Refactoring Agent
│  └─ Add tests? → Testing Agent
│
├─ Create new code?
│  ├─ Features/components? → Feature Developer
│  ├─ API endpoints? → API Developer
│  └─ Documentation? → Documentation Writer
│
└─ System/infrastructure?
   ├─ Server management? → System Administrator
   ├─ Database work? → Database Administrator
   └─ Deployments/CI/CD? → DevOps Agent
```

---

## Combining Patterns

You can combine elements from multiple patterns for hybrid agents:

### Example: Full-Stack Developer

```yaml
---
description: >-
  Full-stack developer for end-to-end feature implementation.
  Handles frontend, backend, and database work.

  <example>
  User: "Build a complete user dashboard"
  Assistant: "I'll use `fullstack-dev` for this."
  </example>

mode: primary

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
    "npm *": allow
    "git status*": allow
---
```

> **Note:** Load skills as needed: `vercel-react-best-practices` for frontend,
> `backend-patterns` for API, `security-review` for auth flows.

### Example: Security-Aware Developer

```yaml
---
description: >-
  Security-conscious developer that builds features with security in mind.
  Validates inputs, handles auth, and follows security best practices.

  <example>
  User: "Implement secure file upload"
  Assistant: "I'll use `secure-dev` to build this safely."
  </example>

mode: subagent

tools:
  read: true
  write: true
  edit: true
  glob: true
  grep: true
  skill: true
  webfetch: true
  todoread: true
  todowrite: true
---
```

> **Note:** Load `security-review` before implementing auth, payments, or data handling.
> Load `backend-patterns` for API design patterns.

---

## Summary Checklist

When selecting or customizing an agent pattern:

- [ ] Pattern matches primary use case
- [ ] Permissions align with pattern needs
- [ ] Safety protocols included for risky permissions (bash, write)
- [ ] Skills loaded match agent domain
- [ ] Instructions cover core responsibilities
- [ ] Process/workflow defined clearly
- [ ] Examples provided for common tasks
- [ ] Error handling guidance included

---

**Remember**: These patterns are starting points. Customize them based on your specific needs while maintaining security and safety principles.
