# Architecture Decision Records

An ADR here is a short, dated record of one decision that shapes this fork: why we made it, what we chose, and what it costs us later. Write one before changing the REST contract (komga/docs/openapi.json), a domain model type, or the plan in docs/roadmap.md; write one after any build or infrastructure finding that changes the plan. Files are named `NNNN-short-title.md` with a zero-padded sequence number (`0001-fork-komga-keep-api-contract.md`), are never renumbered, and are never deleted — a reversed decision gets a new ADR that supersedes the old one and a `Status: Superseded by ADR-NNNN` line on the old one.

## Template

```markdown
# ADR-NNNN: Short title

Date: YYYY-MM-DD · Status: Proposed | Accepted | Superseded by ADR-NNNN

## Context
What situation forces a decision. One paragraph.

## Decision
What we are doing. One paragraph, present tense.

## Consequences
- What becomes easier, harder, or impossible as a result.
```
