# Agent Creator Skill

[![Version](https://img.shields.io/badge/version-3.1.0-blue.svg)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![OpenCode](https://img.shields.io/badge/platform-OpenCode-purple.svg)](https://opencode.ai)

> Expert system for creating, configuring, and optimizing OpenCode agents with best practices, comprehensive templates, and quality guidelines.

---

## Overview

The **agent-creator** skill provides everything you need to build high-quality agents for [OpenCode](https://opencode.ai):

- **10 ready-to-use templates** for common agent types
- **Reference documentation** for frontmatter, tools, and permissions
- **Step-by-step workflows** for creating, auditing, and migrating agents
- **Validation checklists** and audit rubrics
- **Best practices** and anti-patterns guide

This skill follows the professional approach: **pure documentation that the LLM uses as context**, no external scripts or dependencies required.

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Templates](#templates)
- [Project Structure](#project-structure)
- [Agent Structure](#agent-structure)
- [Validation & Auditing](#validation--auditing)
- [Best Practices](#best-practices)
- [Reference Documentation](#reference-documentation)
- [Contributing](#contributing)
- [Changelog](#changelog)
- [License](#license)

---

## Features

| Feature                  | Description                                   |
| ------------------------ | --------------------------------------------- |
| **10 Templates**         | Pre-configured agents for different use cases |
| **Frontmatter Spec**     | Complete YAML specification with all fields   |
| **Tool Selection Guide** | Decision tree for choosing the right tools    |
| **Permission Patterns**  | Library of proven security configurations     |
| **Validation Checklist** | Field-by-field verification guide             |
| **Audit Rubric**         | Quality scoring with specific criteria        |
| **Workflows**            | Step-by-step guides for common tasks          |
| **Anti-Patterns**        | Common mistakes and how to avoid them         |

---

## Installation

### Clone the Repository

```bash
git clone https://github.com/rodrigolagodev/agent-creator.git ~/.config/opencode/skills/agent-creator
```

### Verify Installation

```bash
ls ~/.config/opencode/skills/agent-creator/SKILL.md
```

### Requirements

- **OpenCode** installed and configured
- **No additional dependencies** - Pure markdown documentation

---

## Quick Start

### 1. Load the Skill

The skill is loaded automatically when needed. Ensure your agent has the `skill` tool enabled:

```yaml
tools:
  skill: true
```

### 2. Create Your First Agent

Ask your assistant:

```
Create an agent for reviewing React components
```

The assistant will:

1. Load this skill for guidance
2. Read relevant templates
3. Create `~/.config/opencode/agent/react-reviewer.md`
4. Explain how to use it

### 3. Use Your Agent

- **Primary agents**: Press `Tab` to switch
- **Subagents**: Type `@react-reviewer` to invoke

---

## Templates

Ready-to-use templates for common agent types:

| Template                                                 | Description               | Mode     | Risk   |
| -------------------------------------------------------- | ------------------------- | -------- | ------ |
| [`simple-agent.md`](templates/simple-agent.md)           | Basic template with TODOs | all      | Low    |
| [`code-reviewer.md`](templates/code-reviewer.md)         | Code quality analysis     | subagent | Low    |
| [`security-auditor.md`](templates/security-auditor.md)   | Security review           | subagent | Low    |
| [`doc-writer.md`](templates/doc-writer.md)               | Documentation specialist  | subagent | Medium |
| [`refactoring-agent.md`](templates/refactoring-agent.md) | Code refactoring          | subagent | Medium |
| [`testing-agent.md`](templates/testing-agent.md)         | Automated testing         | subagent | Medium |
| [`api-developer.md`](templates/api-developer.md)         | API development           | subagent | Medium |
| [`frontend-dev.md`](templates/frontend-dev.md)           | React/Next.js             | subagent | Medium |
| [`db-admin.md`](templates/db-admin.md)                   | Database operations       | subagent | High   |
| [`devops-agent.md`](templates/devops-agent.md)           | CI/CD automation          | subagent | High   |

---

## Project Structure

```
agent-creator/
├── SKILL.md                      # Main entry point
├── README.md                     # This file
├── CHANGELOG.md                  # Version history
├── LICENSE                       # MIT License
│
├── references/                   # Reference docs
│   ├── frontmatter-spec.md
│   ├── tool-selection.md
│   ├── permission-patterns.md
│   ├── agent-types.md
│   ├── anti-patterns.md
│   ├── skills-integration.md
│   ├── validation-checklist.md
│   └── audit-rubric.md
│
├── templates/                    # 10 agent templates
│   └── (10 template files)
│
└── workflows/                    # Step-by-step guides
    ├── create-new-agent.md
    ├── audit-agent.md
    └── upgrade-agent.md
```

---

## Agent Structure

### Minimal Example

```yaml
---
description: >-
  Reviews code for quality and best practices.

  Use when asked to review, analyze, or check code quality.

  <example>
  User: "Review this component"
  Assistant: "I'll use the code-reviewer agent."
  </example>

mode: subagent

tools:
  read: true
  glob: true
  grep: true
  skill: true

permission:
  edit: deny
  write: deny
  bash: deny
---
# Code Reviewer

You are a code review specialist...
```

### Frontmatter Fields

| Field         | Required | Description                                      |
| ------------- | -------- | ------------------------------------------------ |
| `description` | Yes      | What + when + examples (max 1024 chars)          |
| `mode`        | No       | `primary`, `subagent`, or `all` (default: `all`) |
| `tools`       | No       | Tool enablement `{read: true, write: false}`     |
| `permission`  | No       | Fine-grained access control                      |
| `model`       | No       | Override model                                   |
| `temperature` | No       | Creativity level (0.1 - 1.0)                     |
| `maxSteps`    | No       | Iteration limit                                  |
| `hidden`      | No       | Hide from @ menu                                 |

See [`references/frontmatter-spec.md`](references/frontmatter-spec.md) for complete specification.

---

## Validation & Auditing

### Validation

Use the [validation checklist](references/validation-checklist.md) to verify:

- [ ] Valid YAML frontmatter (no syntax errors)
- [ ] Description has triggers and `<example>` blocks
- [ ] Tools match agent purpose
- [ ] Dangerous tools have permission controls
- [ ] No deprecated fields (name, skills, permissions)

### Auditing

Use the [audit rubric](references/audit-rubric.md) to score quality (target: 4.5+/5.0):

| Category      | What it measures                             |
| ------------- | -------------------------------------------- |
| Frontmatter   | Description quality, examples, mode          |
| Tool Safety   | Minimal tools, appropriate permissions       |
| Instructions  | Clear responsibilities, workflow, structure  |
| Security      | Dangerous tool controls, permission patterns |
| Documentation | Limitations, error handling, completeness    |

---

## Best Practices

### Do's ✅

- **Write in English** - LLMs process English more efficiently
- **Use descriptive names** - `security-auditor` not `helper1`
- **Include examples** - Add `<example>` blocks in description
- **Start minimal** - Only enable necessary tools
- **Control dangerous tools** - Use permission patterns for bash
- **Document limitations** - Be explicit about what agent cannot do

### Don'ts ❌

| Anti-Pattern           | Problem                     | Solution                       |
| ---------------------- | --------------------------- | ------------------------------ |
| Tool Overload          | Enabling all tools          | Only necessary ones            |
| Permission Promiscuity | `bash: allow`               | Use patterns with deny rules   |
| Vague Description      | "Helps with tasks"          | Specific triggers and examples |
| Missing Examples       | No `<example>` blocks       | Add 1-2 usage examples         |
| Wrong Mode             | Security auditor as primary | Use `subagent` for specialists |

---

## Reference Documentation

| Document                                                        | Description                    |
| --------------------------------------------------------------- | ------------------------------ |
| [`frontmatter-spec.md`](references/frontmatter-spec.md)         | Complete YAML specification    |
| [`tool-selection.md`](references/tool-selection.md)             | Tool selection decision tree   |
| [`permission-patterns.md`](references/permission-patterns.md)   | Security pattern library       |
| [`agent-types.md`](references/agent-types.md)                   | Agent archetypes with examples |
| [`anti-patterns.md`](references/anti-patterns.md)               | Common mistakes to avoid       |
| [`skills-integration.md`](references/skills-integration.md)     | Runtime skill loading          |
| [`validation-checklist.md`](references/validation-checklist.md) | Field-by-field validation      |
| [`audit-rubric.md`](references/audit-rubric.md)                 | Quality scoring rubric         |

---

## Contributing

Contributions are welcome! Here's how:

### Adding Templates

1. Create a new template in `templates/`
2. Follow existing template structure
3. Include comprehensive documentation
4. Add `skill: true` to tools
5. Update the templates table in this README

### Improving Documentation

1. Edit files in `references/` or `workflows/`
2. Test with real agents
3. Submit a pull request

### Reporting Issues

Open an issue with:

- Description of the problem
- Steps to reproduce
- Expected vs actual behavior

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

### Version 3.1.0 (Current)

**Fixed:**

- Corrected skill name in frontmatter (`creating-agents` → `agent-creator`)
- Removed obsolete script references
- Updated compatibility field to `agent-skills-standard`

### Version 3.0.0

**Breaking Changes:**

- Removed Python scripts (validation, audit, init)
- Converted script logic to markdown checklists

**Philosophy:**
Skills are **pure documentation** for LLM context, not executable software.

---

## License

MIT License - see [LICENSE](LICENSE) for details.

---

## Resources

- **OpenCode Documentation**: https://opencode.ai/docs/
- **Agent Documentation**: https://opencode.ai/docs/agents/
- **Permission Guide**: https://opencode.ai/docs/permissions/

---

## Philosophy

> "A great agent is like a skilled specialist:
>
> - **Clear** about their expertise (description with triggers)
> - **Equipped** with the right tools (minimal tool config)
> - **Careful** with dangerous operations (permission patterns)
> - **Knowledgeable** about when to consult references (skills integration)
> - **Focused** on doing one thing well (single responsibility)"

Create agents that are **focused**, **safe**, and **well-documented**.

---

<p align="center">
  Created by <strong>Rodrigo Lago</strong> for the OpenCode community
</p>
