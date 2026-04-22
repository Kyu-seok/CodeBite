# Problem-rewrite content-hygiene tooling

Scripts used when regenerating the statement of a catalog problem. The goal is
to keep each generated problem **distinctive** — no sample I/O, title, or
constraint bound that echoes a well-known canonical version of the same
algorithmic idea.

## Layout

- `check_denylist.py` — pure-local denylist sweep over title/slug/description/constraints/samples
- `check_solution.py` — runs a reference solution through Judge0 against the rewrite's sample I/O to prove the rewrite is internally consistent
- `denylist/` — JSON denylists (patterns, substrings, regex) that `check_denylist.py` reads

## Pipeline (per rewrite)

Run the steps in order. A failure at any step means "regenerate this rewrite."
3-retry budget per problem is reasonable.

1. **Fingerprint denylist.** Pattern/substring/regex sweep. No network calls.
   ```sh
   python3 scripts/rewrite/check_denylist.py path/to/rewrite.json
   ```
   Non-zero exit ⇒ a sample, title, or bound matches a known fingerprint →
   rewrite this field.

2. **Sample I/O consistency.** Submit a reference solution to Judge0 and
   compare stdout against each claimed sample output.
   ```sh
   python3 scripts/rewrite/check_solution.py \
       --slug pair-sum \
       --rewrite path/to/rewrite.json \
       --solution path/to/reference.py \
       --language python
   ```
   Non-zero exit ⇒ sample outputs disagree with a correct solver → fix
   samples or fix description.

3. **Similarity probe** (operator-driven, no CLI). During a Claude Code
   orchestration session, delegate the rewrite to a `general-purpose`
   subagent with the operator's similarity-probe prompt. Subagent returns
   strict-JSON verdict `{matches: bool, confidence: 0-100, reasoning: str}`.
   Treat `matches && confidence > 60` as reject.

## Environment variables

- `CODEBITE_DENYLIST_DIR` — override the denylist directory. When unset,
  `check_denylist.py` reads from the bundled `scripts/rewrite/denylist/`
  alongside the script.

- `JUDGE0_URL` — Judge0 base URL consumed by `check_solution.py` via the
  `--judge0-url` flag. Defaults to the local dev instance baked into
  `check_solution.py`.

## Extending the denylists

Each denylist JSON is structured; just add another entry and re-run:

- `denylist/examples.json` — canonical sample I/O fixtures. Buckets by type.
- `denylist/titles.json` — substrings that must not appear in a title or slug.
- `denylist/bounds.json` — regex patterns over constraint bounds; also carries
  the CodeBite size-doctrine hint (`cdoctrine_hint`).

Patterns shorter than 4 characters are ignored as too-noisy.
