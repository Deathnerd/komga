@AGENTS.md

# Fork guidance — Deathnerd/komga

This is a fork of gotson/komga on its way to being a cloud-native, API-compatible
descendant. The roadmap is docs/roadmap.md. Decisions are in adr/. Current state is
STATUS.md: read it first in every session, update it last.

## Non-negotiables

- The REST contract is frozen. komga/docs/openapi.json is the spec. Any change to it
  needs an ADR first, and the two UIs and reader clients (Mihon, Tachiyomi, Paperback,
  Chunky, Panels) must keep working.
- One pin per pull request. The eight "pins" (SQLite, local file paths, Lucene, the
  in-process task queue, in-memory sessions, in-JVM events/SSE, blobs in the DB,
  no tenancy) are listed in docs/roadmap.md §2.3. Never remove two in one change.
- Tests before implementation. Extend the contract suite or integration tests first,
  then change code to make them pass.
- Domain model types under komga/src/main/kotlin/org/gotson/komga/domain/model are
  not modified without an ADR.
- No opportunistic cleanup, reformatting, or "improvements" outside the task.
- Scope check: if a task starts growing a new mechanism (hook, service, abstraction,
  config surface) that is not part of the current phase, stop and say so instead of
  building it. Content additions are in scope; mechanism additions need a check.

## Build and test

- Backend: `./gradlew :komga:build` (full) or `./gradlew :komga:compileKotlin` (fast).
- Tests: `./gradlew :komga:test`.
- jOOQ code is generated at build time from two scratch SQLite databases (main and
  tasks) that Flyway migrates; see komga/build.gradle.kts near `sqliteUrls` and the
  `flywayMigrateMain` / `flywayMigrateTasks` tasks. Migrations live under
  komga/src/flyway. Phase 2 changes this.
- JVM target 17 (komga/build.gradle.kts); builds on JDK 21. Gradle 9.x wrapper.
- UIs: komga-webui (Vue 2, legacy) and next-ui (generated against the OpenAPI spec).
  Not needed for backend work; skip their build unless the task is UI.

## Where things live (fork-relevant)

All paths are relative to komga/src/main/kotlin/org/gotson/komga/.

- domain/persistence — 23 repository interfaces. Persistence swaps happen behind these.
- infrastructure/jooq — SQLite DAOs (Phase 2 replaces with Postgres).
- infrastructure/search — Lucene (Phase 3c).
- application/tasks — Task, TaskEmitter, TaskHandler, TaskProcessor, TasksRepository
  (Phase 3d).
- infrastructure/security/session — Caffeine-backed sessions (Phase 3a).
- interfaces/sse — SSE fan-out (Phase 3e).
- domain/model/Book.kt `url`/`path` and domain/service/BookAnalyzer.kt — local-file
  coupling (Phase 4).

## Upstream

- Remote `upstream` = https://github.com/gotson/komga.git. Merging upstream is allowed
  until Phase 2 begins; afterwards cherry-pick only. See docs/upstream-policy.md.
- Upstream's four release/publish workflows (release, dockerhub_description,
  github-releases-to-discord, dispatch) are kept but guarded with
  `if: github.repository == 'gotson/komga'`; do not remove the guards or the files.
  Every other upstream workflow (tests, lint, build, chromatic, lock, browserslist)
  is unchanged and runs on the fork.
- Branch `postgres` is a 2020 JPA/H2-era experiment. Ignore it.

## Session protocol

- Start: read STATUS.md, adr/, and only the roadmap section for the current phase.
- Work on a branch; one PR per pin or per setup task. Conventional commit messages.
- End: update STATUS.md (phase, last completed step, next step, open questions,
  parked ideas) and commit it with the work. A session that ends with STATUS.md
  updated and CI green is a good session even if it moved one file.
