---
name: prd-author
description: Create and edit Strategic PRDs from human-provided context. Use this skill whenever you need to start a new Strategic PRD from scratch, revise an existing one due to scope changes, incorporate amendments proposed by the prd-learner skill, or make any structural changes to a PRD document. Trigger when the user says things like "write a PRD", "create a product spec", "update the PRD", "the scope changed", "incorporate these learnings", or "draft requirements for X". This is the only skill authorised to write or modify Strategic PRD documents — always use it when a PRD is the output.
---

# Skill: prd-author

**Purpose:** Create and edit Strategic PRDs from human-provided context. This is the only skill authorized to write or modify Strategic PRD documents.

---

## When to Use

- Starting a new product engagement (create mode).
- A client's scope changes significantly and the PRD needs revision (edit mode).
- The `prd-learner` skill has proposed amendments that require incorporation (edit mode).
- A human requests structural changes to an existing PRD (edit mode).

## Two Modes

### Create Mode

Takes messy human input and produces a complete Strategic PRD (draft status). The skill works conversationally, in phases, to ensure quality and alignment before writing.

### Edit Mode

Takes an existing Strategic PRD and applies targeted changes. Preserves unchanged sections. Never downgrades severity levels without explicit human instruction.

---

## Create Mode Workflow

**Mode detection:** Before Phase 1, check whether `playbook.md` exists at the project root and has at least one entry.

- No `playbook.md` or file is empty: **teach mode** -- show rationale inline on every question, announce the companion doc when it generates.
- `playbook.md` has entries: **standard mode** -- tight questions, rationale available on request, companion doc generated without announcement.
- User declares "expert" in conversation: **expert mode** -- no inline teaching, companion doc generated silently, playbook appended without narration.

### Phase 1: Gather and Assess Input

**Collect all available source material:**

- Call transcripts and recordings
- Client-provided documents (specs, decks, briefs)
- Prototypes, wireframes, screenshots
- Existing PRDs (if extending a product)
- URLs to external resources (fetch and incorporate)
- Notes from human conversations

**Assess input completeness.** Before proceeding, determine:

- Is the problem space clear?
- Are the target users identified?
- Is there enough to define a solution approach?
- What domains are likely relevant? (product, tech, data, design, AI, GTM)

If critical gaps exist, surface them in Phase 2 rather than guessing.

### Phase 2: Interview

Use `AskUserQuestion` to fill gaps and confirm direction. Batch questions into 2-4 per call. Adapt based on what's missing from Phase 1.

**Teach-through-choice:** Every question follows the three-things format: the question, a one-line rationale ("why we ask"), and optionally 2-3 representative answers so the user learns what good sounds like by contrast. In standard mode, skip representative examples unless the user seems unsure. In expert mode, skip rationale unless asked.

