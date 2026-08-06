---
human_edit_tracking:
  enabled: true
  history: []
---
# Recommended architecture

## Keep evidence, commitments, and forecasts separate

```text
Calendar · Gmail · Docs · tasks · manual notes
                     │
             read-only adapters
                     │
      raw evidence + cursor + content hash
                     │
           extraction and reconciliation
                     │
       commitment ledger + review queue
                     │
         deterministic forecast engine
             │                   │
      heatmap/calendar        MCP + API
```

The LLM may propose commitments and explain results. It must not silently turn prose into truth or calculate the final load.

## Start with this stack

| Layer | First version | Change when |
|---|---|---|
| Google sources | Existing `gog` CLI in read-only mode | Add Nylas only for several providers or many users |
| State | SQLite with migrations | Move to Postgres when a hosted service or concurrent writers appear |
| Extraction | Provider structured output into a strict schema | Add a second model only when measured misses justify it |
| Forecast | Plain TypeScript functions with fixture tests | Add simulation after effort ranges are calibrated |
| UI | Cal-Heatmap plus FullCalendar | Use a paid scheduler only for resource timelines |
| AI access | Local stdio MCP | Add OAuth remote MCP when ChatGPT or web Claude needs unattended access |
| Automation | `launchd` or a cron-compatible runner | Add n8n for visible branching and retries across many sources |

Planning estimate for one experienced TypeScript developer with working Google OAuth: 40–80 engineering hours for Calendar ingestion, a JSON forecast, fixtures, and local MCP; another 80–160 hours for Gmail/Docs extraction, reconciliation, review, UI, and operational recovery. That produces an engineering-complete but empirically uncalibrated system. Calendar history and labelled outcomes, not more code, determine when its forecasts become trustworthy.

## State model

### Evidence

Store the smallest durable reference needed to reproduce an inference:

```text
evidence
  id, provider, account, source_id, source_url
  observed_at, source_updated_at, content_hash
  extracted_text_or_encrypted_blob, deleted_at
```

Email and documents may contain information from other people. Keep raw content private; a publishable forecast can retain only category, dates, minutes, and redacted provenance.

### Commitment

```text
commitment
  id, title, kind
  status: hypothetical | tentative | confirmed | cancelled | completed
  window_start, window_end, timezone
  effort_low_minutes, effort_likely_minutes, effort_high_minutes
  fixed_minutes, meeting_minutes, travel_minutes, recovery_minutes
  flexibility, energy_cost, probability
  confidence, last_confirmed_at, supersedes_id
```

Use a join table from commitments to evidence. Never overwrite a changed inference: supersede it so a past forecast remains explainable.

### Capacity

Capacity is not only office hours. Store profiles by date or recurrence:

```text
capacity
  available_minutes
  max_meeting_minutes
  max_deep_work_minutes
  protected_personal_minutes
  minimum_long_block_minutes
  location and timezone
```

Vacations, jet lag, weekends, and a low-energy day should change capacity rather than masquerade as meetings.

### Forecast snapshot

For each day and week, persist:

- fixed calendar utilization;
- expected work utilization;
- high-case utilization;
- expected future bookings at the target range's current lead time;
- meeting load;
- longest uninterrupted block;
- fragmentation;
- confidence and source coverage;
- the top pressure contributors;
- calculation version and creation time;
- immutable IDs for every commitment and capacity revision used;
- source-sync watermarks and freshness at calculation time;
- extractor provider, model, prompt, schema, and review-decision versions.

Snapshots make “when did September become overloaded?” answerable.

## Calculation

Do not collapse everything into one opaque busy score.

Every minute reduces the denominator or increases the numerator, never both:

- working hours establish capacity;
- OOO, vacation, protected personal time, and non-working days reduce capacity, even when represented by calendar events;
- accepted busy events add fixed demand;
- tentative events add probability-weighted expected demand and full high-case demand;
- travel, recovery, and buffers add demand only when an explicit busy block does not already represent them;
- an auto-scheduled task uses either its scheduled chunks or its remaining parent effort, never both;
- overlapping fixed intervals are unioned before summing.
- every interval is converted to the capacity profile's timezone and clipped to its capacity windows before summing;
- zero usable capacity returns `unavailable`, never a percentage or division by zero.

