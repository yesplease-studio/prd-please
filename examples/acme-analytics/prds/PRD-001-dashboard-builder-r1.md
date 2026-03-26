---
id: PRD-001
title: "Acme Analytics — Visual Dashboard Builder (R1)"
product: "Acme Analytics"
area: dashboard-builder
status: active
phase: R1
priority: P0
owner: sarah.chen
contributors:
  - james.ko
  - priya.patel
depends_on: []
labels:
  - core-product
  - self-serve
  - warehouse-native
links:
  repo: https://github.com/acme-analytics/dashboard-builder
  design: https://figma.com/file/example
created_at: 2026-01-20
updated_at: 2026-02-15
---

# PRD-001: Acme Analytics — Visual Dashboard Builder (R1)

---

## 1. Context & Problem

Acme Analytics lets product teams query their warehouse directly for product analytics. Today, that means writing SQL or using pre-built templates (retention, funnel, cohort). Power users — data engineers and technical PMs — are productive. But the majority of product managers, designers, and executives cannot write SQL and rely on the data team to pull numbers for them.

This recreates the exact bottleneck Acme was built to eliminate: product people waiting on technical people for answers.

The visual dashboard builder solves this by giving non-technical users a drag-and-drop interface for building dashboards from pre-defined metrics and dimensions — without writing SQL, but with every chart backed by a transparent, editable SQL query under the hood.

Three specific problems:

1. **Self-serve adoption is blocked.** 60% of users who sign up never create a query. Post-onboarding surveys cite "I don't know SQL" as the primary reason. The product is warehouse-native but not team-native.

2. **Data teams become bottlenecks.** Champions (data engineers) who brought Acme in are fielding 5-10 ad hoc requests per week from PMs. This is unsustainable and threatens retention — if the champion burns out or leaves, the account churns.

3. **Competitive gap.** Mixpanel and Amplitude offer visual builders as a core feature. Prospects evaluating Acme consistently flag the lack of a no-code interface as a blocker for team-wide adoption.

---

## 2. Goals, Non-Goals & Success Metrics

### Goals (R1)

| # | Goal | Phase |
|---|------|-------|
| G-01 | Non-technical users can create dashboards with charts, filters, and date ranges without writing SQL | R1 |
| G-02 | Every visual chart maps to a visible, editable SQL query — preserving Acme's SQL-first principle | R1 |
| G-03 | Dashboards can be shared via URL with view-only or edit permissions | R1 |
| G-04 | Pre-built metric definitions (DAU, retention, funnel conversion) are available as building blocks | R1 |
| G-05 | Dashboard queries respect existing warehouse row-level security — no separate permission model | R1 |

### Non-Goals (R1)

- Real-time streaming dashboards (batch refresh is sufficient for R1)
- Embedded analytics / iframe embedding for customer-facing dashboards (planned R2)
- Alerting or threshold notifications on dashboard metrics
- Mobile-optimized dashboard viewing
- Custom visualization types beyond line, bar, area, table, and number

### Success Metrics (R1)

| Metric | Target | How to measure |
|--------|--------|----------------|
| Non-SQL users creating dashboards | ≥ 30% of active users with no prior SQL queries create a dashboard within 30 days | Product analytics (Acme on Acme) |
| Ad hoc requests to data team | 50% reduction in Slack requests for data pulls (measured via champion survey) | Quarterly champion survey |
| Dashboard adoption | ≥ 3 dashboards created per account within 60 days of feature launch | Product analytics |
| SQL visibility engagement | ≥ 20% of visual dashboard users click "View SQL" at least once | Product analytics |

---

## 3. Users & Scenarios

### User Roles

- **Product Manager (non-technical):** Needs to track feature adoption, funnel conversion, and retention without asking the data team. Can't write SQL.
- **Data Engineer / Analytics Engineer (champion):** Set up Acme, defined the event schema, and wants to empower the PM to self-serve. Will define metrics and validate dashboards.
- **Executive (viewer):** Wants a link they can open weekly to see key metrics. Will never build anything themselves.

### User Stories

