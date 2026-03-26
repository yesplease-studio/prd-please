# PRD System — How to Use

The PRD system translates messy human input (call transcripts, client docs, sketches) into structured product requirements that AI agents can build from. It handles authoring, task decomposition, validation, and continuous learning.

For the full system specification, see [`SYSTEM.md`](SYSTEM.md).

---

## The four skills

| Skill | What it does | When to invoke |
|-------|-------------|----------------|
| [`prd-author`](../../skills/prd-author/SKILL.md) | Creates and edits Strategic PRDs | New engagement, scope change, incorporating learnings |
| [`prd-taskmaster`](../../skills/prd-taskmaster/SKILL.md) | Derives executable tasks and client views from a PRD | After PRD approval, new client request, PRD amendment |
| [`prd-validator`](../../skills/prd-validator/SKILL.md) | Checks implementation against PRD requirements | After building, during review, pre-merge |
| [`prd-learner`](../../skills/prd-learner/SKILL.md) | Captures learnings and proposes PRD amendments | After validation failures, end of sprint, repeated issues |

---

## Lifecycle

### New engagement

```
Client input (calls, docs, prototypes)
        ↓
   /prd-author  (create mode)
   Conversational, phased — gathers input, interviews, outlines, then writes
        ↓
   Strategic PRD (draft)
        ↓
   Human review & approval  ← approval gate
        ↓
   Strategic PRD (active)
        ↓
   /prd-taskmaster
   Decomposes PRD into buildable tasks + client-facing view
        ↓
   Building begins
```

**Workflow file:** [`workflows/product/prd-new-engagement.yaml`](../../workflows/product/prd-new-engagement.yaml)

### During building

When a client request comes in, run `/prd-taskmaster` to map it against the existing PRD. It will either generate a task, flag a scope extension, or escalate a conflict.

When a task is done, run `/prd-validator` to check compliance before shipping.

### After building (post-build review)

```
   /prd-validator
   Produces compliance report
        ↓
   /prd-learner
   Reviews what happened, proposes amendments
        ↓
   Human approval  ← approval gate
        ↓
   /prd-author  (edit mode)
   Applies approved amendments to the Strategic PRD
        ↓
   /prd-taskmaster
   Regenerates affected task contexts
```

**Workflow file:** [`workflows/product/prd-post-build.yaml`](../../workflows/product/prd-post-build.yaml)

---

## Where PRDs live

```
companies/<company>/prds/PRD-001.md
companies/<company>/prds/PRD-002.md
```

Each PRD is a single markdown file with YAML frontmatter. The frontmatter includes status (`draft` | `active` | `deprecated`), phase, priority, dependencies, and links.

The full PRD structure (8 sections) is documented in [`SYSTEM.md`](SYSTEM.md).

---

## Quick reference

**Create a new PRD:**
```
/prd-author
```
or: "Write a PRD for [feature/product]"

**Generate tasks from a PRD:**
```
/prd-taskmaster
```
or: "Break PRD-001 into tasks for R1"

**Validate implementation:**
```
/prd-validator
```
or: "Check this against the PRD"

**Capture learnings:**
```
/prd-learner
```
or: "What did we learn from this sprint? Update the PRD."

---

## Key design decisions

- **One source of truth.** The Strategic PRD is the single authoritative artifact. Tasks, client views, and rules summaries are all derived from it.
- **Humans decide, AI executes.** Humans provide vision and approval. AI handles authoring, decomposition, validation, and learning capture.
- **Every mistake becomes a rule.** The learning mechanism (`prd-learner` → `prd-author`) ensures implementation failures get codified back into the PRD.
- **Token efficiency.** Agents building features load focused task contexts, not full PRDs.
