# Newer runtimes come from our own Judge0 image, built by hand outside CI

The newest self-hostable Judge0 (1.13.1) tops out at Python 3.8.1, so CodeBite runs its own image, `localhost/codebite-judge0`, which builds newer runtimes from source on top of `judge0/judge0:1.13.1` and registers them in `db/languages/active.rb` as new language ids. We kept Judge0 rather than replacing it because its isolate sandbox is the security boundary for user code, and the hosted Judge0 CE that already has newer runtimes cannot be self-hosted.

The image is built by hand on the production server with `scripts/build-judge0-image.sh`, and the compose file names it by tag only, with `pull_policy: never`. It has no `build:` entry because `deploy.yml` runs `docker compose build` on every push. That uses BuildKit, which cannot reuse the classic builder's cache, so every deploy would recompile Python on all four cores of the live server and come close to the deploy's 20-minute timeout.

## Consequences

- The image lives only in the server's local Docker store, with no registry. If it is lost, Judge0 fails to start until the build script is run again.
- `pull_policy: never` and the `localhost/` prefix make sure a missing image is never replaced by one pulled from Docker Hub. The workers run privileged.
- A runtime upgrade is a manual image rebuild followed by a code change that switches the language id. Old ids stay in the image, so rolling back is a one-line change.
- The id is the constant on `Language` (`common/.../judge/Language.java`); the worker keeps no table of its own. Events carry the language code beside the id, and the worker sends Judge0 the id its event names, so an event queued before a switch runs on the id it was built for and no retired id needs listing.
