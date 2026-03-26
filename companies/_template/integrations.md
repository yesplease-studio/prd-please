# Integrations

Tool stack and MCP configuration for [Company Name]. Skills load this file to determine which integrations are available and adapt their behavior accordingly.

## Integration mapping

| Generic role | Tool | MCP | Used by | Status | Notes |
|---|---|---|---|---|---|
| docs | [e.g., Notion] | notion-mcp | PRD skills | not connected | [workspace URL] |
| project management | [e.g., Linear, Jira] | [e.g., linear-mcp] | prd-taskmaster | not connected | — |
| web search | — | web-search | prd-author, prd-learner | built-in | — |

## Setup instructions

To configure MCPs for this workspace:

```bash
# Example — replace with your actual tools and accounts
claude mcp add --transport http notion https://mcp.notion.com/mcp --scope project
# Authenticate with your accounts when prompted
```

## Skill behavior with missing integrations

Skills degrade gracefully when integrations are unavailable:

- **prd-author** without web search: works from provided context only, cannot fetch URLs.
- **prd-taskmaster** without project management: outputs task backlog as markdown instead of creating tickets.
