# Decision

## The rule

Use Motion if its multi-seat requirement is acceptable and calendar events plus estimated tasks are a sufficient model of “busy.” Build an owned commitment ledger if email, Docs, tentative plans, travel, recovery time, or uncertainty must change the answer.

## What the system must answer

For any date range:

- How much usable time remains?
- What is the expected load and a plausible bad case?
- Is the calendar merely full, or is the work itself excessive?
- What creates the pressure?
- Which claims are confirmed, tentative, inferred, or stale?
- What happens if I add a proposed commitment?
- How has the answer changed since the last forecast?

A calendar grid alone cannot answer these. A three-hour workshop, a deadline with twelve unscheduled hours, and a possible trip have different evidence, flexibility, and risk.

## Comparison

This matrix records documented behavior, not a numerical score. “Cross-source” means evidence beyond calendar events and explicit task records.

| System | Forward-load method | Cross-source evidence | External surface | Access gate |
|---|---|---|---|---|
| Motion | Explicit formula, 7–90 days | Forwarded email becomes a task; no Docs inference | REST for tasks/projects; no capacity endpoint | Business and multi-seat |
| Reclaim 2.0 | Assistant and Insights, 1–12 weeks by plan | Task systems and meeting context; no general Gmail/Docs ingestion | Hosted MCP; narrow booking webhooks | Private beta |
| Morgen | AI Planner uses capacity and flags at-risk tasks | Broad task systems; no email/Docs inference | Early-access unified REST API | 14-day public trial |
| TimeHero | Project forecast and Workload | Gmail labels, apps through Zapier | Zapier; no public API/MCP found | Premium trial |
| SkedPal | Category budgets and rolling window | Tasks through Asana/Zapier | No public API/MCP found | Public trial |
| Sunsama | Daily planned-hours threshold | Broad task and email capture | Hosted MCP and JSON/CSV export | Public trial |
| Akiflow | Same-day task optimizer | Broad task, email, and transcript capture | Hosted MCP; no full export | Public trial |
| Gemini | Prompt-time retrieval | Gmail, Calendar, Drive, Docs, Tasks, Keep, Chat | Native Google surface | Account and admin eligibility |
| ChatGPT apps | Prompt-time retrieval | Gmail, Calendar, Drive and other apps | ChatGPT apps and remote MCP | Account and admin eligibility |

## Recommendation under three assumptions

### Calendar and tasks describe reality

Motion is the best documented candidate. Its formula is transparent, the horizon covers 7–90 days, and the API exposes task duration, scheduled chunks, and scheduling failures. The [capacity FAQ](https://www.usemotion.com/help/project-management/capacity-planning/capacity-planning-faq) also says Workload displays only on multi-seat subscriptions; [Business is currently $29/seat/month on annual billing](https://www.usemotion.com/pricing). At two seats that is at least $58/month. Confirm that the trial includes Workload before entering data. The capacity view itself is not documented as an API endpoint, and manually scheduled tasks do not count.

### The answer must be available inside Claude or ChatGPT

Request Reclaim 2.0. Its hosted OAuth MCP gives AI clients a supported interface; its assistant and Insights reason about overload, fragmentation, free time, and uneven weeks. [Reclaim documents 2.0 as a private beta](https://help.reclaim.ai/en/articles/14846468-reclaim-ai-2-0-overview), so access time is unknown. Its other tradeoffs are a 12-week ceiling and no general public REST API. Use Morgen or a native AI baseline while waiting.

### “Busy” includes evidence outside a task manager

Build the ledger in [04-architecture.md](04-architecture.md). Let an LLM extract candidate commitments, but let deterministic code calculate capacity. Every inference must retain its source, confidence, effort range, and last-seen time.

## Why not choose one AI chat

[Gemini Connected Apps](https://support.google.com/gemini/answer/14959807) can search Gmail, Calendar, Docs, Drive, Tasks, Keep, and Chat. [ChatGPT apps](https://help.openai.com/en/articles/11487775-connectors-in-chatgpt) can also retrieve workspace sources. These are useful baselines, not durable forecasting systems:

- retrieval is prompt-time rather than a versioned state;
- the same evidence can produce a different answer later;
- neither publishes a workload formula or confidence model;
- neither gives a stable history of what was known when;
- broad queries can hit connector limits or miss evidence.

Use them to discover missing commitments and explain a stored forecast, not to be the forecast database.

## Thresholds that change the recommendation

- If entering estimated tasks takes under five minutes per week and catches at least 90% of meaningful work, Motion is cheaper than a build.
- If more than 10% of high-pressure weeks are caused by uncaptured email, Docs, travel, or tentative work, a calendar/task-only system will stay misleading.
- If a three-month horizon is sufficient, Motion or Reclaim can remain the planning surface. Beyond that, keep an owned forecast even if either product is used daily.
- If only one person and one Google account matter, start with `gog + SQLite`; add hosted Postgres and remote MCP only when a remote client needs continuous access.
