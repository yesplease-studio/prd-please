# {{COMPANY_NAME}} — Product Requirements System

A structured Claude Code workspace for writing, decomposing, validating, and learning from product requirements. Powered by [PRD Please](https://github.com/yesplease-studio/prd-please).

## Quick start

```bash
git clone <repo-url>
cd {{COMPANY_SLUG}}-systems
claude
```

Claude loads all {{COMPANY_NAME}} context automatically. Just describe what you want.

## First-time setup

See [SETUP.md](SETUP.md) for step-by-step instructions.

## Available skills

| Skill | What it does | Example prompt |
|-------|-------------|----------------|
| **prd-author** | Create and edit Strategic PRDs | "Write a PRD for the new dashboard feature" |
| **prd-taskmaster** | Derive executable tasks from a PRD | "Break PRD-001 into tasks for R1" |
| **prd-validator** | Validate implementation against PRD | "Validate this code against the PRD" |
| **prd-learner** | Capture learnings and amend the PRD | "Capture what we learned from this sprint" |

You don't need to name the skill. Just describe what you want and Claude will trigger the right one.

## Improving the system

When a skill produces suboptimal output:

1. Tell Claude what should change and why.
2. Claude will identify whether the fix belongs in the skill, the system definition, or the company profile.
3. Approve the proposed edit.
4. Commit with a clear message.

## Troubleshooting

**"Claude doesn't know about {{COMPANY_NAME}}"** — Make sure you're running `claude` from inside the project directory.

**"Permission denied"** — Check `.claude/settings.local.json`.

## What's here

| Path | What it does |
|------|-------------|
| `COMPANY.md` | Company profile: product context, users, constraints |
| `systems/prd/` | PRD methodology definition |
| `skills/` | 4 PRD skills |
| `workflows/` | PRD workflow sequences |
| `prds/` | Your Strategic PRDs |
