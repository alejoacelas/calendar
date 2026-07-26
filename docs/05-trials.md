<!--ai-->
# Trials

## Prepare one relative fixture

Use the same seven days beginning 7–14 days from the test date. This fits Motion's range, Reclaim's three-week trial window, and ordinary planner trials. Add a separate September test only after access to a product whose paid horizon reaches it.

The fixture contains:

- five fixed meetings, including one tentative invitation and two overlaps;
- two protected personal blocks and one all-day out-of-office event;
- four tasks with 30-minute to 8-hour estimates and mixed deadlines;
- one 12-hour project mentioned in a Doc but absent from the calendar;
- one possible trip from email;
- one cancelled event that still appears in an older message;
- one proposed 90-minute meeting for the what-if test.

Record the expected result before opening a product. Do not grant mailbox or Drive access until the privacy checks below pass.

For the owned engine, add fixtures for probability-weighted tentative events, median/P90 late-booking terms, overlapping categories, zero-capacity days, overnight and weekend events, DST transitions, timezone changes, and intervals crossing a capacity-window boundary. Each fixture states exact expected minutes before implementation.

## Ask the same questions

1. How busy am I in the fixture week?
2. How many usable hours remain, and what is the plausible bad case?
3. Which three commitments create the most pressure?
4. Do I still have one uninterrupted three-hour block?
5. What changes if I add a 90-minute meeting on Wednesday?
6. What evidence is missing or uncertain?
7. Why is this answer different from yesterday's?

## Evaluate three scopes separately

A daily planner should not fail because it does not claim to ingest Docs. A cross-source forecast should not pass because its calendar looks good.

### Calendar and task planning — 50 points

| Test | Weight | Pass |
|---|---:|---|
| Finds hard conflicts | 10 | No missed accepted busy event |
| Applies event precedence | 10 | OOO, personal blocks, tentative status, and overlaps count once |
| Includes estimated work | 10 | All four explicit tasks affect load |
| Gives arithmetic | 10 | Result can be recomputed from displayed inputs |
| Supports a safe what-if | 5 | Proposed meeting can be assessed before a write |
| Exposes or exports state | 5 | Supported API, MCP, or complete export |

Pass at 40/50, with no missed hard conflict or double counting.

### Cross-source forecasting — 50 points

| Test | Weight | Pass |
|---|---:|---|
| Finds Doc/email commitments | 15 | Both appear as uncertain, not confirmed |
| Reconciles duplicate and cancelled evidence | 10 | One live commitment remains |
| Represents uncertainty | 10 | Expected and high cases differ |
| Explains the answer | 5 | Contributors link to evidence |
| Preserves history | 5 | Yesterday's answer remains inspectable |
| Reports source coverage | 5 | Missing/stale sources make the answer `unknown` |

No finished product researched documents a pass here. This score measures whether the owned ledger is worth building and whether it eventually works.

### Operational reliability — gates, not points

- Create, update, cancel, and delete one fixture event; record detection latency for each.
- Deliver or simulate the same notification twice; verify idempotence.
- Stop notifications once, then recover through cursor/delta sync without loss.
- Disconnect OAuth and verify reads and writes stop.
- Export data, delete the account, wait the documented interval, and verify app data and vendor-created calendar artifacts are gone.
- Fail the trial if an error, stale sync, or partial source silently returns a confident forecast.

## Privacy checks before connecting real data

“Pass” means all of the following for the active account and plan:

- exact OAuth scopes are recorded and no write scope is granted unless the tested feature requires it;
- model-training and retention settings are found and set to the intended values;
- stored-content, subprocessors, export, revocation, and deletion paths are documented;
- synthetic-data export, token revocation, account deletion, and post-deletion verification succeed;
- any unsupported requirement is accepted explicitly before real data is connected.

