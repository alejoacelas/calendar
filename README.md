# calendar

I want to ask “how busy will I be in the first week of September?” and get an answer that includes meetings, work implied by email or docs, uncertainty, and the amount of usable time left.

No product found documents all of that. [Motion](https://www.usemotion.com/help/project-management/capacity-planning/capacity-planning-faq) is the best documented finished candidate: its Workload view calculates `work hours − busy events − auto-scheduled tasks` for any 7–90-day range. The catch is decisive for a personal system: Workload requires a multi-seat Business subscription. [Reclaim 2.0](https://help.reclaim.ai/en/articles/14846468-reclaim-ai-2-0-overview) has the strongest documented conversational and MCP interface, but it is a private beta and stops at a 12-week scheduling horizon.

My order:

1. Ask Motion to confirm that a multi-seat Business trial includes Workload; test it only if the answer is yes.
2. Request Reclaim 2.0 access without waiting. Run Morgen and the Claude/Gemini/ChatGPT baseline meanwhile.
3. Build the small owned intelligence layer in [the architecture](docs/04-architecture.md) if off-calendar commitments materially change decisions.

The build should not replace Google Calendar or Calendly. It should keep an evidence-backed commitment ledger, compute forecasts deterministically, show a heatmap, and expose six narrow MCP tools to any AI provider. The existing [`gog`](https://github.com/openclaw/gogcli) CLI in this workspace already supplies read-only Gmail, Calendar, Drive, and Docs access as JSON and MCP.

## Read

- [Decision and comparison](docs/01-decision.md)
- [Full products](docs/02-full-products.md)
- [Composable parts](docs/03-building-blocks.md)
- [Recommended architecture](docs/04-architecture.md)
- [Trials that settle the decision](docs/05-trials.md)
- [Research method and sources](history/2026-07-26-research.md)

Research checked 2026-07-26. Prices and young APIs will change; capability claims link to primary sources.
