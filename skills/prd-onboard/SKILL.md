---
name: prd-onboard
description: Walk a new user through setting up prd-please for their company. Detects existing configuration, supports either an in-repo COMPANY.md or a pointer to an external company context file (e.g., an internal repo or vault), populates the schema section by section with teach-through-choice questions, and wires CLAUDE.md so downstream skills can find the profile. Refers users to sibling please-family tools when a question is upstream of prd-please's scope. Trigger this skill when the user says things like "I just cloned prd-please, where do I start", "set this up for my company", "onboard me", "help me get started", "I want to use prd-please but I don't have a company profile yet", or when a fresh checkout has no `CLAUDE.md` and no populated `companies/<slug>/COMPANY.md`.
---

# Skill: prd-onboard

**Purpose:** Get a new user from a fresh prd-please clone to a working setup. Establish the company context that every other skill in this repo grounds against, either by populating an in-repo `COMPANY.md` from the template or by pointing at an external context file the user already maintains.

---

## Why This Skill Exists

prd-please ships with a complete COMPANY.md template, a schema doc, and a fictional example. The pattern works. The friction is in getting from "I just cloned the repo" to "the skills know who I am." Without an interactive step, the user has to read the schema, copy the template manually, and figure out which sections matter to which skills.

This skill is that interactive step. It also names the limit of prd-please honestly: when a user can't answer a question well, the right move is often to use a sibling tool (`strategy-please` for sharper ICP, `voice-please` for product-copy voice rules) and come back. The onboarding flow surfaces those handoffs at the moment they would help.

**Two patterns supported:**
- **In-repo COMPANY.md** (default): create `companies/<slug>/COMPANY.md` from the template, populate it, wire CLAUDE.md to it.
- **External pointer**: read an existing context file the user already maintains (private internal repo, separate vault, shared docs export). Wire CLAUDE.md to point at the path. Do not duplicate.

---

## When to Use vs. Skip

**Use prd-onboard when:**
- A fresh clone of prd-please has no `CLAUDE.md` (only `CLAUDE.md.template`)
- The user does not yet have a populated `companies/<slug>/COMPANY.md`
- The user wants to add a second company to an existing prd-please workspace
- The user wants to switch from in-repo COMPANY.md to an external pointer (or vice versa)

**Skip prd-onboard when:**
- The user already has a working setup and is asking about authoring a PRD (route to `prd-discovery` or `prd-author`)
- The user is editing an existing COMPANY.md (route to direct edit; this skill creates and walks, not maintains)
- The work is technical/build-stage and CLAUDE.md is already wired (no action here)

---

## Workflow

### Phase 1: Detect Current State

Before asking anything, take stock. Run these checks:

1. Is `CLAUDE.md` present at the repo root, or only `CLAUDE.md.template`?
2. List directories under `companies/` excluding `_template`. Are there any populated company profiles?
3. If `CLAUDE.md` exists, read its `company:` and `profile:` fields. Does the referenced profile actually exist at that path?

Classify the state:

- **Fresh clone**: no `CLAUDE.md`, no populated companies. Run the full onboarding.
- **Partial setup**: `CLAUDE.md` exists but `profile:` path is missing or empty. Offer to repair.
- **Adding a company**: `CLAUDE.md` exists, profile is populated, user wants to add another. Run abbreviated onboarding for the new company; do not touch CLAUDE.md unless the user confirms switching active company.

State the detected state to the user in one line before asking anything. If a working setup is already present, ask explicitly whether they want to add, repair, or switch.

### Phase 2: Choose the Pattern (In-Repo vs. External)

Ask via `AskUserQuestion`:

> **Where should prd-please read company context from?**
>
> *Why we ask:* Some users keep company context in this repo and let prd-please be self-contained. Others maintain a single canonical company file in a private internal repo or vault and want every tool (prd-please, archgate, others) to read from that one source.
>
> Options:
> - **In-repo** — create `companies/<slug>/COMPANY.md` from the template and walk the sections together.
> - **External pointer** — point CLAUDE.md at an existing context file you already maintain.

If **external pointer**: skip to Phase 4 with the external path.

If **in-repo**: continue to Phase 3.

### Phase 3: Populate In-Repo COMPANY.md

#### 3a. Identify the company

Ask for a URL-safe slug (`acme-co`, `northstar-labs`). Validate that `companies/<slug>/` does not already exist.

Copy the template directory:

```bash
cp -R companies/_template companies/<slug>
```

Set `created_at` in the frontmatter to today's date.

#### 3b. Walk the schema, section by section

Use `AskUserQuestion`, batched 2-4 questions per call. For each section, ship three things together: the question, a one-line rationale (why prd-please needs this), and where useful, 2-3 representative example answers so the user learns what "good" sounds like by contrast. Accept "I don't know" as a valid answer; mark those sections with `> Confidence: tentative` so downstream skills can degrade gracefully.

Walk in this order:

**A. Frontmatter** — company, product, website, industry, stage.
- Rationale: identity. Every skill reads the frontmatter first.

**B. Product context — What it is, Key capabilities, Differentiators**
- Rationale: prd-author and prd-taskmaster use this to scope features and avoid duplicating existing capabilities. "What it is" is the positioning statement, not a feature list.
- Example contrast for differentiators: "better UX" is too vague; "onboarding takes 15 minutes instead of 3 weeks" is specific and falsifiable.

**C. Product context — Current state, Technical constraints**
- Rationale: prd-taskmaster scopes tasks against current state. prd-validator flags violations of technical constraints.
- If the user says "we're pre-build, no tech stack yet", that is fine. Mark technical constraints as `[TBD — pre-build]`.

