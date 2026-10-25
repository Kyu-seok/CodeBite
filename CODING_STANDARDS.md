# Coding Standards

The rules `/code-review` checks a diff against, alongside `GLOSSARY.md` and `docs/adr/`. Each rule is a judgement call that linting can't catch. Anything mechanical belongs in a check instead (lint, a test, the pre-commit hook or CI).

## Configuration fails at startup

A configuration value the code parses (a split, a pattern, a number with a valid range) is checked where it's bound, in its `@ConfigurationProperties` setter or constructor. A bad value then stops the app from starting, rather than throwing on the first request that reads it. The parsed parts are kept on the properties class, and callers read them there.

_Example:_ `GitHubAppProperties.setSolutionRepositoryTemplate` rejects anything other than `owner/name`, and `solutionRepositoryTemplateOwner()` / `…Name()` hold the parts.

## Compound values have accessors

A value with parts (`owner/name`, `yyyy-MM`, a slug path) is taken apart by one accessor on its type, and every caller uses that accessor. Each `substring`/`split` call site is a separate copy of the format, and the copies drift apart.

_Example:_ `GitHubRepo.name()` gives `codebite-solutions` from `octocat/codebite-solutions`.