**Standard questions (adapt, don't ask verbatim):**

- What is the single most important outcome for this product/feature?
  *Why we ask:* Forces prioritization before scope locks. Without a primary outcome, every goal becomes equally important and the PRD cannot guide trade-off decisions.

- Who are the primary users, and what's their technical sophistication?
  *Why we ask:* Sophistication shapes UX requirements, onboarding complexity, and how much guidance the product needs to build in.

- What's the timeline and what must ship in the first release vs. later?
  *Why we ask:* Phase boundaries prevent everything from being R1. Without a hard line, the PRD becomes a wish list.

- Are there hard technical, regulatory, or commercial constraints we should know about?
  *Why we ask:* Constraints surface domains. A product handling financial data has compliance requirements; one replacing an internal tool has migration requirements. These rarely surface unless asked directly.

**Domain forcing function:** Based on the input material, identify which domains are likely relevant. If the human hasn't mentioned a domain that seems important (e.g. no data/privacy discussion for a product handling PII), proactively raise it:

> "The product will handle [type of data]. Should we include data privacy requirements, or is that handled elsewhere?"

This is one of the system's most important mechanisms — it ensures senior product thinking regardless of the author's experience.

**Commercial context probe:** In addition to domain forcing, determine the commercial context early. Ask a gating question: *"Is this an external product sold to customers, or an internal tool for your organization?"*

- **If external:** Probe for commercial dimensions: "Who buys this — not just who uses it? How do they discover it? What's the pricing model? What sales motion do you envision — self-serve, product-led growth, sales-led? What does the buyer journey look like before someone becomes a user?" These answers shape GTM requirements in Section 5 and the buyer journey in Section 3.
- **If internal:** Probe for stakeholder dimensions: "Who sponsors this internally? What does it replace? What's the maintenance plan after launch? Who supports it day-to-day? What's the build-vs-buy case — why build this rather than buy off the shelf?" These answers shape GTM requirements in Section 5 and the stakeholder journey in Section 3.
- **If not applicable** (purely technical module, infrastructure, or the human says "skip"): Omit GTM from the PRD.

**If the human provides a URL:** Use `WebFetch` to retrieve and incorporate the content.

**If extending an existing product:** Read existing PRDs (`depends_on` candidates) and reference them in the interview to check for conflicts or shared requirements.

### Phase 3: Outline and Confirm

Before writing the full PRD, produce a **structured outline** for human approval:

```
PRD-XXX: [Proposed Title]

Context: [1-2 sentence summary of the problem]
Goals (R1): [Bullet list of 3-5 primary goals]
Non-goals: [Bullet list of what's explicitly excluded]
Users: [Primary and secondary user roles]
Commercial context: [external / internal / not applicable] — [1-line summary]
Solution approach: [1-2 sentence summary]
Domains covered: [List which domain subsections will be included]
Key risks: [1-2 top risks]
```

Present this to the human. Wait for approval or redirection before proceeding.

**Why this phase matters:** Writing a full PRD is a significant token investment. Getting alignment on the outline first catches misunderstandings early and avoids expensive rewrites.

### Phase 3.5: Shape-Check the Outline

Before writing the full PRD, assess the outline the human has confirmed. Keep this to 2-4 sentences. Name what is strong. Name what is thin. Do not block -- shape-check is tutoring, not a gate.

What to assess:

- **Problem statement:** Grounded in specific evidence, or generic? ("Users want better reporting" is generic; "users export to CSV because the chart builder doesn't support multi-series comparisons" is specific and buildable.)
- **Goals:** Tied to a phase and measurable, or at minimum noted explicitly as qualitative?
- **Non-goals:** At least two named? An outline with no non-goals is a scope risk -- scope expands wherever no boundary is drawn.
- **Users:** A real segment with a named problem, or an assumed persona built from guesses?

In expert mode: skip this phase. In standard mode: surface only the one or two items that are genuinely thin. In teach mode: run all four checks and name what good would look like.

### Phase 4: Author the Strategic PRD

Write the complete Strategic PRD following the 8-section structure defined in the PRD System Definition.

**Section-by-section guidance:**

**Section 1 (Context & Problem):** Ground this in specific evidence from the input material. Quote or reference transcripts, client docs, and existing pain points. Avoid generic problem statements.

**Section 2 (Goals, Non-goals & Success Metrics):** Every goal should be tied to a phase. Non-goals are mandatory — if the human didn't specify any, propose them based on scope signals. Success metrics should be measurable where possible; qualitative is acceptable when quantitative isn't realistic.

**Section 3 (Users & Scenarios):** User stories follow the format: `US-01 (Role, Phase, Severity): As a [role], I want [action] so that [outcome].` Include 2-3 narrative scenarios that walk through end-to-end usage. If the commercial context probe identified this as an external product, add a **Buyer Journey** subsection mapping the stages from unaware through churning/graduating — who is involved at each stage, what triggers progression. If internal, add a **Stakeholder Journey** mapping the organizational lifecycle from need identification through ongoing maintenance.

**Section 4 (Solution Overview):** Architecture-level, not implementation-level. Name components, services, and integrations. A builder reading this should understand the shape of the system before seeing detailed requirements.

**Section 5 (Requirements by Domain):** This is the bulk of the PRD. For each relevant domain:

- Use the tabular format: `| ID | Severity | Requirement | Acceptance Criteria | Phase |`
- Every `must` requirement needs at least one testable acceptance criterion.
- Be prescriptive: "API must return paginated results with max 50 items per page" not "API should handle large datasets."
- Cross-reference user stories where applicable.
- Include only domains that are genuinely relevant. A simple CRUD app doesn't need a GTM section.
- **GTM domain guidance:** If external, GTM requirements should cover: pricing tiers and limits, free-tier boundaries, trial mechanics, onboarding conversion targets, positioning statements that the product must support. If internal, GTM requirements should cover: migration steps from the tool being replaced, training requirements, rollback plan, SLA expectations, ownership and support model. If the commercial context probe returned "not applicable," omit GTM.

**Section 6 (Guardrails):** These are the do's and don'ts. They must be:

- **Specific** — Name exact patterns, tools, APIs, conventions.
- **Verifiable** — An agent (or human) can objectively check compliance.
- **Non-redundant** — Don't restate requirements from Section 5 as guardrails. Guardrails are cross-cutting rules, not feature specs.

**Section 7 (Risks & Open Questions):** Every risk needs a mitigation. Every open question needs an owner and a target resolution date. If the human didn't specify owners, assign them and flag it for confirmation.

**Section 8 (Learnings):** Leave empty for new PRDs. Add a placeholder note:

```markdown
## 8. Learnings

No learnings recorded yet. This section will be populated by the `prd-learner` skill as implementation progresses.
```

### Phase 5: Present and Iterate

Share the draft with the human. Explicitly flag:

- Any assumptions made due to incomplete input.
- Any domain sections that feel thin and might need more context.
- Any open questions that block implementation.

The PRD status is `draft` until the human approves it. Upon approval, update status to `active`.

### Phase 5.5: Companion Doc and Playbook

After status moves to `active`, generate two artifacts. Do not wait for the human to ask.

**Companion doc:** Create `PRD-XXX-companion.md` in the same directory as the PRD, using `templates/prd-companion.md` as the base. Fill each section with content specific to this session: name the actual moves made, the actual decisions, the actual anti-patterns surfaced. A generic companion doc is useless. The value is in the specificity.

**Playbook entry:** Append one entry to `playbook.md` at the project root. Create the file from `templates/playbook.md` if it does not exist.

```
## [date] PRD-XXX: [short title]
Decomposition move: [the most reusable framing or structural decision from this session]
What to watch for: [one anti-pattern surfaced during authoring]
```

**Mode behavior:**
- Teach mode: surface the companion doc actively, mention where it lives, walk through one section to show what it contains.
- Standard mode: mention that the companion doc was generated and name its path.
- Expert mode: generate both silently.

---

## Edit Mode Workflow

### Step 1: Read the Current PRD

Load the full Strategic PRD. Parse frontmatter and all sections.

### Step 2: Understand the Requested Change

Changes can come from:

- Human request (direct edit instruction).
- `prd-learner` output (proposed amendments with learning context).
- Scope change (new client request that modifies existing requirements).

### Step 3: Apply Changes

**Principles for editing:**

- **Surgical edits.** Use targeted changes. Don't rewrite sections that aren't affected.
- **Additive by default.** Prefer adding new requirements, guardrails, or learnings over removing existing ones. Removal requires explicit human instruction.
- **Never downgrade severity.** Changing a `must` to a `should` requires explicit human approval with documented reasoning.
- **Preserve IDs.** Never change requirement IDs. If a requirement is superseded, deprecate it (strikethrough or note) and create a new one.
- **Cross-reference learnings.** If the edit is driven by a learning, reference the learning ID (e.g. `L-001`) in the amended text or as a comment.
- **Bump metadata.** Update `updated_at` in frontmatter after any edit.

### Step 4: Summarize Changes

After editing, produce a brief change summary:

```
Changes to PRD-XXX:
- Section 5.2: Added TECH-05 (must) — require rate limiting on all public endpoints. [Driven by L-003]
- Section 6: Added DON'T — expose stack traces in API error responses. [Driven by L-003]
- Section 7: Resolved OQ-02 — confirmed OAuth2 as auth standard.
- Frontmatter: updated_at bumped to 2026-03-15.
```

This summary is for the human reviewer and for `prd-taskmaster` to know which task contexts need regeneration.

---

## PRD Frontmatter Template

```yaml
---
id: PRD-001
title: "Feature Name – Phase"
product: "Product Name"
area: core-feature
status: draft                   # draft | active | deprecated
phase: R1                       # roadmap phase (R1, R2, etc.)
priority: P0                    # P0 (must-have) | P1 (important) | P2 (nice-to-have)
owner: owner.name
contributors:
  - name.one
  - name.two
depends_on:
  - PRD-002
labels:
  - ai-native
links:
  design: https://...
  transcript: https://...
  repo: https://...
created_at: 2026-03-01
updated_at: 2026-03-01
---
```

---

## Quality Standards

### Tone and Language

- **Prescriptive, not advisory.** Use "must", "will", "is required" — not "should consider", "might want to."
- **Specific, not vague.** Name exact tools, versions, patterns, thresholds.
- **Evidence-grounded.** Tie requirements to user needs, technical constraints, or business goals — not assumptions.
- **Balanced.** Acknowledge trade-offs honestly. Don't oversell.

### Calibration by Scope

| PRD Type | Expected Length | Focus Areas |
|----------|----------------|-------------|
| Single feature | 200-400 lines | Sections 3-6 heavy, minimal 7 |
| Product module | 400-700 lines | All sections substantial |
| Full product (R1) | 700-1200 lines | All sections comprehensive, multiple domain subsections |

### What Makes a Good PRD

- Every `must` requirement has testable acceptance criteria.
- Non-goals are explicit and specific, not generic ("we won't do everything").
- The domain forcing function was applied — relevant domains are covered even if the human didn't raise them.
- Risks have mitigations. Open questions have owners and dates.
- Guardrails are verifiable, not aspirational.
- A builder reading sections 4-6 can start working without needing to ask clarifying questions.