```text
usable capacity =
  configured capacity − OOO − protected personal time − other overrides

calendar load = (fixed events + travel + buffers) / usable capacity

expected load =
  (fixed events
   + probability-weighted tentative events
   + expected allocated effort
   + median late-added bookings
   + travel + recovery)
  / usable capacity

high-case load =
  (fixed events
   + full tentative events
   + high-case allocated effort
   + 90th-percentile late-added bookings
   + travel + recovery)
  / usable capacity
```

Allocate flexible effort backward from its deadline across allowed days. Weight tentative work by probability for the expected case; include it at its high estimate in the high case. Report the vector alongside any label:

- `open`: expected below 65% and high case below 85%;
- `tight`: expected 65–80% or high case 85–100%;
- `overloaded`: expected above 80% or high case above 100%;
- `unknown`: source coverage or confidence is insufficient.

These are policy thresholds, not calibrated probabilities. Keep that label until at least 20 labelled weeks exist, then backtest classification precision/recall and load error before changing them. Return `unknown` when a required source is stale or disconnected, the last successful sync exceeds its freshness target, or more than 30% of expected effort comes from low-confidence unreviewed evidence.

Future calendars are structurally sparse. Save daily snapshots, then learn how much time is normally added to a target week at each lead-time bucket. Pool sparse buckets until each has at least 30 target weeks; estimate weekday effects only after that, and defer seasonality until roughly a year of data exists. Include the median late-added time in expected load and the 90th percentile in the high case. Until coverage is sufficient, label this component `uncalibrated` and report its sample count.

## MCP contract

Expose narrow tools whose outputs cite state:

```text
availability_summary(start, end, scenario)
pressure_sources(start, end)
what_if_add(commitment)
list_commitments(start, end, status)
record_manual_commitment(commitment)
sync_status()
```

Return minutes, percentages, confidence, and evidence IDs. Keep source search in separate read-only tools. Require confirmation before any event or task write; the core forecast service does not need calendar write access.

## Reconciliation rules

- Provider ID plus recurrence instance identifies calendar events.
- An email or Doc creates a candidate, not a confirmed commitment.
- Two sources may support one commitment; do not count both.
- A newer cancellation supersedes an older confirmation.
- Stale tentative items lose probability and enter review rather than disappearing.
- An LLM extraction change cannot rewrite a human-confirmed field.
- Every sync records its cursor and either succeeds visibly or alerts; no silent partial forecast.

## Privacy boundary

Calendar and email routinely contain other people's information. Keep raw evidence out of the public repository and model-provider logs. Prefer read-only OAuth scopes, content hashes, redacted snippets, and zero-data-retention API settings where available. Publish the schema, forecast code, and aggregate examples; keep real evidence and forecasts local or encrypted.

Treat every email and document as hostile input:

- the extraction worker has no write-capable tools or calendar credentials;
- source text is delimited and labelled untrusted, but may still influence the model;
- structured output is schema-validated and rejected on unknown fields;
- links and attachments are not followed automatically;
- source text cannot change human-confirmed fields;
- writes, if later added, run in a separate process and require confirmation.

Adversarial fixtures must attempt to redefine the schema, invent confirmed work, request link or attachment access, overwrite a human decision, and invoke a write. Every result stays quarantined and unconfirmed; any tool call or confirmed-field change fails the build.

Store OAuth refresh tokens in macOS Keychain or an equivalent secret manager, never the database or logs. Encrypt raw-content backups with a separately stored key; log IDs, hashes, timings, and errors rather than bodies. Define retention separately for raw bodies, redacted excerpts, forecasts, and audit events. Revoke provider tokens and delete local encrypted evidence on account deletion, then verify both operations and retain only a non-sensitive deletion receipt.
