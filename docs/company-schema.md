# COMPANY.md Schema

This is the complete schema for company profiles. PRD skills load this file at runtime to understand the product context, users, and constraints. Not every section is required — skills handle missing sections gracefully.

---

## Template (companies/_template/COMPANY.md)

```markdown
---
company: [Company Name]
product: [One-line product description]
website: [URL]
industry: [Industry / vertical]
stage: [Seed | Series A | Series B | Growth | Enterprise]
created_at: [YYYY-MM-DD]
---

# [Company Name]

## Product context

### What it is

[1-2 sentences. What the product does, for whom, and why it matters.]

### Key capabilities

[The 5-8 capabilities that matter for product decisions.]

- **[Capability]:** [One sentence on what it does and why it matters]

### Differentiators

[What makes this genuinely different from alternatives. Be specific.]

### Current state

[What's live, what's in beta, what's on the near-term roadmap.]

- Live: [features/capabilities]
- Beta: [features/capabilities]
- Coming soon: [features/capabilities]

### Technical constraints

[Stack, infrastructure, third-party dependencies, compliance needs.]

### Never mention publicly

[Sensitive context that should not surface in PRD outputs, user-facing copy, or
artifacts shared outside the team. Hard exclusion list for skills.]


## Users

### Primary: [User segment name]

- **Who they are:** [Role, technical sophistication, company context]
- **The problem they feel:** [Specific pain, in their words]
- **What they're doing about it today:** [Current tools, workarounds]
- **What makes them look for a solution:** [Buying triggers]
- **Language they use:** [Verbatim phrases this segment uses]
- **Where they spend time:** [Channels, communities, platforms]
- **Hook:** [One sentence that would make them stop scrolling]

### Secondary: [User segment name]

[Same structure as primary.]


## Competitor landscape

### [Competitor 1 name]

- **What they offer:** [Brief — their positioning, not yours]
- **Where they're strong:** [Honest assessment]
- **Where we differentiate:** [Specific, factual differences]
- **Talk track:** [How to position against them when differentiation matters in product copy]

### [Competitor 2 name]

[Same structure. Typically 3-5 key competitors.]
```

---

## Schema notes

### Required vs. optional sections

For a company profile to be minimally functional, these sections must be filled in:

| Section | Required for | Why |
|---------|-------------|-----|
| Frontmatter (company, product) | All skills | Identity |
| Product context (what it is + capabilities) | All PRD skills | Accurate scoping |
| Users (at least primary) | prd-author | User stories and requirements |

Everything else enriches output quality but isn't blocking. Skills should handle missing sections gracefully — if no competitor landscape exists, skip competitor references rather than hallucinating.

### How skills use this file

Skills read the full COMPANY.md and extract what's relevant:

- **prd-author** reads: Product context, Users, Competitor landscape, Technical constraints
- **prd-taskmaster** reads: Product context, Current state, Technical constraints
- **prd-validator** reads: Product context, Technical constraints
- **prd-learner** reads: Product context, Users

### Progressive population

A new company profile doesn't need to be complete on day one. The natural flow:

1. **Day 1:** Fill in frontmatter and product context. Enough for initial PRD authoring.
2. **Week 1:** Add user definitions and competitor landscape as discovery reveals them.
3. **Ongoing:** Refine and extend as the engagement matures. The company profile is a living document.

### Relationship to deployed instances

When deploying a standalone company instance, `companies/<company>/COMPANY.md` gets promoted to the root as `COMPANY.md`. The CLAUDE.md in the deployed instance references it at root level instead of inside a `companies/` directory. The content is identical — only the path changes.
