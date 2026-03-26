# First-Time Setup

Follow these steps to get {{COMPANY_SLUG}}-systems running on your machine. You only need to do this once.

## 1. Install Claude Code

If you don't have Claude Code installed yet:

```bash
npm install -g @anthropic-ai/claude-code
```

You'll need Node.js 18+ installed. If you don't have it, download it from [nodejs.org](https://nodejs.org).

## 2. Clone the repo

```bash
git clone <repo-url>
cd {{COMPANY_SLUG}}-systems
```

## 3. Open Claude Code

```bash
claude
```

Claude will automatically load all {{COMPANY_NAME}} context from the first message.

## 4. Verify it works

Open Claude Code and ask:

> "What skills are available?"

You should see the 4 PRD skills listed.

## 5. You're done

Start using skills by describing what you want. Claude will trigger the right skill automatically. See `README.md` for example prompts.
