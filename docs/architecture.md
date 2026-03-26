# Systems Please — Architecture

## What this document is

A technical overview of how Systems Please is structured, why it's structured this way, and how the layers compose.

---

## The layered model

Everything in Systems Please follows a pattern: there's a **methodology** (how to think about the problem), **skills** (how to execute the work), **company context** (who you're doing it for), and **workflows** (in what sequence).

### Layer 1: Systems (the "how to think")

A system is a methodology document that defines the problem space, core principles, how its skills compose, and quality standards. Skills reference their parent system when methodology reasoning is needed.

| System | File | What it codifies |
|--------|------|-----------------|
| PRD | `systems/prd/SYSTEM.md` | Three-layer PRD architecture, domain forcing, learning loops |

Systems are loaded on demand — a skill doesn't need the full system definition for routine execution, but designing a new engagement or resolving an ambiguity does.

### Layer 2: Skills (the "how to do")

Skills are `SKILL.md` files — self-contained executable specifications that Claude reads before performing a task. Each skill has a single responsibility and produces a defined output.

| Skill | Purpose |
|-------|---------|
| `prd-author` | Create and edit Strategic PRDs from human-provided context |
| `prd-taskmaster` | Derive executable tasks and client-facing views from a Strategic PRD |
| `prd-validator` | Validate implementation against PRD requirements and guardrails |
| `prd-learner` | Capture implementation learnings and propose PRD amendments |

**What stays in a skill:** format, structure, process steps, quality standards, self-check.

**What lives in the company profile:** product context, users, constraints, domain-specific details.

### Layer 3: Company profiles (the "who for")

A company profile (`COMPANY.md`) contains everything skills need to produce company-specific output. For PRD skills, the key sections are: product context, user definitions, technical constraints, and competitive landscape.

The complete schema is documented in `companies/_template/COMPANY.md`.

**How skills load context at runtime:**

```markdown
## Step 0: Load context

1. Read CLAUDE.md to identify the active company.
2. Read `companies/<active-company>/COMPANY.md` for company context.
3. If no company profile is found, ask the user which company they're working
   for before proceeding. Do not guess.
```

### Layer 4: Workflows (the "in what sequence")

A workflow is a composed skill sequence defined in YAML. Workflows chain skills together, passing outputs between steps, with conditional execution and human approval gates.

```yaml
name: prd-new-engagement
description: Author a PRD, get approval, generate tasks

steps:
  - id: author
    skill: prd-author
    approval: true

  - id: tasks
    skill: prd-taskmaster
    inputs:
      prd: "{{steps.author.output}}"
```

---

## How it connects

```
CLAUDE.md (per-workspace)
    ↓ sets active company
companies/<company>/COMPANY.md
    ↓ loaded before every skill
skills/<skill>/SKILL.md
    ↓ follows methodology from
systems/prd/SYSTEM.md
    ↓ composed into
workflows/<workflow>.yaml
```

---

## Progressive context loading

Not everything loads at once. Context is loaded progressively as needed:

1. **CLAUDE.md** — always in context. Sets active company, points to systems.
2. **SKILL.md** — loads when triggered.
3. **COMPANY.md** — loads once on first company-facing skill.
4. **SYSTEM.md** — loads only for methodology reasoning.
5. **Workflow YAML** — loads only for orchestrated execution.

This keeps token usage efficient. Updates to company context propagate instantly to all skills without editing each one.

---

## Design decisions

### Why a flat skills directory

Claude Code discovers skills by scanning a directory for `SKILL.md` files. The `skills/` directory stays flat for compatibility. Company-specific skill overrides live in `companies/<company>/skills/`.

### Why companies are gitignored

Company profiles contain proprietary context — product details, competitive intelligence, internal constraints. They should never be pushed to a shared remote. The `.gitignore` excludes `companies/` by default (except `_template/` and `examples/`).

### Why CLAUDE.md is generated, not committed

CLAUDE.md sets the active company — it's workspace-specific. Committing it would force one active company on everyone. Generated-per-workspace means it's always correct for the environment you're in.

### Why workflows are YAML, not code

YAML is human-readable, version-controllable, and Claude interprets it directly. No runtime, no dependencies, no build step.