- US-01 (PM, R1, must): As a product manager, I want to create a dashboard by selecting pre-defined metrics and dimensions so that I can track feature adoption without writing SQL.
- US-02 (PM, R1, must): As a product manager, I want to filter dashboard charts by date range, user segment, and event properties so that I can answer specific questions.
- US-03 (Data Engineer, R1, must): As a data engineer, I want to define reusable metric definitions (SQL-backed) that PMs can use in dashboards so that the numbers are consistent and governed.
- US-04 (Data Engineer, R1, should): As a data engineer, I want to see the SQL behind any visual chart so that I can verify it's querying the right tables and joins.
- US-05 (Executive, R1, must): As an executive, I want to receive a shared dashboard link that loads current data without requiring me to log in or configure anything so that I can review metrics weekly.
- US-06 (PM, R1, should): As a product manager, I want to duplicate an existing dashboard and modify it so that I can create variants for different features without starting from scratch.

### Scenarios

**Scenario A — PM builds a feature adoption dashboard:**
Sarah, a PM at a Series A SaaS company, logs into Acme. She clicks "New Dashboard," sees a list of pre-defined metrics (DAU, feature activation rate, 7-day retention). She drags "Feature Activation Rate" onto the canvas, selects the "onboarding_completed" event, and filters by users who signed up in the last 30 days. She adds a line chart for DAU and a table showing top events by volume. She names the dashboard "Onboarding Health" and shares the link with her team lead.

**Scenario B — Data engineer defines a governed metric:**
James, the data engineer who set up Acme, notices PMs are building dashboards with inconsistent retention definitions. He opens the Metrics Library, creates a new metric called "D7 Retention" with the SQL: `COUNT(DISTINCT user_id) WHERE event = 'session_start' AND datediff(day, first_seen, event_date) = 7`. He marks it as "verified." PMs now see this metric in their dashboard builder with a verified badge.

**Scenario C — Executive reviews weekly metrics:**
The CEO bookmarks the "Company KPIs" dashboard link Sarah shared. Every Monday morning, she opens the link. The dashboard loads with current data (refreshed overnight). She sees DAU trending up, retention flat, and funnel conversion improving. She screenshots the retention chart and pastes it into the board update doc.

---

## 4. Solution Overview

The dashboard builder is a new frontend module within the existing Acme Analytics web application. It sits alongside the existing SQL editor and template views.

### Components

- **Dashboard Canvas:** A grid-based layout where users place and arrange chart widgets. Supports drag, resize, and reorder.
- **Chart Builder:** A visual form for configuring a single chart — select metric, dimensions, filters, chart type, date range. Generates SQL under the hood.
- **Metrics Library:** A registry of reusable, SQL-backed metric definitions created by data engineers. Each metric has a name, description, SQL definition, and verified/unverified status.
- **Sharing & Permissions:** Dashboards have a unique URL. Permissions: owner (edit + share), editor (edit), viewer (view only). Permissions inherit from warehouse RLS — a viewer who doesn't have access to a table sees "Permission denied" for that chart, not the data.
- **SQL Transparency Layer:** Every chart has a "View SQL" toggle that shows the generated query. Editable for users with SQL permissions.

### Data flow

```
User configures chart visually
    → Chart Builder generates SQL
    → SQL executes against warehouse (Snowflake/BigQuery)
    → Results rendered as chart
    → Dashboard saves chart config (not data) to Acme metadata store
```

Dashboards store configuration, not cached results. Every load executes fresh queries against the warehouse (with query caching at the warehouse level).

---

## 5. Requirements by Domain

### 5.1 Product

