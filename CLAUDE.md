# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Stratoma AI Stack is a containerized AI operations infrastructure (Docker Compose). It deploys Paperclip (AI agents), n8n (workflow automation), Supabase (self-hosted DB + auth), and OpenClaw (WhatsApp/Telegram gateway) as Docker services.

## Common Commands

```bash
# Initial setup
cp .env.example .env
# Edit .env with your API keys, then:
./scripts/setup.sh

# Start/stop services
docker-compose up -d
docker-compose down

# Health check
./scripts/health-check.sh

# Create a new client/company (seeds agents + installs skills)
./scripts/create-company.sh "Client Name" "client-slug"

# Re-install skills for an existing company
./scripts/install-skills.sh <company_id>
```

## Architecture

```
paperclip (:3100)     ← AI agents + skills; backed by PostgreSQL (paperclip-db)
n8n (:5678)           ← Workflow automation; backed by PostgreSQL (n8n-db)
supabase-kong (:8000) ← API gateway (auth + REST)
supabase-db          ← PostgreSQL 15
supabase-auth        ← GoTrue auth service
supabase-rest        ← PostgREST
openclaw (:18789)     ← Telegram/WhatsApp bot gateway
```

Services communicate internally on the `stratoma-network` Docker network. External SaaS integrations: GoHighLevel (CRM), Gmail/Google Workspace, WhatsApp (AppLevel via GHL + Meta Official API).

## Key Paths

- `docker-compose.yml` — service definitions, ports, healthchecks, volumes
- `.env.example` — all environment variables documented
- `paperclip/agents/roster.yaml` — 9 default agents; seeded per-company by `create-company.sh`
- `paperclip/skills/catalog.yaml` — skills installed per-company via Paperclip API
- `paperclip/stratoma-default/.mcp.json` — MCP config (ruflo, n8n-mcp, github, coolify) mounted read-only into Paperclip container
- `n8n/workflows/` — 16 n8n workflow JSON files; mounted read-only into n8n container at `/workflows`
- `openclaw/openclaw.template.json` — bot gateway config template

## Key Patterns

- **Company bootstrapping**: `create-company.sh` calls Paperclip REST API to create a company, then installs skills from `catalog.yaml` and seeds agents from `roster.yaml`
- **Per-company isolation**: each company gets its own agents and skill configuration via the Paperclip API
- **n8n workflows**: JSON files in `n8n/workflows/` are mounted directly into the n8n container; import via n8n UI
- **MCP servers**: All agents get ruflo (orchestration), n8n-mcp (workflow management), github, and coolify MCPs via the shared `.mcp.json`
- **OpenClaw config**: `openclaw/openclaw.json` is mounted into the container at runtime; regenerate from template if needed
- **Supabase kong.yml**: referenced in docker-compose at `./supabase/kong.yml` but must be created or sourced separately
