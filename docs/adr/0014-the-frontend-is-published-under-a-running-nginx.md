# The frontend is published under a running nginx

The frontend's built files used to be baked into the nginx image, so every deploy that changed the frontend replaced `codebite-nginx`: the old container stopped, the new one started under the same name and port, and for about 2 seconds nothing listened on port 80 (a production Run request got a 502 in one such window). nginx is now a stock image that a deploy leaves running. The build lives in an image of its own (`codebite-frontend`, `frontend/Dockerfile`) whose only job is to copy itself into the `codebite-frontend` volume, which nginx serves read-only from `/srv/frontend/html`; `scripts/deploy-prod.sh` runs that copy and then `nginx -s reload`.

The copy (`frontend/publish.sh`) is what makes the swap safe for a page that is open during it. Every file is written under a temporary name and renamed into place, hashed assets first and `index.html` last, so `index.html` never names an asset that isn't there. A replaced build's assets stay for 7 days counted from the publish that replaced them, because an open tab still asks for its own lazy chunks (the Monaco routes); the first publish after those 7 days removes them. Nothing removes them in between, so with no deploys they stay longer, never shorter.

`infra/nginx/` is mounted as a directory, not `nginx.conf` as a file: git replaces the file on a pull, and a container that mounted the file itself kept reading the old one until it was recreated. A deploy runs `nginx -t` on the pulled config in a throwaway container before it rolls, publishes or reloads anything, and a config that fails goes back to the previous commit with nginx untouched.

## Considered Options

- **A second nginx behind a stable front.** The front never restarts and the nginx behind it is replaced as before. Rejected by the maintainer: two proxies on one server to solve a file swap, and the front would itself need a restart story.
- **A release directory per build and a symlink swapped to the new one.** Atomic for the whole build, but the previous build's assets leave with the symlink, so an open tab's next lazy chunk is a 404 unless nginx also falls back through older releases. One directory that builds are added to gives the same atomic `index.html` and keeps old assets with no config for it.
- **Keep the last N builds instead of 7 days.** Five merges in a day would retire a build a tab opened that morning.

## Consequences

- Only a change to the nginx service itself (its image tag, its compose definition) replaces the container, with the same 2-second gap as before; the tag is pinned so that this is a reviewed change and never a side effect of a rebuilt base image. The deploy log says which case a run took: `nginx: kept running, reloaded (…)`, `nginx: kept running, no reload (…)` or `nginx: recreated (…)`.
- The served files are no longer in any image: the `codebite-frontend` volume is the only copy on the server, rebuilt by the next deploy's publish if it is lost. A rollback publishes the previous commit's build the same way, so it too swaps `index.html` last and leaves both builds' assets in place. A publish that fails is a cause for that rollback like a failed final health check: the backend has rolled by then, so the deploy goes back to the previous commit, backend and build rather than stop between two versions.
- The volume grows by each build's changed assets and shrinks 7 days later.
- The first deploy from the baked image is the one frontend deploy that still replaces the container, since its image and mounts change; the volume is filled before that, so it comes up serving with no step by hand.