| ID | Severity | Requirement | Acceptance Criteria | Phase |
|----|----------|-------------|---------------------|-------|
| PROD-01 | must | Dashboard canvas supports grid-based layout with drag, resize, and reorder of chart widgets | User can place 3 charts, resize one to half-width, and reorder by dragging | R1 |
| PROD-02 | must | Chart builder offers visual configuration: metric selection, dimension selection, filter builder, date range picker, and chart type selector | A user with no SQL knowledge can create a line chart of DAU filtered by country in under 2 minutes | R1 |
| PROD-03 | must | Metrics Library displays all defined metrics with name, description, and verified/unverified badge | Data engineer can create a metric; PM sees it in the builder with correct metadata | R1 |
| PROD-04 | must | Dashboards are shareable via unique URL with three permission levels: owner, editor, viewer | Owner shares link; viewer can see charts but not edit; editor can modify charts | R1 |
| PROD-05 | must | Every chart has a "View SQL" toggle showing the generated query | Clicking "View SQL" on any chart shows syntactically valid SQL matching the visual configuration | R1 |
| PROD-06 | should | Users can duplicate an existing dashboard | Clicking "Duplicate" creates a copy with "(Copy)" appended to the title, owned by the duplicating user | R1 |
| PROD-07 | should | Dashboard supports auto-refresh intervals (5m, 15m, 30m, 1h) for live monitoring | User selects 15m refresh; dashboard re-executes queries every 15 minutes without page reload | R1 |

### 5.2 Tech

| ID | Severity | Requirement | Acceptance Criteria | Phase |
|----|----------|-------------|---------------------|-------|
| TECH-01 | must | Chart builder generates valid SQL for both Snowflake and BigQuery dialects | Same visual configuration produces correct SQL for each warehouse type; query executes without syntax errors | R1 |
| TECH-02 | must | Dashboard metadata (layout, chart configs, permissions) stored in Acme's Postgres metadata store, not in the customer's warehouse | Dashboard config persists across sessions; no tables created in customer warehouse | R1 |
| TECH-03 | must | Query execution timeout of 30 seconds per chart; timed-out charts show clear error with "View SQL" option | Chart that exceeds 30s shows "Query timed out" with the generated SQL for debugging | R1 |
| TECH-04 | must | Dashboard load queries execute in parallel (max 6 concurrent) | A dashboard with 6 charts loads all charts concurrently; total load time ≈ slowest individual chart, not sum | R1 |
| TECH-05 | should | SQL generation uses parameterized queries to prevent injection | All filter values are parameterized; manual SQL injection test passes | R1 |

### 5.3 Data

| ID | Severity | Requirement | Acceptance Criteria | Phase |
|----|----------|-------------|---------------------|-------|
| DATA-01 | must | Dashboard queries respect warehouse row-level security | A viewer without access to table X sees "Permission denied" on charts querying table X, not empty results | R1 |
| DATA-02 | must | Metric definitions are stored with their SQL and are version-tracked | Editing a metric creates a new version; dashboards using the metric auto-update to latest version | R1 |
| DATA-03 | should | Query results are cached at the warehouse level (not in Acme) for repeated identical queries | Two users viewing the same dashboard within the cache window don't trigger duplicate warehouse queries | R1 |

### 5.4 Design

| ID | Severity | Requirement | Acceptance Criteria | Phase |
|----|----------|-------------|---------------------|-------|
| DES-01 | must | Chart builder is usable by someone who has never written SQL | Usability test: 3/5 non-technical participants can create a filtered line chart without guidance in under 3 minutes | R1 |
| DES-02 | must | Dashboard canvas is responsive down to 1024px viewport width | All charts remain readable and interactive at 1024px; no horizontal scrolling | R1 |
| DES-03 | should | Chart types include: line, bar, area, table, single number | Each chart type renders correctly with sample data | R1 |
| DES-04 | should | Dashboard has a presentation mode (full-screen, no chrome) for meetings | Clicking "Present" hides navigation and edit controls; ESC exits | R1 |

---

## 6. Guardrails

### DO

- **Generate SQL through a structured AST, not string concatenation.** The chart builder must produce SQL via an abstract syntax tree that is then rendered to dialect-specific SQL. This prevents injection and ensures correctness across warehouse types.
- **Show the SQL. Always.** Every chart must have an accessible "View SQL" path. This is a core product principle — Acme is SQL-first, even when the interface is visual. Never hide the query.
- **Fail visibly per-chart, not per-dashboard.** If one chart's query fails (timeout, permission error, syntax error), show the error on that chart. Other charts on the dashboard must still render.
- **Inherit warehouse permissions. Do not re-implement access control.** Dashboard sharing controls who can see/edit the dashboard config. Data access is governed by the warehouse. Acme must never bypass or duplicate RLS.

