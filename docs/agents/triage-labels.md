# Triage Labels

The skills speak in terms of five canonical triage roles. This file maps those roles to the actual label strings used in this repo's issue tracker.

| Label in mattpocock/skills | Label in our tracker | Meaning                                  |
| -------------------------- | -------------------- | ---------------------------------------- |
| `needs-triage`             | `needs-triage`       | Maintainer needs to evaluate this issue  |
| `needs-info`               | `needs-info`         | Waiting on reporter for more information |
| `ready-for-agent`          | `ready-for-agent`    | Fully specified, ready for an AFK agent  |
| `ready-for-human`          | `ready-for-human`    | Requires human implementation            |
| `wontfix`                  | `wontfix`            | Will not be actioned                     |

When a skill mentions a role (e.g. "apply the AFK-ready triage label"), use the corresponding label string from this table.

Edit the "Label in our tracker" column to match whatever vocabulary you actually use.

## Problem Reports

Problem Reports (GLOSSARY.md) come in through the `problem-bug` issue form, labelled `problem-bug` and `needs-triage`: `gh issue list -l problem-bug`. Each names its category in the title and the Category field, by its English label: `problemReport.<category>` in `frontend/src/locales/en/problem.json`. Route by the category:

| Category | Handled by |
| --- | --- |
| `wrongTestCase` | `.claude/skills/correct-test-cases/SKILL.md`, given the issue number |
| `descriptionUnclear` | `.claude/skills/restate-problem/SKILL.md` |
| `starterCodeIssue` | by hand: the Starter Code and Driver in `common/src/main/resources/{starters,drivers}/<slug>/` |
| `other` | read it and pick a role above |
