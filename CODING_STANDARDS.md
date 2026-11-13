# Coding Standards

The rules `/code-review` checks a diff against, alongside `GLOSSARY.md` and `docs/adr/`. Each rule is a judgement call that linting can't catch. Anything mechanical belongs in a check instead (lint, a test, the pre-commit hook or CI).

## Configuration fails at startup

A configuration value the code parses (a split, a pattern, a number with a valid range) is checked where it's bound, in its `@ConfigurationProperties` setter or constructor. A bad value then stops the app from starting, rather than throwing on the first request that reads it. The parsed parts are kept on the properties class, and callers read them there.

_Example:_ `GitHubAppProperties.setSolutionRepositoryTemplate` rejects anything other than `owner/name`, and `solutionRepositoryTemplateOwner()` / `…Name()` hold the parts.

## Compound values have accessors

A value with parts (`owner/name`, `yyyy-MM`, a slug path) is taken apart by one accessor on its type, and every caller uses that accessor. Each `substring`/`split` call site is a separate copy of the format, and the copies drift apart.

_Example:_ `GitHubRepo.name()` gives `codebite-solutions` from `octocat/codebite-solutions`.

## A guard test shows what it catches

A test that guards data (every migrated Diagram, every Test Case) has cases showing wrong data failing it, one for each way the data can go wrong. Passing on today's data says nothing about the check, and a loose comparison passes on anything.

_Example:_ `DiagramsMatchExamplesTest.aWrongDiagramIsCaught` holds a wrong Diagram for each way one could slip through: one row of a grid, a pinned Diagram under the wrong example, `after` copied from the input.

## A test makes the missing asset it needs

A test that needs a problem without some optional asset (a Walkthrough, a Diagram, a Solution, a Driver for a language) makes that state itself: it renames the problem to a Slug no file is named for, deletes the row, or uses a fixture. It doesn't name a real problem that lacks the asset today, since filling the gaps is ongoing work and the next ticket turns such a test red.

_Example:_ `WalkthroughEndpointTest` renames `rotting-donuts` to a Slug with no Walkthrough file instead of naming `snack-drawer-pair`, which #264 gave one.

## A highlight marks what its example points at

A Diagram's `highlight` or `highlight_path` marks part of its example's answer, or the inputs the example asks about. A count or a time as the answer usually means no highlight. `.claude/skills/add-diagram/SKILL.md` has the rule; tests check only that a highlight exists in the Diagram.

_Example:_ `lca-bst` highlights `p` and `q`; `count-desk-clusters`, whose answer is a count, highlights nothing.
