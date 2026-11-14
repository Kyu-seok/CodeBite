# Walkthroughs draw with their own kit, in the Diagram's look

A Walkthrough draws each data structure in its own shape (a map as key cards, a queue as a pipe, a heap as a tree over its array, intervals on a number line) and shows a value moving from one structure to another. Diagrams already draw trees, linked lists, graphs, grids and intervals as React components in the problem description, so the obvious move was to draw Walkthrough frames with them. We extend the public `walkthrough` kit instead (plain JavaScript, copied into CodeBite unchanged) and give its new views the Diagrams' shapes and colours, so a learner who has seen a problem's Diagram recognises the same picture in its Walkthrough.

## Considered Options

- **Draw frames with the Diagram components.** One drawing per structure and an exact match, but Diagrams are static: they have no marks, pointers, spans or moves, and adding stepping state to them would put Walkthrough concerns into components the description renderer depends on. It would also tie the Walkthrough to the app, losing the tracer → `build.mjs` → `capture.mjs` review loop that runs outside it.
- **Fork the kit into CodeBite.** Freedom to use React, but the kit's validator, build and capture scripts and its examples would drift from the public skill that owns the format.

## Consequences

Trees, linked lists, graphs, grids and intervals are drawn by two pieces of code, so a change to a Diagram's look must be matched in the kit by hand. A Walkthrough's views are reached only by copying the kit in again, as before: `scripts/copy-walkthrough-kit.py` does it and records the kit commit, and its `--check` (pre-commit and CI) fails on a copied file edited in CodeBite.