### DON'T

- **Don't cache query results in Acme's infrastructure.** Caching happens at the warehouse level. Acme stores chart configuration, not data. This maintains the single-source-of-truth principle and avoids stale data issues.
- **Don't allow metric definitions to be deleted if dashboards reference them.** Soft-delete or archive with a warning. Deleting a metric must not break existing dashboards.
- **Don't create tables, views, or materialized views in the customer's warehouse.** Acme is read-only against customer data. Dashboard metadata lives in Acme's own Postgres store.
- **Don't require a separate login or permission setup for dashboard viewers.** Viewers authenticate through the existing Acme auth flow. Shared links use the viewer's existing warehouse credentials for data access.

---

## 7. Risks & Open Questions

### Risks

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Query costs spike when PMs create dashboards with expensive queries they don't understand | High — customer gets a surprise warehouse bill | Medium | Show estimated query cost before execution; add a per-dashboard query budget with warnings |
| SQL generation produces incorrect results for edge cases (NULLs, timezone handling, dialect differences) | High — erodes trust in the product | Medium | Comprehensive test suite against both Snowflake and BigQuery with known-answer tests; beta program with 5 accounts |
| Non-technical users still find the builder too complex and don't adopt | Medium — feature investment doesn't move adoption metrics | Low | Usability testing in R1; pre-built dashboard templates for common use cases |
| Metric versioning creates confusion when dashboards auto-update | Low — data engineers may not expect silent updates | Medium | Show "metric updated" indicator on charts using a recently modified metric; allow pinning to a specific version |

### Open Questions

| ID | Question | Owner | Target Date |
|----|----------|-------|-------------|
| OQ-01 | Should shared dashboard links require authentication, or support public (unauthenticated) viewing? Public links are convenient for board decks but create a data exposure risk. | sarah.chen | 2026-02-01 |
| OQ-02 | Should we support calculated fields (e.g., "Activation Rate = activated_users / total_users") in the visual builder, or require these as defined metrics? | james.ko | 2026-02-01 |
| OQ-03 | What's the query cost visibility UX? Show estimated cost before execution, after execution, or both? | priya.patel | 2026-01-28 |

---

## 8. Learnings

### L-001 (2026-02-10): Timezone handling must be explicit in all date-based queries

**What happened:** During beta testing, a customer reported that their "Daily Active Users" chart showed different numbers than their internal Looker dashboard. Root cause: Acme's SQL generation used UTC for date truncation, while the customer's Looker models used `America/New_York`. The numbers diverged by 8-15% depending on the day.

**Classification:** New guardrail + tightened requirement.

**Changes applied:**
- Added TECH-06 (not shown — would be added in a real amendment): "All date-based SQL generation must include an explicit timezone parameter. Default to the account's configured timezone, not UTC."
- Added guardrail: "DON'T assume UTC for date truncation. Always use the account-level timezone setting. Show the active timezone in the chart's date range picker."

**Why this matters:** Analytics tools live or die on number accuracy. A 10% discrepancy in DAU destroys trust permanently. This is especially dangerous because the numbers are plausible — nobody notices until they compare against another source.

### L-002 (2026-02-14): Metric definitions need descriptions and example values, not just SQL

**What happened:** PMs in the beta reported that the Metrics Library was "intimidating." They could see metric names and SQL definitions but couldn't tell what the metric actually measured or what values to expect. Adoption of the Metrics Library was 15% vs. the 50% target.

**Classification:** Tightened requirement.

**Changes applied:**
- Tightened PROD-03: Metric definitions now require a plain-language description (mandatory) and an example value with context (e.g., "Typical range: 20-40% for B2B SaaS"). SQL is shown but collapsed by default.

**Why this matters:** The Metrics Library is the bridge between data engineers and PMs. If PMs can't understand what a metric means without reading SQL, the self-serve goal fails.
