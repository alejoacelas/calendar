---
human_edit_tracking:
  enabled: true
  history: []
---
# Full products

## Motion: best direct fit

**What works.** [Capacity Planning](https://www.usemotion.com/help/project-management/capacity-planning) combines work hours, busy events, and auto-scheduled tasks; it shows free, overbooked, or under-capacity days and weeks across any 7–90-day range. [The formula](https://www.usemotion.com/help/project-management/capacity-planning/capacity-planning-faq) is explicit. Motion continuously schedules estimated tasks around calendar events and exposes scheduling failures.

**Inputs.** Google, Microsoft, and iCloud calendars have read/write sync. Email can become a task by forwarding it; Siri and Zapier can create tasks. The [integration FAQ](https://www.usemotion.com/help/settings/integrations/integrations-faq) says Motion does not discover task-like emails automatically, read attachments, or offer native Notion, ClickUp, or Google Sheets integrations.

**Developer surface.** The REST API lists and changes tasks, projects, users, workspaces, schedules, and recurring tasks. [Task responses](https://docs.usemotion.com/api-reference/tasks/list/) include duration, due date, scheduled chunks, and `schedulingIssue`. No official MCP or capacity endpoint was found.

**Try.** First ask Motion to confirm that its Business trial exposes Workload. The [FAQ says only multi-seat subscriptions display it](https://www.usemotion.com/help/project-management/capacity-planning/capacity-planning-faq), and current [Business pricing](https://www.usemotion.com/pricing?tool=motion) is $29/seat/month on annual billing. If trial access is confirmed, connect every calendar that affects availability, enter representative tasks with durations and deadlines, and open Workload for that range.

**Failure boundary.** Manually scheduled tasks do not count in capacity. Email and Docs only matter after conversion into tasks. The view ends at 90 days.

## Reclaim 2.0: best AI-native surface

**What works.** The [2.0 Planner and assistant](https://help.reclaim.ai/en/articles/14846468-reclaim-ai-2-0-overview) analyze free time, focus opportunities, workload distribution, overloaded days, uneven weeks, and fragmentation. Preview mode allows proposed changes without first modifying the calendar. Focus, Habits, Tasks, Buffers, Smart Meetings, and Meeting Quality defend flexible time.

**Inputs.** Google and Outlook calendars; Google Tasks, Todoist, Asana, ClickUp, Jira, Linear, and Notion; Slack and Zoom. It can derive meeting action items, but no general Gmail or Docs commitment ingestion is documented.

**Developer surface.** Reclaim exposes a hosted OAuth MCP at `https://mcp.reclaim.ai`. Its webhooks cover scheduling-link create, reschedule, and cancel events, not all task/calendar data. No general public REST API was found.

**Try.** Request access first: [Reclaim 2.0 is a private beta](https://help.reclaim.ai/en/articles/14846468-reclaim-ai-2-0-overview). Once approved, ask its assistant and MCP client the benchmark questions in [05-trials.md](05-trials.md). The free plan schedules one week ahead, trials three weeks, and paid plans 8 or 12 weeks; verify the [window rules](https://help.reclaim.ai/en/articles/11887122-adjusting-your-scheduling-window-for-reclaim-events) and current [pricing](https://reclaim.ai/pricing).

**Failure boundary.** Even the top plan stops optimizing after 12 weeks. The state is calendar/task-derived and is not an uncertainty-aware record of tentative commitments.

## Morgen: best modular product

**What works.** Morgen combines Google, Microsoft 365, iCloud, Fastmail, Zoho, and CalDAV calendars with tasks from Notion, Todoist, Linear, ClickUp, Obsidian, Google Tasks, and Microsoft To Do. Its [AI Planner](https://www.morgen.so/ai-planner) uses due dates, priority, estimated effort, available capacity, and reusable Frames, then asks for approval before saving a plan.

**Developer surface.** The [early-access API](https://docs.morgen.so/) provides unified event CRUD across providers plus tasks, integrations, and calendars. It is the cleanest way to avoid implementing several calendar providers, but its early-access status means callers must tolerate new fields and possible change.

**Try.** Use the 14-day trial, connect calendars and task stores, create a representative future week, and run AI Planner. Request API access in parallel. Check the live [pricing and integration matrix](https://www.morgen.so/pricing).

**Failure boundary.** No stable future-utilization percentage, history model, or official MCP was documented. Its planner is stronger than its long-range forecast.

## TimeHero and SkedPal: specialized forecasting

### TimeHero

[TimeHero Workload](https://help.timehero.com/en/articles/2334181-visualize-your-team-s-workload) identifies overloaded people and capacity for upcoming work; Premium adds Forecast, Gantt, reports, and automated timesheets. It schedules projects around Google or Microsoft calendars and ingests work through Gmail, Asana, Jira, Slack, and Zapier.

Use its no-card trial if project forecasts or multiple people matter. No official public REST API, CLI, or MCP was found, so it is a poor foundation for an owned system.

### SkedPal

[Zones and Budgets](https://docs.skedpal.com/zones/introduction-to-zones-and-budgets) cap hours per day or week by category, while its [rolling scheduling window](https://docs.skedpal.com/scheduling-preferences/scheduling-granularity-and-window) can extend beyond a fixed 90-day view. This is the best personal category-budget model found.

It depends on entered tasks, Asana, or Zapier and exposes no official API or MCP. Use it only if “never spend more than N hours per week on this class of work” is the core rule.

## Daily planners

### Sunsama

Sunsama has a daily workload threshold, planned-versus-actual time, broad task and email integrations, JSON/CSV export, an AI planner named Sunny, and a [hosted MCP](https://help.sunsama.com/docs/integrations/mcp/). It is unusually open for a consumer planner.

Its threshold measures planned task hours per day, not calendar-plus-task utilization over an arbitrary future range. Try it for deliberate daily planning, not September capacity.

### Akiflow

Akiflow has the broadest capture layer in this group and a new [hosted MCP](https://product.akiflow.com/en/help/articles/4302815-akiflow-mcp) for schedules, tasks, events, projects, tags, and meeting transcripts. Its [Schedule Optimizer](https://product.akiflow.com/en/help/articles/3161671-schedule-optimizer) only rearranges affected tasks later in the same day; it does not plan across days or split tasks.

No public REST API exists, and full native-task JSON/CSV export remains a public request. It is a good inbox and a weak forecasting brain.

## Calendar surfaces

### Vimcal

Vimcal provides a fast unified Google/Outlook calendar, scheduling links, time-zone tools, and meeting metrics. It has no task ingestion, auto-planning, public API, CLI, or MCP. Calendar providers remain the source of truth, which limits lock-in. Use it as a polished display, not as state.

### Notion Calendar

Notion Calendar is free, overlays Google/iCloud calendars with Notion database dates, and exposes calendar content to Notion AI through a beta [AI Connector](https://www.notion.com/help/notion-calendar-ai-connector). Its `cron://` mechanism opens a known event; it is not an event API. Notion MCP exposes workspace pages, not Notion Calendar.

It is useful for context and display. It performs no duration or capacity arithmetic.

## Removed from consideration

- [Clockwise](https://getclockwise.com/) shut down on 2026-03-27 and directs users to Reclaim.
- [Rise](https://risecalendar.com/) shut down on 2025-03-31.

Do not build a workflow around either, even when older comparison pages still recommend them.
