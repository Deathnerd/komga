# Upstream policy

Upstream: https://github.com/gotson/komga (remote `upstream`).

## Until Phase 2 begins
Merge `upstream/master` into `master` freely; the fork has no divergent code yet.

## From Phase 2 onward
Cherry-pick only. Watch each upstream release for:
- diffs to komga/docs/openapi.json (contract changes we probably want),
- changes under infrastructure/metadata and infrastructure/mediacontainer
  (parser and format fixes we almost always want),
- UI changes in komga-webui and next-ui (they only talk to the API; usually painless).
Ignore infrastructure/jooq, infrastructure/search, and the Flyway migration
directories (komga/src/flyway); that code no longer exists in this tree after Phase 2.

## Workflows
Upstream's release/publish workflows (release.yml, dockerhub_description.yml,
github-releases-to-discord.yml, dispatch.yml) are kept in the tree but guarded with
`if: github.repository == 'gotson/komga'` so cherry-picks apply cleanly. All other
upstream workflows (test-komga, test-webui, test-nextui, chromatic, chromatic-pr, lock,
browserlist-update) are untouched and run on the fork as they do upstream. Dependabot
is muted (open-pull-requests-limit: 0) rather than removed, for the same reason.
