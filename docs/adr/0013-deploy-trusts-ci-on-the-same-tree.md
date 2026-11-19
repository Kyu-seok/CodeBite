# Deploy trusts a CI run on the same tree

Every merge to master used to run the whole CI suite again inside Deploy before rolling production, about two minutes on the path from merge to live, though the PR's CI had just passed. Deploy now skips its tests when a successful CI run, every job succeeding rather than skipped, covered a commit with the same git tree as the merged commit (`scripts/tested-tree.sh`). A squash merge of a PR whose branch already contained master has exactly that tree, so the tests would only repeat. When master moved under the PR, the trees differ and Deploy tests as before; so does any doubt, a gh error included.

## Considered Options

- **Always re-test on master.** Catches two PRs that are each green but break together, at the cost of two minutes on every merge, the common one-session-at-a-time case included.
- **Deploy without tests, trusting the PR.** Fastest, but a PR tested against an older master would reach production untested in its merged form.
- **Make `scripts/ship-branch.sh` refuse or update a PR behind master.** Same safety, but it spends the same two minutes before the merge instead of after, and leaves `scripts/merge-ticket.sh` and hand merges uncovered. A tree check in Deploy covers every way a commit reaches master.

## Consequences

The CI push run on master still runs every check and alerts through ntfy when it fails, so a broken master is noticed even when Deploy skipped its tests. `scripts/merge-ticket.sh` already trusts a CI run on the same tree in the same way.
