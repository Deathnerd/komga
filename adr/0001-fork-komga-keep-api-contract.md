# ADR-0001: Fork Komga and keep its REST API contract

Date: 2026-09-10 · Status: Accepted

## Context
Komga is a well-built single-node manga/comics/ebook server with a committed OpenAPI
contract, a hexagonal layout, and a client ecosystem (Mihon, Tachiyomi, Paperback,
Chunky, Panels, two bundled UIs). It is pinned to one machine in eight places. We want
a cloud-native service with the same API.

## Decision
Fork gotson/komga (MIT). Keep the REST contract in komga/docs/openapi.json frozen; any
change requires an ADR. Follow docs/roadmap.md: container hygiene, Postgres, stateless
service, object-native media, tenancy as a decision gate, then operations. Merge from
upstream until Phase 2 begins; cherry-pick only afterwards.

## Consequences
- After Phase 2 (Postgres), upstream schema changes must be re-implemented by hand.
- Phase 4 (object-native media) changes the domain model; from there the fork is a
  descendant, not a mirror.
- Every phase must end in something deployable; several phases are explicit stopping
  points. Scope beyond the current phase is parked in STATUS.md, not built.
