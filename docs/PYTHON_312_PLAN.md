# Python 3.12 on Judge0 — Plan

Goal: user code in Python runs on **Python 3.12** instead of 3.8.1, so users can write modern Python (`list[int]`, `match`, `int | None`, PEP 701 f-strings, `itertools.pairwise`, `functools.cache`).

Status (2026-10-28): steps 1–5 done. Production Judge0 runs the py312 image (deploy A, #74), the replay passed with 200 Accepted on id 100 (#76), and CodeBite sends Python as id 100 (deploy B, #54). Why the image is built by hand outside CI: [ADR 0004](adr/0004-custom-judge0-image-built-outside-ci.md).

## Background

- CodeBite sends Python code to Judge0 as language **71 = Python 3.8.1** (`JudgeService.LANGUAGE_IDS`, `common/src/main/java/com/codebite/judge/service/JudgeService.java:23`). The worker's `SubmissionMetrics.LANGUAGE_NAMES` maps the ids back to names for metrics. Those are the only two places that name the Python language id.
- Production runs `judge0/judge0:1.13.1` (`infra/docker-compose.prod.yml`, services `judge0` and `judge0-workers`) on the mini PC `mini` (192.168.219.200, `~/CodeBite/infra`). The dev backend also uses that Judge0 (`application-dev.yml`: `http://192.168.219.200:2358`).
- 1.13.1 is the newest Judge0 image published. Its newest Python is 3.8.1. The hosted ce.judge0.com runs an unreleased 1.14.0 with Python 3.11–3.14, but that can't be self-hosted.
- On 3.8.1, **46 of the 200 Python starters crash before user code runs** because they use `list[...]` hints (`TypeError: 'type' object is not subscriptable`).

## Decisions

- **Keep Judge0.** Its sandbox (isolate) handles network, CPU, memory, process and filesystem limits. Replacing it is not worth the security risk.
- **Build a custom image on top of `judge0/judge0:1.13.1`** that adds Python 3.12 next to 3.8.1, as a new language **id 100** (the id hosted Judge0 uses for Python 3.12).
- **Upgrade in place.** `"python"` means id 100 after the switch; the version is a runtime detail, not a new language in the picker. Submissions keep storing `language = "python"`, so 3.8 and 3.12 results can't be told apart afterwards (accepted).
- **Id 100 means "the image's current 3.12.x".** A patch upgrade is an image rebuild plus an `active.rb` edit; CodeBite code doesn't change.
- **Keep language 71 in the image**, so switching back is a one-line change in `JudgeService`.
- **Turn off the int/str digit limit** (`PYTHONINTMAXSTRDIGITS=0`). Python 3.11+ raises `ValueError` when converting an int over 4300 digits to text; 3.8 does not. The limit protects servers parsing untrusted input, which isolate already covers, and leaving it on would break user code that works today.
- **No registry, no pulls.** The image is tagged `localhost/codebite-judge0:1.13.1-py312` and both services use `pull_policy: never`. A missing image fails loudly instead of compose pulling a `codebite/...` image someone else published on Docker Hub into a privileged container.
- **Not doing Java batch execution** (all test cases in one run). Dropped: a crash or timeout in one test case would lose the results of the cases after it.

## What was verified (test stack on `mini`, port 2359, since removed)

`scripts/check-judge0-python.py` compares id 71 with id 100 on the same Judge0:

| Check | 3.8.1 (71) | 3.12.16 (100) |
|---|---|---|
| `GET /languages` | listed | listed as `100: Python (3.12.16)` |
| `list[int]`, `match`, `int \| None`, PEP 701 f-string, `itertools.pairwise` | all fail | all work |
| `ssl`, `ctypes`, `sqlite3`, `decimal`, `zlib`, `lzma`, `bz2`, `hashlib`, `uuid`, `readline` | | all import (OpenSSL 1.1.1d) |
| 200 Python starters through their drivers, sample 1 | 46 fail to load | 0 fail to load |

The sandbox still enforces its limits on 3.12: network unreachable, Time Limit Exceeded on an endless loop, a 512 MB allocation killed, a fork bomb blocked, and `/usr/local` read-only.

Only `_tkinter` did not build (no Tk on the base image; not needed).

Rerun on 2026-10-27 against the rebuilt image (checksum, `PYTHONINTMAXSTRDIGITS=0`): the same results, plus a 5001-digit int printing on both ids. By then 47 starters failed to load on 3.8.

## The image

The image is `localhost/codebite-judge0:1.13.1-py312` (14.7 GB), built from [`infra/judge0/Dockerfile`](../infra/judge0/Dockerfile) by `scripts/build-judge0-image.sh`.

Things that matter about it:
- **Languages must be added in `active.rb`, not with SQL.** The Judge0 server runs `rails db:seed` on every start. The seed deletes every language row and recreates them from `db/languages/active.rb`.
- **`active.rb` has no trailing newline.** Without the `printf "\n"`, the appended line joins the closing `]`. The seed then fails, and `/languages` returns `[]`.
- **Both services use this image.** `judge0` needs the language row; `judge0-workers` needs the Python binary.
- **The checksum.** python.org publishes no SHA-256 for the release (only GPG and Sigstore signatures), so the pinned hash was computed from the tarball after `gpg --verify` of its `.asc` passed with the 3.12 release manager's key. Do the same on a version bump.
- **Python 3.12 builds from source on the image's Debian buster.** All the dev libraries are already in the image. Buster is EOL, so `apt-get` would need archive mirrors, but the build doesn't use apt.
- **Isolate mounts `/usr` read-only**, so the sandbox can see `/usr/local/python-3.12.16/`.
- **Build it on `mini` with the classic builder and limited CPU**, so live judging keeps priority (`scripts/build-judge0-image.sh` has the exact command).
- **Testing needs a Linux host.** Judge0 1.13.1 workers need cgroup v1 and `privileged`, which Docker Desktop on macOS doesn't give.
- **If the image is lost** (manual `docker system prune -a`, new disk), Judge0 won't start until `scripts/build-judge0-image.sh` is run again. `deploy.yml`'s `docker image prune -f` only removes dangling images, so it is safe.

## Steps

### 1. Put the image in the repo and rebuild it
- Add `infra/judge0/Dockerfile`, with the verified SHA-256.
- Add `scripts/build-judge0-image.sh`. It pipes the Dockerfile over `ssh mini` as the whole build context (it copies nothing in), runs the build there, and tags the image `localhost/codebite-judge0:1.13.1-py312`. The server's checkout doesn't need to be on this branch.
- Add a check to `scripts/check-judge0-python.py` that `print(10**5000)` works on id 100.
- Rebuild on `mini`, bring up the throwaway test stack (below) on the new image, and rerun `check-judge0-python.py` against it. Then remove the old `codebite/judge0:1.13.1-py312` tag.
- **Do not add `build:` to the Judge0 services in `docker-compose.prod.yml`** (ADR 0004). Reference the pre-built image by tag only.

### 2. Fix the four broken Python drivers (issue #47)
`count-desk-clusters`, `detect-portal-loop`, `longest-combo-run` and `verify-task-order`: each Python driver calls the old method name. Change it to the name the starter defines. Verify each on Judge0 with a correct solution against all of the problem's test cases. Independent of Python 3.12; can ship first.

### 3. Deploy A: swap the Judge0 image, by hand (no user-visible change)
`scripts/cutover-judge0-py312.sh` is a wizard for the steps below: it pushes the swap commit only if it says `[skip ci]`, pulls on `mini`, asks before restarting Judge0, then checks `/languages`, runs `print(6*7)` on both ids through a worker, and offers a rollback to `judge0/judge0:1.13.1` through a compose override outside the checkout.

- In `infra/docker-compose.prod.yml`, change both `judge0` and `judge0-workers` from `judge0/judge0:1.13.1` to `localhost/codebite-judge0:1.13.1-py312`, and add `pull_policy: never` to both.
- Commit to master with `[skip ci]` in the message, so `deploy.yml` doesn't run. A normal deploy would restart Judge0 at an unplanned moment, at the end of a backend roll.
- At low traffic, on `mini`: `cd ~/CodeBite && git pull origin master && docker compose -f infra/docker-compose.prod.yml up -d --no-deps judge0 judge0-workers`. Pulling first keeps `mini`'s working tree clean; a local edit to the compose file would make the next deploy's `git pull` fail.
- Watch it come up. Check: `curl localhost:2358/languages` on `mini` lists both 71 and 100. A Python submission on the site still works (still id 71).
- Why separate from step 5: if both changed together, backends sending id 100 could reach the old Judge0, and every Python submission would fail.
- Submissions in flight during the restart may fail (accepted; the restart is short and done at low traffic).

### 4. Replay: the gate for deploy B
Proves that working solutions still pass on 3.12, not just that the starters load.
- For each problem, take the latest Accepted Python submission from production: a user's if there is one, otherwise an admin's. A problem with none gets a reference solution from the problem-generator.
- Run each on id 100 against **all** of the problem's test cases on production Judge0 (`localhost:2358` on `mini`), one problem at a time with a pause between, at low traffic.
- Every problem must be Accepted. Retry a Time Limit Exceeded once before counting it as a failure (timing noise).
- Fix any failures (driver or test case) before step 5.
- Run it with `scripts/replay-judge0-python.py`. It reads an export made by `scripts/replay-judge0-python.sql` and takes reference solutions from `scripts/replay-solutions/<slug>.py`. It exits 1 unless every problem was Accepted. Its report lists the problems that failed apart from those with nothing to replay (no Accepted Python submission and no reference solution). Rerun just the failures with `--only slug,...`.

  ```bash
  # on mini
  docker exec -i codebite-postgres psql -U codebite -d codebite -tA < scripts/replay-judge0-python.sql > /tmp/replay.json
  python3 -I scripts/replay-judge0-python.py http://localhost:2358 100 . /tmp/replay.json --pause 2
  ```
  Its tests run against a fake Judge0, and its local judge against real tiny programs on the local Python 3.12: `python3 -I scripts/replay-judge0-python.test.py`.

- **Locally, without Judge0** (for writing and checking reference solutions; never point parallel runs at production Judge0). The replay takes the path of a Python 3.12+ interpreter in place of a Judge0 URL and runs each test case in its own process, with the same driver assembly, output comparison and verdicts: exit 0 is compared as output (Accepted or Wrong Answer), an exception or syntax error is Runtime Error, a run past `--time-limit` seconds of wall-clock time (default 5) is Time Limit Exceeded, retried once. Judge0's default limit is 5 seconds of CPU time, so the local limit is stricter when the machine is busy: a local Time Limit Exceeded under load may still pass on Judge0. It refuses an interpreter older than 3.12. The system `python3` on macOS is 3.9, so name 3.12 explicitly (`/opt/homebrew/bin/python3.12`, or set `CODEBITE_PYTHON312`).

  1. Migrate the local database to master first. It has been found behind (pre-#48 slugs), and a stale database judges against old slugs and test cases. Compare `docker exec codebite-postgres psql -U codebite -d codebite -tAc "select max(version::int) from flyway_schema_history where success"` with the newest `common/src/main/resources/db/migration/V*` on master. If it is behind, start the backend once from an up-to-date master checkout (`source scripts/dev-env.sh && SPRING_PROFILES_ACTIVE=dev ./gradlew :backend:bootRun`; Flyway migrates on boot), then stop it. `scripts/replay-local.sh` warns when the database is behind the checkout.
  2. Check a set of problems (the database runs via `docker compose -f infra/docker-compose.yml up -d`):

     ```bash
     scripts/replay-local.sh spot-duplicate-locker,lru-cache
     ```
     It exports the local database with `scripts/replay-judge0-python.sql` into a temporary file, replays the named slugs with this checkout's `scripts/replay-solutions/`, and exits 1 unless every one was Accepted (a slug not in the database is an error). Each run makes its own export, so several worktrees can run it at once. With no slugs it replays every problem; arguments after the slugs go to the replay (e.g. `--time-limit 10`).

     The same thing by hand, keeping the export:
     ```bash
     docker exec -i codebite-postgres psql -U codebite -d codebite -tA < scripts/replay-judge0-python.sql > /tmp/replay-local.json
     python3 -I scripts/replay-judge0-python.py /opt/homebrew/bin/python3.12 100 . /tmp/replay-local.json --pause 0 --only spot-duplicate-locker
     ```

  A reference solution is the complete code a user would type into the editor: the starter's `Solution` class and method (`backend/src/main/resources/starters/<slug>/python.py`), or the design class the driver constructs. It may use 3.12 syntax. A problem with an Accepted Python submission in the local database (`snack-drawer-pair` and `valid-anagram` locally) replays that submission instead of its reference solution, as on production.

### 5. Deploy B: switch CodeBite to id 100 (normal push)
- In `JudgeService.LANGUAGE_IDS`, change `"python", 71` to `"python", 100`. The backend picks the id for both Run and Submit; for Submit it sends the id to the worker in the `SubmissionEvent`.
- In the worker, `SubmissionMetrics.LANGUAGE_NAMES` (`worker/src/main/java/com/codebite/worker/consumer/SubmissionMetrics.java:18`) maps ids back to names for the `codebite.submissions.completed` metric. Add `100, "python"`, and keep `71`, which events already in Kafka still carry. Without this, Grafana tags every Python submission as `unknown`.
- Check tests that assert language ids, if any, and update them.
- After deploy: Run and Submit a Python solution that uses `list[int]` and `match` on the site.
- To roll back: set it back to 71 and redeploy. The image keeps both languages.

### 6. Optional follow-ups
- Change the 82 starters that use `from typing import List` / `List[...]` to `list[...]`, and `Optional[X]` to `X | None`. Users' saved drafts keep the old text, which still runs on 3.12.
- Update `.claude/agents/problem-generator.md:234` (`from typing import List, Optional`) so new problems use modern hints.
- Mention the Python version in the UI's language picker, e.g. "Python 3.12".
- Later, the same image pattern can add newer Java (JDK 21) and Node.js (22) as new language ids.

## Verification tool

`scripts/check-judge0-python.py` (uncommitted when this plan was written):

```bash
docker exec codebite-postgres psql -U codebite -d codebite -tAc "select json_agg(json_build_object('slug', p.slug, 'input', t.input)) from problems p join test_cases t on t.problem_id = p.id and t.is_sample and t.order_index = (select min(order_index) from test_cases t2 where t2.problem_id = p.id and t2.is_sample)" > /tmp/samples.json
python3 -I scripts/check-judge0-python.py http://192.168.219.200:2358 . /tmp/samples.json
```

It needs a Judge0 that has both ids 71 and 100. The "other errors on 3.12" section is expected: the starters' body is `pass`, so drivers receive `None`. Only the "fail to load" counts matter. It checks that the starters load; the replay (step 4) checks that solutions pass.

To run a throwaway test Judge0 again on `mini` (separate from the live `codebite-*` containers), put this in `~/judge0-py312/docker-compose.yml`, run `docker compose up -d`, test on port 2359, then `docker compose down -v`:

```yaml
name: judge0-py312-test
services:
  server:
    image: localhost/codebite-judge0:1.13.1-py312
    pull_policy: never
    ports: ["2359:2358"]
    depends_on: [db, redis]
    environment: &env
      REDIS_HOST: redis
      POSTGRES_HOST: db
      POSTGRES_DB: judge0
      POSTGRES_USER: judge0
      POSTGRES_PASSWORD: py312test
  workers:
    image: localhost/codebite-judge0:1.13.1-py312
    pull_policy: never
    command: ["./scripts/workers"]
    privileged: true
    depends_on: [server, db, redis]
    environment: *env
  db:
    image: postgres:13
    environment:
      POSTGRES_DB: judge0
      POSTGRES_USER: judge0
      POSTGRES_PASSWORD: py312test
  redis:
    image: redis:7
```

## Risks

- **Restarting production Judge0 (deploy A).** Submissions in flight during the restart may fail. Done by hand at low traffic.
- **Replay load (step 4).** Runs on the live Judge0 workers; paced one problem at a time at low traffic.
- **Image only on `mini`.** No registry; losing it means a rebuild before Judge0 can start (ADR 0004).
- **Disk.** The image is 14.7 GB next to the 14.2 GB original on `mini` (349 GB free).
- **Old base OS.** Debian buster gets no security updates. This is already true of the current image; isolate is the security boundary.
- **Runtime numbers change.** Python 3.12 is generally faster than 3.8. Python runtimes shown to users and used in stats will shift after deploy B, and old and new results can't be told apart.
