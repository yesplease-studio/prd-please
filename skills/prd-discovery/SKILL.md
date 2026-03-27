---
name: prd-discovery
description: Run a structured pre-authoring interview to uncover what is known, what can be inferred, and what is genuinely unknown before writing a Strategic PRD. Produces a Discovery Brief that prd-author ingests as its primary input. Use this skill before prd-author on any new engagement or when the input material is thin, one-sided, or missing key domain perspectives. Trigger when the user says things like "I want to write a PRD but I'm not sure where to start", "here's a rough idea", "I have a transcript but no context on the commercial side", "let's figure out what we know before writing", or "run discovery on this". Skip this skill if the human already has rich, multi-domain source material and is ready to go straight to authoring.
---

# Skill: prd-discovery

**Purpose:** Run a structured pre-authoring interview that surfaces what is known, confirms what can be inferred, and explicitly names what is unknown — across all product domains. Produces a Discovery Brief that `prd-author` ingests as its primary source material.

---

## Why This Skill Exists

`prd-author`'s Phase 2 (Interview) does lightweight gap-filling — 4 standard questions, domain prompts where obvious. That works well when the human arrives with rich context.

Discovery is the step for when they don't.

Most people approach a PRD from one angle: the developer thinks in terms of architecture and ignores commercial strategy; the founder thinks in terms of users and ignores data or security; the PM thinks in terms of features and ignores who actually buys the thing. This skill forces a full-spectrum conversation *before* authoring begins, so the PRD is built on a complete foundation rather than patched with open questions after the fact.

**The key design principle:** "I don't know" is a valid, first-class output. An answered question becomes PRD input. An unanswered question becomes a logged open question (`OQ-XX`) in the PRD. Both are useful. Neither is a failure.

---

## When to Use vs. Skip

**Use prd-discovery when:**
- The human has limited source material (idea, rough notes, a single transcript)
- The context is clearly one-sided (technical-only, product-only, etc.)
- The engagement is new with no existing PRDs to reference
- The human says they want to "think through" what they're building before writing

**Skip prd-discovery when:**
- The human arrives with rich multi-domain input (client docs, research, call transcripts with commercial and technical context, existing PRDs)
- They are doing a targeted edit to an existing PRD, not starting fresh
- Time constraints make the pre-authoring step impractical — note the trade-off and proceed to `prd-author` directly

---

## Workflow

### Phase 1: Collect Initial Context

Ask the human for whatever they have. Accept any format:
- A rough idea stated verbally
- A URL to a product brief, landing page, or document
- A call transcript
- An existing PRD or technical spec
- Notes from a conversation

If a URL is provided, use `WebFetch` to retrieve and read it before proceeding.

**Assess what you have.** Before asking any questions, take stock:

- Which domains have strong input already? (Don't re-ask what's already answered.)
- Which domains are entirely absent?
- What's the commercial context — external product, internal tool, or unknown?
- How technical vs. non-technical is the person you're talking to?

### Phase 2: Domain Interview

Work through the domains below using `AskUserQuestion`. Batch 2-4 questions per call — never ask all questions at once.

**Adapt based on what Phase 1 revealed.** If the human's input already answers a question clearly, skip it. If they seem unfamiliar with a domain (e.g. a developer who hasn't thought about commercial strategy), frame the question as exploratory rather than interrogative:

> "Have you thought about who would actually buy this, as distinct from who would use it? Or is that an open question at this stage?"

The goal is to build the muscle, not to gatekeep. A shrug or "I don't know yet" is a useful output — it becomes an open question in the PRD.

---

#### Domain A: Problem & Context

*What exists, what's broken, why now.*

- What is the specific problem this solves? Who experiences it most acutely?
- What do those people do today without this product — what's the workaround or status quo?
- Why is this worth solving now? What's changed, or what's the window of opportunity?
- If this product disappeared tomorrow, what would be lost?

**Listen for:** Specificity vs. vagueness. Generic problem statements ("there's no good tool for X") are weaker than specific frustrations with evidence ("our champions are fielding 5-10 data requests per week and burning out").

---

#### Domain B: Users & Scenarios

*Who uses it, how, and under what conditions.*

- Who are the primary users? What's their technical sophistication?
- Who are secondary users or stakeholders who interact with the product but aren't the primary audience?
- Walk me through how a user would interact with this product in a typical session. What do they do before they open it, and what do they do after?
- Are there any users who would be harmed or left behind if we optimize for the primary user?

