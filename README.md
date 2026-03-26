# Systems Please

A codified methodology for AI-native product work. Systems, skills, and workflows that turn messy human context into structured, executable specifications — designed for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

Built and maintained by [Yes Please Studio](https://yesplease.studio).

---

## The problem

AI coding agents are powerful, but they produce inconsistent results without structured requirements. "Build me an app" gets you an app — just not the one you needed. The gap isn't intelligence, it's specification.

Systems Please fills that gap. It gives you a repeatable methodology for translating human intent into artifacts that AI agents can execute reliably — and a learning loop that makes each engagement better than the last.

## What's included

### PRD System

The core of Systems Please. A methodology for writing, structuring, and evolving product requirements so that AI agents can reliably scope, build, validate, and learn from them.

It solves three problems:

1. **Distillation.** Converts unstructured human context into a precise, structured source of truth (the Strategic PRD).
2. **Operationalization.** Derives executable tasks from the source of truth so building can begin within hours, not days.
3. **Continuous learning.** Feeds implementation experience back into the source of truth so the same mistakes are never repeated.

### Skills

Executable single-step workflows. Each has a `SKILL.md` that Claude reads before executing.

| Skill | What it does |
|-------|-------------|
| `prd-author` | Create and edit Strategic PRDs from human-provided context |
| `prd-taskmaster` | Derive executable tasks and client-facing views from a Strategic PRD |
| `prd-validator` | Validate implementation against PRD requirements and guardrails |
| `prd-learner` | Capture implementation learnings and propose PRD amendments |

### Workflows

Multi-step skill sequences defined in YAML. They chain skills together with conditional steps and human approval gates.

| Workflow | What it does |
|----------|-------------|
| `prd-new-engagement` | Author a PRD, get approval, generate tasks |
| `prd-post-build` | Validate, learn, amend, regenerate tasks |

### Company profiles

Structured context files (product, users, constraints) that skills load before executing. Your company profile is what makes generic skills produce project-specific output.

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

## Quick start

### 1. Clone the repo

```bash
git clone https://github.com/ericsteinbeldring/systems-please.git
cd systems-please
```

### 2. Set up your company profile

```bash
cp -R companies/_template companies/your-company
```

Edit `companies/your-company/COMPANY.md` with your product context. The template has detailed guidance for each section.

### 3. Configure your workspace

```bash
cp CLAUDE.md.template CLAUDE.md
```

Edit `CLAUDE.md` to set your active company:

```yaml
company: your-company
profile: companies/your-company/COMPANY.md
```

### 4. Start using skills

Open Claude Code in the repo directory and use skills directly:

```
/prd-author          Create a Strategic PRD for your product
/prd-taskmaster      Break a PRD into executable tasks
/prd-validator       Validate implementation against PRD requirements
/prd-learner         Capture learnings and propose amendments
```

Or use natural language:

- "Write a PRD for the new onboarding flow"
- "Break PRD-001 into tasks for R1"
- "Validate this code against the PRD"
- "Capture what we learned from this sprint"

### 5. See it in action

Check `examples/acme-analytics/` for a complete fictional engagement showing the PRD lifecycle: company profile, authored PRD, and learnings.

## Directory layout

```
systems/           Methodology definitions
  prd/               PRD system

skills/            Executable workflows (one SKILL.md each)
  prd-author/        Create and edit Strategic PRDs
  prd-taskmaster/    Derive tasks from PRDs
  prd-validator/     Validate implementation against PRDs
  prd-learner/       Capture learnings and amend PRDs

workflows/         Multi-step YAML sequences
  product/           PRD workflows

companies/         Company profiles
  _template/         Scaffold for new companies

examples/          Fictional example engagement
  acme-analytics/    Complete PRD lifecycle demo

deploy/            Setup templates for new workspaces
docs/              Architecture and schema reference
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on issues, pull requests, and methodology changes.

## License

Apache 2.0 — see [LICENSE](LICENSE). Attribution required.

---

*Systems Please is created and maintained by [Eric Stein-Beldring](https://linkedin.com/in/ericsteinbeldring) at [Yes Please Studio](https://yesplease.studio).*