| Candidate | Documented access and storage | Training/retention statement | Deletion test |
|---|---|---|---|
| Motion | Calendar read/write; tasks and workspace data stored | [No AI training on customer data](https://www.usemotion.com/security); temporary LLM input/output storage for debugging | Review the current [privacy policy](https://www.usemotion.com/legal/privacy-policy), request deletion, and verify calendar artifacts |
| Reclaim | Calendar read/write; [primary calendar stored, Calendar Sync sources held in memory](https://reclaim.ai/security) | [External LLM use is opt-in](https://help.reclaim.ai/en/articles/13178785-reclaim-ai-disclosure); verify the account setting | [Self-service deletion](https://help.reclaim.ai/en/articles/3764803-how-to-delete-your-reclaim-account) says up to one hour; verify cleanup |
| Morgen | Provider credentials pass through secure servers; [calendar events normally are not persisted](https://www.morgen.so/faq), with opt-in exceptions for cloud features | Vendor says encryption in transit/at rest and no sale; ask how AI Planner inputs are retained | Find export/deletion controls before adding non-fixture data |
| Claude connector | Explicit Google OAuth; retrieved data is stored with the associated chat | [Connector data is not used to train models](https://support.claude.com/en/articles/10166901-use-google-workspace-connectors); copied text follows account data settings | Delete the chat, disconnect Google, then verify both states |
| Gemini | Connected Apps may retrieve Workspace content and inferences | [Summaries, excerpts, and inferences may improve Google AI when Keep Activity is on](https://support.google.com/gemini/answer/16836988) | Disable the app, delete Gemini activity, and verify each separately |
| ChatGPT apps | App-specific OAuth and third-party retention apply | Review current [app and connector controls](https://help.openai.com/en/articles/11487775-connectors-in-chatgpt) for the account plan | Delete the chat/project, disconnect the app, and verify each separately |

Also record exact OAuth scopes, subprocessors, export format, and whether zero-retention controls are available on the plan being tested. A vendor security page is evidence to test, not proof that deletion completed.

## Trial 1: Motion Business

Setup estimate: 60–90 minutes after access, plus one week of normal use. This is a planning estimate for an experienced user, not a vendor SLA.

1. Ask Motion to confirm in writing that the trial exposes Workload on a multi-seat Business subscription.
2. Stop if it does not; the defining feature cannot be tested on a solo plan.
3. Connect the fixture calendar, set work hours, and classify personal/OOO time.
4. Create the four tasks with estimates, deadlines, priorities, and auto-scheduling.
5. Open Workload for the relative fixture, then for September if the horizon permits.
6. Verify its number manually from work hours, busy events, and auto-tasks.
7. Forward one synthetic email and note what metadata survives.
8. Use the API to list tasks and scheduled chunks; run the reliability gates.

Buy only if Motion passes the calendar/task score and maintaining its task data feels cheaper than maintaining the ledger. Do not interpret a pass as cross-source forecasting.

## Trial 2: Reclaim 2.0 and MCP

Access time: unknown. Setup estimate after approval: 45–60 minutes.

1. Request the private beta and continue to other trials.
2. Once approved, connect the fixture calendar and one task source.
3. Recreate the fixture with Tasks, Focus, Habits, and Buffers.
4. Ask the assistant the seven questions.
5. Connect `https://mcp.reclaim.ai` to one supported AI client and repeat.
6. Compare Preview with saved state and run the reliability gates.
7. Confirm the account's scheduling window: free one week, trial three weeks, paid 8 or 12 weeks.

Pass only if answers are stable across two fresh conversations and every claim is inspectable in Planner or Insights.

## Trial 3: Morgen and its API

Setup estimate: 60 minutes; API approval time is unknown.

1. Connect the fixture calendar and one task system.
2. Model the ideal week with Frames.
3. Run AI Planner on the relative fixture.
4. Request API access and read the same calendars, events, and tasks.
5. Confirm that unknown response fields do not break a simple client.
6. Run the reliability gates that its trial and API permit.

Choose Morgen as a component if its unified API removes more provider work than its early-access status adds. Do not choose it as the forecast until it passes the arithmetic gate.

## Trial 4: no-build AI baseline

Setup estimate: 30 minutes each in Claude, Gemini, and ChatGPT after OAuth.

Use synthetic fixture sources in a dedicated calendar, mailbox label, and Drive folder. Grant minimum access, name exact sources and dates, and ask the seven questions twice in fresh conversations. Measure omissions, arithmetic, evidence links, latency, revocation, and deletion. These results define the retrieval failures an owned system must beat.

## Build gate

For four weeks, keep a private five-minute Friday diary:

- the decisions made about the next 4–12 weeks;
- commitments that changed the decision;
- where each commitment was visible first;
- what the tested product missed, misclassified, or double-counted;
- whether its answer would have changed the decision.

Build after the diary identifies at least three real decisions changed by uncaptured or uncertain evidence. Preserve only redacted versions of those failures as fixtures. The first milestone is a command that returns reproducible JSON load, source coverage, and evidence for one date range; the UI comes later.
<!--/ai-->
