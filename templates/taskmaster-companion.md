---
type: companion
skill: prd-taskmaster
artifact: [path/to/PRD-XXX.md]
date: YYYY-MM-DD
---

# Task Backlog Companion: [PRD title] — [Phase]

This document explains why the task backlog above is decomposed the way it is and what patterns to carry forward.

---

## Why voice

[Why the execution view summaries sound the way they do. What "plain language tied to user outcome" means in practice for this product and this audience. Name a specific example from this backlog: one summary where jargon was deliberately removed, what replaced it, and why that replacement is more useful for a non-technical client or stakeholder reading it.]

---

## Why structure

[Why requirements are grouped into these tasks and not differently. What the 24-48h scoping rule is doing -- what breaks when tasks are larger (too many requirements share one acceptance criterion, blocking validation) or smaller (too much coordination overhead, dependency chains multiply). Name one specific decomposition decision from this session: a cluster that was split, a cluster that was kept together, and the reasoning behind it.]

---

## What to reuse

[The decomposition moves from this session that will transfer to the next phase or next PRD. Examples of good entries:

- "Auth always splits into two tasks: the endpoint and the session management. They share domain but have different acceptance criteria."
- "ADR candidates cluster around the first TECH-domain task in each domain. Flag them before the sprint starts, not after."
- "If two requirements share the same user story, they belong in the same task even if they cross domain lines."

Write as moves, not observations. If you would not write it on a sticky note, it does not belong here.]

---

## Do-it-yourself

[How to decompose a PRD section manually using the same principles, without running prd-taskmaster. What to do first: read all requirements for the phase by severity, then group by the component they touch, then check for dependencies. The one question that sharpens every decomposition: "Can a single builder complete and validate this in 24-48 hours without waiting on another task?" Name the one or two decomposition traps this product's PRDs tend to fall into -- and what the early signal for each looks like.]
