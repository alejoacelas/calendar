# Archived calendar forecast decisions

## Core decisions

### Product boundary

- [Keep existing calendars and test finished products before building](#decision-1).

### Evidence and computation

- [Separate evidence, proposed commitments and deterministic forecasts](#decision-2).

### Evidence limits

- [Recheck product access and pricing before relying on the shortlist](#decision-3).

## Details

<a id="decision-1"></a>

### Keep existing calendars and test finished products before building

This is retained research and an architecture proposal, with trials and the forecast tool still future work. The proposed owned layer complements Google Calendar and Calendly; reconsider building only if off-calendar commitments materially change decisions. See [README.md](README.md).

<a id="decision-2"></a>

### Separate evidence, proposed commitments and deterministic forecasts

The proposed model extracts candidate commitments and explains results, while explicit review and deterministic calculations determine load. Do not silently turn prose into accepted commitments or let an LLM calculate the authoritative forecast. See [docs/04-architecture.md](docs/04-architecture.md).

<a id="decision-3"></a>

### Recheck product access and pricing before relying on the shortlist

The Motion/Reclaim comparison records July 2026 capabilities and gating conditions, not current availability or completed trials. Use the planned trials to settle the decision instead of interpreting the architecture estimate as delivered software. See [docs/05-trials.md](docs/05-trials.md).
