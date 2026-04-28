---
type: companion
skill: prd-onboard
artifact: [path/to/companies/slug/COMPANY.md]
date: YYYY-MM-DD
---

# Company Profile Companion: [company slug]

This document explains why COMPANY.md is structured the way it is and how to keep it useful as the company evolves.

---

## Why voice

[Why "Language they use" is a verbatim field, not a paraphrase. What prd-author and other downstream skills do with the exact words your users use -- they show up in user stories, acceptance criteria, and product copy as-written. What a cleaned-up paraphrase would cost: generic user stories, copy that sounds like the tool not the customer. Name one specific phrase from this company profile that should never be sanitized or abstracted away, and say why.]

---

## Why structure

[What each COMPANY.md section is doing for downstream skills. Why product context comes before users (skills need to know what exists before they can reason about who uses it). Why "Never mention publicly" is a hard field, not a style preference (skills treat it as an exclusion list, not guidance). Name one or two specific sections that will be most load-bearing for prd-author when the first PRD is written for this company -- the sections where thin answers will directly degrade the output.]

---

## What to reuse

[The most useful framings that landed during the onboarding walk. Specific distinctions that made ICP, differentiators, or constraints clearer. Write as reusable frames:

- "The ICP splits by buying role vs. using role -- the person who signs the contract is not the person using the product daily. PRD user stories need both."
- "The differentiator is speed of onboarding, not feature breadth. Any requirement that adds complexity to onboarding needs extra justification."

Each entry should be one or two sentences. These are the insights that should survive into the first PRD without needing to re-derive them.]

---

## Do-it-yourself

[How to update COMPANY.md as the company evolves, without re-running onboarding. Which sections change most often (ICP evolves as the product finds its audience; current state changes every quarter; competitors shift). When to mark a section as tentative vs. updating it with new information. The trigger for a full re-onboard: when the primary user segment changes materially, when the product pivots, or when "what it is" no longer matches what the team actually ships.]
