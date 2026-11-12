# Walkthroughs are repo files, not migrations

Every other piece of a problem (description, Test Cases, translations, Diagrams) reaches the database through a Flyway migration, but a Walkthrough is a JSON file in the repo, one per problem under `walkthroughs/<slug>.json`, read once at startup and served by its own endpoint. A Walkthrough is generated, not written: a script runs the instrumented reference solution on every sample Test Case and writes the frames, so it is large (dozens of frames per run, several runs per problem) and is regenerated whenever its captions, its drawing or the problem's sample cases change. As migrations, each regeneration would be a new versioned file carrying the whole Walkthrough again, the current one would be whatever the newest migration says, and a review would diff SQL strings instead of the frames themselves.

## Considered Options

- **A column set by a migration**, like the description. One source of truth for all problem data and no startup loader, but every regeneration adds a migration copying the whole Walkthrough, and the "newest migration wins" lookup the problem scripts already work around would apply to a far larger and more frequently changed value.
- **Static files bundled into the frontend.** No backend change, but they would grow the build, ship every Walkthrough to every visitor's cache, and sit out of reach of the backend test that checks each run's answer against the sample's expected output.

## Consequences

A Walkthrough can fall out of step with its problem, since a migration that corrects a sample Test Case does not touch the file. One backend test therefore fails when a sample Test Case has no run in its problem's Walkthrough or a run's last frame does not equal that sample's expected output, compared trimmed as the Grader compares. A Restatement that changes a Slug must also rename the Walkthrough file, as it renames the Driver and Starter Code directories.
