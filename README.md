# dshak1.github.io

personal site, served by github pages from `main:/docs`.

- `docs/index.html`: the site. one file, inline css, no javascript, no build step.
- `docs/support/`: app support page for event stack (csnexus). keep it reachable; the root footer links to it.
- `tools/truth-check.sh`: fails the build if public copy carries an em dash, a number the source of truth marks do-not-cite, employer or domain specifics, a stealth entity name, or a placement claim the sources disagree on. runs in ci on every push.

every number on the page traces to a source in the private knowledge base (flex-sheet ids). if it is not measured, it is not on the page.
