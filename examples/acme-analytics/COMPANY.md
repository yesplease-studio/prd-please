---
company: Acme Analytics
product: Self-serve product analytics for B2B SaaS
website: https://acme-analytics.example.com
industry: Developer tools / analytics
stage: Series A
engagement_type: engine
active_since: 2026-01-15
---

# Acme Analytics

## Brand voice

### Personality

Speaks like a senior data engineer who's tired of bloated analytics tools and built something better. Technical confidence without arrogance. Explains complex things plainly because the audience is smart — they just don't have time to decode marketing jargon.

### Voice attributes

- **Direct and technical** — Uses precise terminology. Says "event ingestion latency" not "speed." Says "retention cohort" not "user engagement."
- **Opinionated** — Has clear positions on how analytics should work. Doesn't hedge with "it depends."
- **Show, don't claim** — Leads with what the product does, not superlatives about how great it is.
- **Conversational but not casual** — Writes like a knowledgeable colleague, not a brand or a textbook.

### Phrasings to use

| How we'd say it | How we wouldn't say it |
|-----------------|----------------------|
| "Query your events in SQL. No proprietary language." | "Our powerful query engine lets you unlock insights." |
| "Set up tracking in 15 minutes. Ship the SDK, define events, see data." | "Get started quickly with our easy onboarding experience." |
| "We store raw events. You decide how to slice them." | "Our flexible platform adapts to your unique needs." |

### Banned phrases (company-specific)

- "Actionable insights" — meaningless; every analytics tool claims this
- "Single pane of glass" — overused enterprise jargon
- "Data-driven" — table stakes, not a differentiator
- "Best-in-class" — unverifiable claim

## ICP definitions

### Primary: B2B SaaS product teams (Seed to Series B)

- **Who they are:** 10-80 person B2B SaaS companies. Product manager or technical founder making the analytics decision. Engineering team of 5-20.
- **The problem they feel:** "We set up Mixpanel/Amplitude two years ago. Half the events are broken. Nobody trusts the dashboards. The PM asks engineering to pull data from the database instead."
- **What they're doing about it today:** A mix of Mixpanel/Amplitude (partially set up), raw SQL queries against the production database, and spreadsheets for board reporting.
- **What makes them look for a solution:** A new PM joins and can't get answers. Board asks for metrics nobody can produce. The analytics tool contract is up for renewal.
- **Language they use:** "Our tracking is a mess." "We don't trust our numbers." "I just want to write SQL."
- **Where they spend time:** Hacker News, dev-focused Slack communities, Twitter/X (tech), product management podcasts.
- **Hook:** "Analytics that works like your database, not like a dashboard builder."
- **Key accounts:** [Redacted — add your own target accounts here]

### Secondary: Data engineers at mid-market SaaS

- **Who they are:** Data engineers or analytics engineers at 100-500 person SaaS companies. They own the data stack and are evaluating whether to build or buy product analytics.
- **The problem they feel:** "The product team wants self-serve analytics but everything integrates badly with our warehouse. I don't want to maintain another data silo."
- **What they're doing about it today:** dbt + Looker/Metabase on top of Snowflake/BigQuery. Product analytics tool runs separately, out of sync with warehouse metrics.
- **What makes them look for a solution:** A mandate to consolidate tools. A warehouse migration. The existing product analytics contract tripling in price.
- **Language they use:** "Warehouse-native." "I need it to work with our dbt models." "No more data silos."
- **Where they spend time:** dbt Community Slack, Data Engineering Weekly, LinkedIn data engineering circles.
- **Hook:** "Product analytics that lives in your warehouse, not next to it."

## Product context

### What it is

Self-serve product analytics built on top of your existing data warehouse. Instead of ingesting events into a proprietary store, Acme Analytics queries your warehouse directly — giving product teams dashboards and funnels while data teams keep full control of the data.

### Key capabilities

- **Warehouse-native architecture:** Queries Snowflake, BigQuery, or Postgres directly. No data duplication.
- **SQL-first interface:** Every chart is a SQL query under the hood. Power users can edit directly; non-technical users use the visual builder.
- **Event SDK:** Lightweight SDK for web and mobile that writes events to your warehouse via a managed ingestion pipeline.
- **Pre-built product templates:** Retention, funnel, and cohort analyses ship as templates. Modify or build from scratch.
- **Access controls:** Row-level security inherited from your warehouse permissions. No separate user management.

### Differentiators

- No proprietary data store — your events live in your warehouse, queryable by any tool in your stack.
- SQL-native — no proprietary query language to learn. If you know SQL, you know Acme.
- Pricing based on queries, not tracked users — predictable costs that don't spike with growth.

### Current state

- Live: Snowflake and BigQuery connectors, web SDK, visual query builder, retention/funnel templates
- Beta: Postgres connector, mobile SDK (React Native)
- Coming soon: dbt integration, alerting, embedded analytics

### Never mention publicly

- Postgres connector is in closed beta with 3 customers
- Series B fundraise planned for Q3 2026
- Enterprise pricing tier under development

## Competitor landscape

### Mixpanel

- **What they offer:** Event-based product analytics with visual UI, funnel/retention analysis, A/B test integration.
- **Where they're strong:** Brand recognition. Large ecosystem of integrations. Non-technical users can self-serve.
- **Where we differentiate:** We don't duplicate data — Mixpanel ingests into their proprietary store. Our SQL interface gives power users direct access. Our pricing scales with queries, not MTUs.
- **Talk track:** "Mixpanel is great if your data team is happy maintaining a separate data silo. If you want analytics that lives in your warehouse and speaks SQL, that's us."

### Amplitude

- **What they offer:** Similar to Mixpanel. Stronger on behavioral cohorts and experimentation.
- **Where they're strong:** Experimentation platform. Large enterprise customer base.
- **Where we differentiate:** Same as Mixpanel — data ownership and SQL-native interface. Amplitude's pricing is also MTU-based, which gets expensive fast.
- **Talk track:** "Amplitude is powerful but it's a walled garden. If your data team already has a warehouse strategy, Acme fits into it instead of competing with it."

### Looker / Metabase (BI tools)

- **What they offer:** General-purpose BI on top of warehouses. Not product analytics specifically.
- **Where they're strong:** Flexible. Already deployed at many companies. Data teams know them.
- **Where we differentiate:** We're purpose-built for product analytics — funnels, retention, cohorts out of the box. Building these in Looker requires significant custom LookML.
- **Talk track:** "You can build product analytics in Looker, but you'll spend weeks on LookML that we ship as templates. Keep Looker for business reporting, use Acme for product."