**D. Product context — Never mention publicly**
- Rationale: hard exclusion list. Skills will refuse to surface anything listed here in PRDs, copy, or artifacts shared outside the team.
- Examples to prompt: in-progress audits, partner names under NDA, internal pricing thresholds, deprecated capabilities you don't want re-introduced.

**E. Users — Primary segment**
- Rationale: prd-author's user stories are only as sharp as the segment definition. The verbatim "Language they use" field is what lets PRDs and product copy speak in the user's words.
- Walk the seven fields: Who they are, Problem, Today's behavior, Buying triggers, Language, Where they spend time, Hook.
- **Cross-tool referral:** If the user struggles to define a primary segment, or names two-or-three segments without being able to rank them, surface this:
  > "If your ICP isn't sharp yet, that is upstream of PRD work. [strategy-please](https://github.com/yesplease-studio/strategy-please) runs an ICP definition workshop. Run that, then come back to finish onboarding."
  Offer to mark the section `[TBD — pending strategy-please]` and continue, or pause onboarding now.

**F. Users — Secondary segment(s)**
- Optional. If the user has only one segment, skip.

**G. Competitor landscape**
- Optional but valuable. Three to five named competitors with What they offer / Where they're strong / Where we differentiate / Talk track.
- Skip gracefully if the user does not yet have a competitive read.

### Phase 4: Wire CLAUDE.md

Copy `CLAUDE.md.template` to `CLAUDE.md`. Replace `{{COMPANY_NAME}}` with the slug (in-repo case) or with a short identifier the user chooses (external case).

For external pointer: replace the `profile:` line with the absolute or repo-relative path the user provided. Validate the file exists and is readable. If the file does not look like a COMPANY.md (no frontmatter, no recognizable sections), warn but do not block.

Confirm to the user:

```
company: <name>
profile: <path>
```

### Phase 5: Confirm and Recommend the Next Step

Show what was created or wired, in a tight summary:

- Path to the COMPANY.md (or external file)
- Sections populated vs. left as `[TBD]` or tentative
- Any sibling-tool referrals raised during the walk

Then recommend one next move:

- **Rich product context, sharp ICP** → `prd-author` directly.
- **Thin or one-sided context (technical-only, founder-only)** → `prd-discovery` first to widen the source material.
- **ICP marked `[TBD — pending strategy-please]`** → run strategy-please now; resume prd-please when the ICP is sharp.

**Companion doc:** Generate `COMPANY-companion.md` in `companies/<slug>/`, using `templates/company-companion.md` as the base. Fill each section with content specific to this company and this session: name the actual framings that clarified the ICP, the actual fields that were left tentative and why, the actual sections that will be most load-bearing for prd-author. A companion doc that could apply to any company setup is not useful.

**Playbook entry:** Append one entry to `playbook.md` at the project root. Create the file from `templates/playbook.md` if it does not exist. Because this is the user's first encounter with the playbook, include the two-line explanation that precedes the entry format in the template.

```
## [date] Setup: [company slug]
This playbook tracks reusable moves from your prd-please sessions. Each skill adds one entry.
ICP summary: [one line -- who they are and what problem they have]
Key uncertainty: [what was left TBD and why]
```

End the skill. Do not chain into the next skill automatically; the user owns that call.

---

## Cross-Tool Referrals

The onboarding flow surfaces three sibling handoffs at the moment they would help. Keep referrals to one line each. Do not lecture.

| Trigger during onboarding | Sibling tool | One-line referral |
|---|---|---|
| User cannot define a primary segment, or names too many without ranking | [strategy-please](https://github.com/yesplease-studio/strategy-please) | "If your ICP isn't sharp yet, that is upstream of PRD work. strategy-please has a workshop for that." |
| User asks how product copy or microcopy should sound | [voice-please](https://github.com/yesplease-studio/voice-please) | "Voice belongs in voice-please. PRDs reference voice rules but don't define them." |
| User raises pricing or deal-qualification questions | [sales-please](https://github.com/yesplease-studio/sales-please) | "Stable pricing belongs in COMPANY.md. If qualification is the open question, sales-please handles that with WORTH." |

These are not blocking referrals. Offer the path, accept "I'll come back to it," and continue.

---

## Quality Standards

- **The COMPANY.md is usable on day one, not perfect.** A profile with strong product context and a single primary segment is enough to start using `prd-author`. Push for completeness on Product context and Primary user; let secondary segments and competitor landscape be progressive.
- **"I don't know" is logged, not papered over.** Sections marked `[TBD]` or `> Confidence: tentative` are valid output. They tell downstream skills what to handle gracefully.
- **External pointer is a one-line path, not a duplication.** Never copy an external context file into `companies/`. Point at it. Maintenance lives where the user already maintains the source.
- **Cross-tool referrals respect the user's time.** Surface the sibling once, accept the user's choice, do not repeat.

---

## What This Skill Does Not Do

- It does not write PRDs. That is `prd-author`.
- It does not run a discovery interview about a specific PRD. That is `prd-discovery`.
- It does not edit an existing COMPANY.md. That is direct edit territory once onboarding has wired the file in.
- It does not manage CLAUDE.md beyond `company:` and `profile:`. Other CLAUDE.md customization is the user's responsibility.

---

## Outputs

- `companies/<slug>/COMPANY.md` (in-repo case) populated with the user's answers and `[TBD]` markers where they declined to answer.
- `CLAUDE.md` at repo root with `company:` and `profile:` set.
- A one-paragraph confirmation message naming what was created, what was left tentative, and the recommended next skill.
