# Seed pool

Inputs to Phase 2 (per-problem statement rewrite). The generator consults these
two JSON files to produce a rewrite whose framing is drawn from a realistic
domain rather than abstract puzzle-speak.

## Files

- `worlds.json` — ~25 neutral narrative worlds (warehouse logistics, courier
  dispatch, smart-home IoT, ...). Each world contributes a domain vocabulary
  (entities, actions, units) and a map from abstract data shapes (array,
  graph, interval, grid, stream, tree) to concrete in-world phrasings.

- `shapes.json` — for every tag present in the catalog, the algorithmic
  sub-shapes expected to show up under that tag, each with a shortlist of
  worlds where the shape lands cleanly and a one-line mapping hint.

## How the rewriter uses them

1. **Classify.** Read the target problem's current tag (from the DB) and
   decide which `sub_shape` best matches its algorithmic move. If in doubt,
   pick the closest sub_shape and note the discrepancy.

2. **Pick a world.** Scan the sub_shape's `worlds` list. Choose one whose
   hint matches the algorithmic structure of the current problem. Avoid
   reusing the same world consecutively for the same tag (diversity).

3. **Draft.** Use the world's `vocabulary` for every entity/action/unit in
   the new description. Use the relevant `natural_inputs` phrasing to frame
   sample data. Keep the algorithmic behavior identical to the source
   problem — only the surface vocabulary changes.

4. **Validate.** Run the draft through `check_denylist.py`, then the Judge0
   round-trip via `check_solution.py`, then the subagent similarity probe
   (see the operator runbook).

## Extending

Adding a new world: append an entry to `worlds.json` with the same shape as
existing entries. Then add it to the `worlds` list of any `sub_shape` it
suits, with a specific mapping hint.

Adding a new sub_shape: append under the relevant tag in `shapes.json` with
3-5 worlds. Prefer neutral shape ids in `verb_noun_modifier` form; never use
canonical problem names.

## Style

- World ids are `snake_case` domain labels (`courier_dispatch`, not
  `Courier Dispatch`).
- Shape ids are neutral algorithmic descriptions. Never introduce an id
  whose meaning depends on a famous canonical problem.
- Hint lines are one sentence each, in domain-native vocabulary.