**Listen for:** Whether the human distinguishes between the person who *uses* the product and the person who *benefits* from it (they're often different). Watch for unexamined assumptions about user sophistication.

---

#### Domain C: Commercial Context

*Who buys this, how, and why.*

First, establish the context type:

> "Is this an external product sold to customers, an internal tool built for your organization, or something else?"

**If external:**
- Who buys this — not just who uses it? Are the buyer and the primary user the same person?
- How do buyers find out this product exists today? What channels are working, which are aspirational?
- What's the pricing model, and why that model? (Usage-based, seat-based, one-time, freemium?)
- What does the sales motion look like — fully self-serve, product-led (try before you buy), or sales-led?
- What's the buyer journey before someone becomes a user? What triggers them to look? What makes them commit?
- Who do you lose deals to most often — another product, the status quo (doing nothing), or an internal workaround?

**If internal:**
- Who sponsors this internally — who has the budget and the mandate?
- What does this replace? What tools, processes, or manual work go away?
- What's the maintenance model after launch? Who supports it?
- What's the build-vs-buy case? Why not buy an off-the-shelf tool?
- Who needs to adopt it for it to be considered a success?

**If not applicable** (purely technical module, infrastructure work, no commercial or stakeholder dimension): note that GTM will be omitted from the PRD and move on.

**Listen for:** People who confuse "who uses it" with "who decides to pay for it." The buyer and user distinction shapes everything in GTM requirements. A developer who hasn't thought about this isn't wrong — it's an open question worth naming.

---

#### Domain D: Technical Constraints

*The boundaries on how it can be built.*

- Are there hard technical constraints? (Existing stack, language/framework, performance thresholds, security standards)
- Are there integrations that are non-negotiable for the first release?
- Any regulatory, compliance, or data residency requirements?
- What's the target timeline, and what must ship in R1 vs. what can wait?
- What would make this technically hard to build that the product idea doesn't acknowledge yet?

**Listen for:** Unstated assumptions ("of course it needs to work on mobile") and constraints that have downstream implications across multiple domains. A compliance requirement isn't just a tech constraint — it likely shapes data, design, and GTM too.

---

#### Domain E: Data & Privacy

*What data the product handles and what that means.*

- Does this product collect, process, or expose user or customer data? What kind?
- Is any of it personally identifiable (PII), financial, health-related, or otherwise regulated?
- What analytics or instrumentation does the product itself need to produce — what do you need to measure to know if it's working?
- Who owns the data the product operates on — the product team, the customer, a third party?

**Ask this domain even when the human hasn't mentioned it.** Many products have data implications that the author hasn't considered because they're thinking about features, not data flows. Surface it rather than leaving it for an incident.

---

#### Domain F: Design & Experience

*What the product looks and feels like to use.*

- Are there existing design patterns, component libraries, or brand standards to follow?
- What are the most important moments in the user experience — what needs to feel effortless?
- Are there accessibility requirements (WCAG compliance, screen reader support, etc.)?
- What's the minimum viable UX for R1 vs. what gets polished in later phases?

This domain can be thin for early-stage discovery — that's fine. Flag it as an area that needs more input before authoring.

---

#### Domain G: Open Questions & Known Unknowns

*Explicitly surfacing what isn't known yet.*

After covering the other domains, ask:

- What do you not know yet that could materially change the approach?
- What decisions need to be made before building can start, and who makes them?
- What's the riskiest assumption you're currently making?
- Is there a domain we discussed where you'd want to loop in someone else before the PRD is finalized?

This last domain is where the skill's core value shows up. Many people have never been asked to explicitly name their unknown unknowns in a structured way. The act of naming them — even as "I don't know, this needs marketing input" — is the muscle the system is building.

---

### Phase 3: Produce the Discovery Brief

After the interview, synthesize everything into a Discovery Brief. This is the handoff artifact to `prd-author`.

```markdown
# Discovery Brief: [Product Name]
Date: YYYY-MM-DD
Prepared by: prd-discovery skill

---

## What We Know (Confirmed)

### Problem & Context
[Specific, evidence-grounded summary of the problem and why now]

### Users
[Primary user(s), sophistication level, key scenarios described]

### Commercial Context
[External / Internal / Not applicable — with specifics on buyer, pricing model, sales motion, competitive context]

### Technical Constraints
[Hard constraints, must-have integrations, compliance requirements, timeline]

### Data & Privacy
[Data types handled, PII status, analytics requirements]

### Design & Experience
[Existing patterns, key UX moments, accessibility requirements, R1 vs. later]

---

## What We Think (Inferences to Confirm)

[Assumptions made based on input that haven't been explicitly confirmed by the human. Each one should be verified in prd-author's Phase 2 or Phase 3.]

- [Inference 1]
- [Inference 2]

---

## Open Questions

| ID | Question | Domain | Owner | Notes |
|----|----------|--------|-------|-------|
| OQ-01 | [Question] | [Domain] | [Person/role who needs to answer this] | [Context] |
| OQ-02 | ... | | | |

---

## Domains Needing More Input

[Domains where discovery surfaced a gap but didn't fill it. Flag these for prd-author's interview phase.]

- **[Domain]:** [What's missing and why it matters]

---

## Recommended PRD Scope

Based on discovery, the following domains are likely relevant for Section 5:
- [Domain list]

The following can be omitted or deferred:
- [Domain list and reason]
```

---

### Phase 4: Present and Hand Off

Share the Discovery Brief with the human. Walk through:

- The open questions — confirm ownership and whether any are blockers.
- The inferences — get explicit confirmation or correction.
- The domains needing more input — agree on whether to wait for that input or proceed and flag the gaps.

If the human is ready to proceed: pass the Discovery Brief as the primary source input to `prd-author` (create mode). The brief replaces the need for `prd-author` to re-interview across all domains — it can focus its Phase 2 on confirming inferences and resolving any remaining gaps.

If critical open questions remain: document them in the brief and note that the PRD will be drafted with these flagged as `OQ-XX` entries needing resolution before those requirements can move to implementation.

---

## Quality Standards

A good Discovery Brief:

- **Names what isn't known.** An honest brief with 5 open questions is more valuable than a confident brief that papers over uncertainty.
- **Distinguishes confirmed from inferred.** The "What We Think" section prevents `prd-author` from treating assumptions as facts.
- **Is domain-complete.** Every domain was at least considered, even if the conclusion is "not applicable" or "needs more input."
- **Is evidence-grounded.** Confirmed facts reference the source (human answer, document, URL). Inferences are labeled as such.
- **Is actionable.** Open questions have owners. Domains needing more input say what specifically is missing.
