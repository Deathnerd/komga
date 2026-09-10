# STATUS

Read first, update last. One screen. Older detail goes to adr/ or docs/, not here.

## Where we are
- Phase: 0 (safety net) — not started. Repo setup PR: https://github.com/Deathnerd/komga/pull/1
- Based on upstream gotson/komga d512b67d0186b519f1fe70c5ff8fb09d6311e1fd (v1.26.3,
  upstream commit of 2026-09-07), synced 2026-09-10 via GitHub Sync fork. Fork master
  == upstream master, zero fork-only commits.
- Plugin: agency@infinite-room-labs enabled at project scope (.claude/settings.json).
  Not yet confirmed to auto-install in a cloud session (see Open questions).

## Last completed
- Fork setup: CLAUDE.md, .claude/settings.json, ADR log (adr/0001), upstream policy,
  CI guards on the 4 upstream release/publish workflows, dependabot muted,
  docs/roadmap.md placeholder.

## Next step
- Phase 0, session 1: build locally, understand the jOOQ/Flyway build step in
  komga/build.gradle.kts, write ADR-0002 if anything about the build changes the plan.
- Then: golden library fixture → contract test skeleton from openapi.json → Mihon
  extension smoke test → baseline load profile → CI.
- Housekeeping: replace docs/roadmap.md placeholder with the real roadmap from the
  2026-09-09 report (CLAUDE.md references its §2.3 pin list).

## Open questions
- compileKotlin on JDK 21: **succeeds**. `./gradlew :komga:compileKotlin --no-daemon`
  took 4m 53s wall-clock on the cloud VM (OpenJDK 21.0.10, Gradle 9.6.1, cold cache
  including the Gradle distribution download). Task chain worth knowing for Phase 2:
  compileFlywayKotlin → flywayClasses → flywayMigrateMain → generateJooq →
  flywayMigrateTasks → generateTasksJooq → compileKotlin. Two scratch SQLite DBs, two
  jOOQ generators (main + tasks); a Postgres port must replace both.
- Warnings relevant to a Postgres/jOOQ port (none fatal, nothing fixed):
  - jOOQ DAOs under infrastructure/jooq/main (BookDao, BookDtoDao, LibraryDao,
    PageHashDao, SeriesDao, SeriesDtoDao, SidecarDao) construct `java.net.URL(String)`,
    deprecated in Java 20+. That is the local-file coupling in the persistence layer
    (Phase 4), and it will be rewritten anyway when the DAOs move to Postgres.
  - SeriesDtoDao still carries the deprecated `regexSearch`/`SearchField` path; its
    SQL is SQLite-flavoured and must be re-expressed for Postgres.
  - Gradle reports "Deprecated Gradle features were used ... incompatible with
    Gradle 10" (source not identified; run with `--warning-mode all`). Likely in the
    jooq/flyway Gradle plugins (nu.studer.jooq 10.2.1, flyway 13.1.0); matters only
    when the wrapper moves to 10.
  - The other 60-odd Kotlin warnings are deprecations inside interfaces/api (v1
    referential endpoints) and BookLifecycle; upstream noise, not ours.
- Plugin auto-install: the setup session could not confirm that
  `enabledPlugins` in .claude/settings.json installs agency@infinite-room-labs in a
  cloud session (`claude plugin list` reported none; the CLI install command was
  blocked by session permissions). Check on the next session start with
  `/plugin` or `claude plugin list`; if still missing, install by hand once.

## Parked (not forgotten)
- Tag branch `postgres` as archive/postgres-2020 (needs a local push; not cloud).
- Branch protection on master after Phase 0 lands.
- Enable GitHub Actions on the fork if CI is wanted (test-komga / test-webui /
  test-nextui / chromatic / lock / browserlist-update are unguarded and will run
  once Actions is on). chromatic and chromatic-pr need a CHROMATIC_PROJECT_TOKEN
  secret on the fork or they will fail on next-ui changes; add one or accept the
  red check.
- From /project-onboard (agency plugin, "existing repo" delta) — all deferred because
  they add mechanisms, not content: mise.toml + scripts/check.sh (gate step),
  scripts/arch-gen.sh + docs/architecture/*.c4 (C4 model), .mcp.json,
  .claudeignore, .claude/.gitignore + .gitignore allowlist lines for .claude/,
  a Keep-a-Changelog CHANGELOG.md (upstream's is release-generated; leave it),
  the /new-goal-loop "treadmill" (GOAL.md, docs/phases/, docs/progress.md).
  Revisit after Phase 0 when there is a real check step to gate.

## Notes
- Branch `postgres` (2020-03-16) is a JPA/H2-era Postgres experiment. Nothing in it
  applies to Phase 2; it is kept for history only.
- Upstream's AGENTS.md is imported by CLAUDE.md via `@AGENTS.md`; do not edit it
  (keeps upstream merges clean).
- This setup PR was opened from the cloud session's working branch
  (claude/new-session-itmzqo) rather than chore/fork-setup, because cloud sessions
  can only push to their own branch.
