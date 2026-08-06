---
human_edit_tracking:
  enabled: true
  history: []
---
# Composable parts

Setup times below are planning guesses for an experienced developer with working provider accounts. They exclude vendor approval, OAuth verification, and empirical forecast calibration.

## Source adapters

### Existing `gog`: best first adapter here

The workspace already has [openclaw/gogcli](https://github.com/openclaw/gogcli) installed. It covers Gmail, Calendar, Drive, Docs, Tasks, and other Google services through:

- stable JSON and plain-text CLI output;
- read-only and command allowlist controls;
- Gmail watch/history and Drive changes;
- calendar events and free/busy;
- a typed MCP server that is read-only by default.

This avoids another OAuth broker for a personal Google-first prototype. It is third-party open source, not a Google product. Use its supported cursors and provider IDs, but keep the forecast database independent of it.

The CLI and help were inspected locally; no account data was read. Safe smoke commands:

```bash
gog --readonly --no-input --wrap-untrusted --json \
  calendar events --from 2026-09-01 --to 2026-09-08 --all
gog --readonly --no-input --wrap-untrusted --json \
  gmail search 'newer_than:7d' --max 10
gog --readonly --no-input --wrap-untrusted --json drive ls --max 10
gog --readonly --no-input --wrap-untrusted docs cat DOC_ID
gog --readonly --no-input mcp --list-tools
```

### Direct Google APIs: best production adapter for Google

Calendar supports [incremental sync](https://developers.google.com/workspace/calendar/api/guides/sync): save `nextSyncToken`, process additions, changes, and deletions, and do a new full sync after `410 Gone`. [Push channels](https://developers.google.com/workspace/calendar/api/guides/push) are expiring change hints, not event payloads; renew them and then reconcile through the sync token.

The same pattern exists across the other evidence sources:

- Gmail initial fetch plus [`historyId`](https://developers.google.com/workspace/gmail/api/guides/sync); renew [Pub/Sub watch](https://developers.google.com/workspace/gmail/api/guides/push) at least every seven days;
- Drive [changes collection](https://developers.google.com/workspace/drive/api/guides/manage-changes);
- Docs [`documents.get`](https://developers.google.com/workspace/docs/api/reference/rest/v1/documents/get) or Drive export to text/Markdown.

Google also offers official remote MCP servers for [Calendar](https://developers.google.com/workspace/calendar/api/guides/configure-mcp-server), [Gmail](https://developers.google.com/workspace/gmail/api/guides/configure-mcp-server), and [Drive](https://developers.google.com/workspace/drive/api/guides/configure-mcp-server). They are in Developer Preview: use them for agent trials, not as the only ingestion path.

Time: 30–60 minutes for one OAuth list-events proof; 1–2 days for cursors, channel renewal, deletion recovery, and tests.

### Nylas: best multi-provider adapter

[Nylas Calendar API](https://developer.nylas.com/docs/v3/calendar/) normalizes Google, Microsoft, Exchange, iCloud, Yahoo, and virtual calendars. It adds event CRUD, recurring events, availability, RSVP, room resources, webhooks, a hosted scheduler, a [CLI and MCP](https://developer.nylas.com/docs/dev-guide/mcp/). The full platform can include email through the same provider.

Its free sandbox allows five accounts. The live [pricing](https://www.nylas.com/pricing/) currently lists calendar at $10/month including five accounts and the calendar-plus-email platform at $15/month including five; check [billing semantics](https://developer.nylas.com/docs/support/billing/) because any grant present during a month counts.

Use it when the first useful version must support Google plus Microsoft or iCloud. Expect 1–2 hours for a sandbox and 1–2 days for durable webhook ingestion.

### Microsoft Graph: direct Outlook adapter

Use [`calendarView/delta`](https://learn.microsoft.com/en-us/graph/api/event-delta?view=graph-rest-1.0) to track additions, updates, and deletions in a defined window. [Change-notification subscriptions](https://learn.microsoft.com/en-us/graph/outlook-change-notifications-overview) expire and require lifecycle recovery; delta sync closes missed-notification gaps. [`getSchedule`](https://learn.microsoft.com/en-us/graph/api/calendar-getschedule?view=graph-rest-1.0) returns free/busy for people and resources, but delegated personal accounts have limitations.

Choose direct Graph only if Microsoft is a source of truth and avoiding Nylas is worth roughly 2–4 days of correct subscription and delta handling.

### Cronofy: technically strong, economically wrong here

Cronofy has rich availability rules, buffers, resource scheduling, push notifications, libraries, and a [hosted MCP](https://www.cronofy.com/developer/mcp-server). Its normal external-event window is [42 days back and 201 days forward](https://docs.cronofy.com/developers/api/events/read-events/), so history still has to be archived locally.

Production [API pricing](https://www.cronofy.com/api-pricing) starts at $819/month billed annually. Reconsider it only for a multi-user product whose enterprise scheduling rules justify more than $10,000 per year.

### Morgen API: optional normalization plus planning

Morgen's [early-access API](https://docs.morgen.so/) unifies event and task CRUD across several providers. It is a reasonable shortcut when Morgen is also the chosen daily planner. Nylas is the stronger neutral ingestion service; direct APIs retain more provider detail.

## Booking and action surfaces

### Cal.com

[Cal.com API v2](https://cal.com/docs/api-reference/v2/introduction), its CLI, and the [34-tool MCP](https://cal.com/docs/mcp-server) are excellent for bookings, event types, schedules, slots, busy times, and rescheduling. [Atoms](https://cal.com/docs/platform/introduction) embed booking and availability controls.

Cal.com is not a provider-neutral change stream for every calendar event. Add it as a booking/action surface after the ledger exists. Its managed-user Platform stopped taking new signups during restructuring in December 2025; ordinary hosted accounts, OAuth, API, CLI, MCP, and self-hosting remain separate options.

### Calendly

Keep the existing `calendly/` project responsible for public availability, invitations, and meeting links. Ingest its resulting Google Calendar events like any other hard booking. This project should not duplicate booking-page logic.

## Automation and connector brokers

### n8n: best workflow runner

[n8n](https://github.com/n8n-io/n8n) is self-hostable, model-neutral, supports custom JavaScript or Python, and has more than 1,500 integrations. It can [call MCP servers](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-langchain.mcpclient) and [expose workflows as MCP tools](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-langchain.mcptrigger).

Run `npx n8n` for a one-to-three-hour trial. Use it for visible triggers, retries, and branching; keep accepted commitments in SQLite/Postgres rather than workflow execution history.

### Composio: best agent connector broker

[Composio](https://github.com/ComposioHQ/composio) supplies managed OAuth and agent tools across OpenAI, Anthropic, and common frameworks. [Composio Connect](https://docs.composio.dev/docs/composio-connect) exposes one MCP endpoint and its Google Super toolkit spans Gmail, Calendar, Drive, Docs, and Sheets.

This is the fastest path to many agent actions, not the analytical database. Restrict tools and scopes: a broad toolkit otherwise gives an extractor more authority than it needs.

### Pipedream

[Pipedream Connect MCP](https://pipedream.com/docs/connect/mcp) provides thousands of hosted API tools, managed OAuth, and custom code. Its [data stores](https://pipedream.com/docs/workflows/data-management/data-stores) are non-transactional key-value storage; use them for cursors or caches, never concurrent commitment updates.

Choose it over n8n when hosted code and long-tail connectors matter more than self-hosting.

### Zapier

[Zapier MCP](https://docs.zapier.com/mcp/home) and its Google integrations are the quickest no-code bridge. Every MCP tool call consumes two tasks, free polling can take 15 minutes, and task/result limits make historical ingestion awkward.

Use Zapier to deliver a small number of records into the ledger. Do not make Zapier Tables the forecasting state.

## AI providers

### OpenAI

The Responses API can call maintained connectors and arbitrary remote MCP through the [`mcp` tool](https://developers.openai.com/api/docs/guides/tools-connectors-mcp). Restrict `allowed_tools` and require approval for actions. [Structured Outputs](https://developers.openai.com/api/docs/guides/structured-outputs) can enforce the commitment schema; the [Apps SDK](https://developers.openai.com/plugins/build/chatgpt-ui) can render the heatmap beside MCP tools.

[Conversation state](https://developers.openai.com/api/docs/guides/conversation-state) is not a reconciled database. Store accepted facts externally and use `store:false` for stateless extraction where appropriate. Data sent to third-party MCP servers follows the third party's retention policy.

### Anthropic

Claude supports strict structured extraction, tool-use loops, and a [remote MCP connector](https://platform.claude.com/docs/en/agents-and-tools/mcp-connector). The API connector reaches public HTTP MCP, not local stdio. Its client-controlled [memory tool](https://platform.claude.com/docs/en/agents-and-tools/tool-use/memory-tool) is useful for preferences and notes, not canonical schedule state.

Claude's native [Google Workspace connectors](https://support.claude.com/en/articles/10166901-use-google-workspace-connectors) make a quick manual baseline across Gmail, Calendar, Drive, and Docs. They retrieve or act on explicit requests and do not maintain forecast history.

### Gemini

Gemini has the broadest native Google context: Gmail, Calendar, Drive, Docs, Tasks, Keep, Chat, and Meet through [Connected Apps](https://support.google.com/gemini/answer/14959807). It can find proposed dates or summarize project evidence with no custom adapter.

Use it to test discovery quality. It warns that answers may use outdated messages, does not publish deterministic capacity arithmetic, and can retain summaries, excerpts, and inferences according to [Personal Intelligence controls](https://support.google.com/gemini/answer/16836988).

## Display

### FullCalendar plus Cal-Heatmap: best pair

[FullCalendar Standard](https://fullcalendar.io/docs) is MIT, mature, and accepts arrays, functions, JSON, iCalendar, and Google event sources. Background events can shade capacity and custom views can combine event detail with weekly summaries. Premium resource timelines are unnecessary for one person.

[Cal-Heatmap](https://github.com/wa0x6e/cal-heatmap) is MIT and renders a GitHub-style time-series calendar at configurable day/week/month granularity. Use it for 3–12 months of expected or high-case utilization; click through to FullCalendar for evidence.

Time: under 90 minutes for a live event grid; about one day for polished load bands, uncertainty, and drill-down.

### Schedule-X

[Schedule-X](https://schedule-x.dev/docs/calendar) is the best modern-looking alternative. Its MIT core supports major frameworks, recurrence, agenda, and background events; resource views and the Scheduling Assistant are paid. Its MCP helps generate UI code and read docs, not access a user's calendar state.

### Other UI choices

- [Mobiscroll](https://mobiscroll.com/docs/react/eventcalendar/overview/) is the most polished commercial option and its separate Connect product adds provider sync; the scheduling UI starts around $995 per internal project.
- [React Big Calendar](https://github.com/jquense/react-big-calendar) is MIT and simple, but recurrence and analytical views require more custom work.
- [TOAST UI Calendar](https://github.com/nhn/tui.calendar) is MIT but its current package line is old and usage telemetry must be disabled explicitly.
- [DayPilot Lite](https://javascript.daypilot.org/calendar/) is Apache 2.0; resource scheduling is commercial.

## Self-hosted calendar stores

[Radicale](https://github.com/Kozea/Radicale) is a small GPLv3 CalDAV/CardDAV server with inspectable filesystem storage and post-write hooks. Use it if the system needs an owned calendar for soft holds or CalDAV interoperability. It has no end-user calendar UI, Google/Microsoft import, analytics, webhook, or MCP.

CalDAV sync tokens solve calendar interoperability, not forecasting. Keep event revisions and load facts in the analytical database even if Radicale becomes a canonical calendar.

## Allocation solver

Keep allocation as plain deterministic TypeScript while constraints are one person, working windows, deadlines, and splittable effort. Add a solver when more than roughly 50 flexible commitments, dependencies, alternative resources, or competing objectives make greedy allocation fail fixtures.

[OR-Tools CP-SAT](https://developers.google.com/optimization/cp/cp_solver) is the strongest code-level open-source option. [Timefold Solver](https://docs.timefold.ai/timefold-solver/latest/introduction) supplies higher-level planning models and a Java/Kotlin stack. Neither ingests calendars or defines “busy”; they only optimize a well-specified allocation model.

## Selection thresholds

- Google-only first version: `gog`, then direct Google APIs if a service replaces the local process.
- Google plus Outlook/iCloud now: Nylas.
- Bookings: existing Calendly, or Cal.com if its MCP/CLI becomes valuable.
- Cross-source workflow UI: n8n.
- Long-tail agent actions: Composio or Pipedream.
- Calendar detail plus long-range pressure: FullCalendar plus Cal-Heatmap.
- Enterprise scheduling above a $10,000/year infrastructure budget: evaluate Cronofy.
