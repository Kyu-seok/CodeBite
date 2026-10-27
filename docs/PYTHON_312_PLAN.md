# Python 3.12 on Judge0 — Plan

Goal: user code in Python runs on **Python 3.12** instead of 3.8.1, so users can write modern Python (`list[int]`, `match`, `int | None`, PEP 701 f-strings, `itertools.pairwise`, `functools.cache`).

Status (2026-10-27): feasibility proven on a test Judge0. No CodeBite code changed yet.

## Background

- CodeBite sends Python code to Judge0 as language **71 = Python 3.8.1** (`JudgeService.LANGUAGE_IDS`, `common/src/main/java/com/codebite/judge/service/JudgeService.java:23`). The worker's `SubmissionMetrics.LANGUAGE_NAMES` maps the ids back to names for metrics. Those are the only two places that name the Python language id.
- Production runs `judge0/judge0:1.13.1` (`infra/docker-compose.prod.yml`, services `judge0` and `judge0-workers`) on the mini PC `mini` (192.168.219.200, `~/CodeBite/infra`). The dev backend also uses that Judge0 (`application-dev.yml`: `http://192.168.219.200:2358`).
- 1.13.1 is the newest Judge0 image published. Its newest Python is 3.8.1. The hosted ce.judge0.com runs an unreleased 1.14.0 with Python 3.11–3.14, but that can't be self-hosted.
- On 3.8.1, **46 of the 200 Python starters crash before user code runs** because they use `list[...]` hints (`TypeError: 'type' object is not subscriptable`).

## Decisions

- **Keep Judge0.** Its sandbox (isolate) handles network, CPU, memory, process and filesystem limits. Replacing it is not worth the security risk.
- **Build a custom image on top of `judge0/judge0:1.13.1`** that adds Python 3.12 next to 3.8.1, as a new language **id 100** (the id hosted Judge0 uses for Python 3.12).
- **Keep language 71 in the image**, so switching back is a one-line change in `JudgeService`.
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

## The image

Built and tagged on `mini` as `codebite/judge0:1.13.1-py312` (14.7 GB). The source is only on `mini` in `~/judge0-py312/`. Step 1 adds it to the repo:

```dockerfile
# Judge0 1.13.1 plus Python 3.12, registered as language 100 (the id hosted Judge0 uses).
FROM judge0/judge0:1.13.1
USER root

ENV PYTHON_312_VERSION=3.12.16
RUN set -xe && \
    curl -fSsL "https://www.python.org/ftp/python/$PYTHON_312_VERSION/Python-$PYTHON_312_VERSION.tar.xz" -o /tmp/python.tar.xz && \
    mkdir /tmp/python && \
    tar -xf /tmp/python.tar.xz -C /tmp/python --strip-components=1 && \
    cd /tmp/python && \
    ./configure --prefix=/usr/local/python-$PYTHON_312_VERSION && \
    make -j2 && \
    make install && \
    rm -rf /tmp/*

# The server re-seeds languages from active.rb on every start, so the entry must live here.
# active.rb has no trailing newline, so start a new line before appending.
RUN printf "\n" >> /api/db/languages/active.rb && echo "@languages << { id: 100, name: \"Python (3.12.16)\", is_archived: false, source_file: \"script.py\", run_cmd: \"/usr/local/python-3.12.16/bin/python3 script.py\" }" \
      >> /api/db/languages/active.rb

USER judge0
```

Things that matter about it:
- **Languages must be added in `active.rb`, not with SQL.** The Judge0 server runs `rails db:seed` on every start. The seed deletes every language row and recreates them from `db/languages/active.rb`.
- **`active.rb` has no trailing newline.** Without the `printf "\n"`, the appended line joins the closing `]`. The seed then fails, and `/languages` returns `[]`.
- **Both services use this image.** `judge0` needs the language row; `judge0-workers` needs the Python binary.
- **Python 3.12 builds from source on the image's Debian buster.** All the dev libraries are already in the image. Buster is EOL, so `apt-get` would need archive mirrors, but the build doesn't use apt.
- **Isolate mounts `/usr` read-only**, so the sandbox can see `/usr/local/python-3.12.16/`.
- **Build it on `mini` with the classic builder and limited CPU**, so live judging keeps priority: `DOCKER_BUILDKIT=0 docker build --cpuset-cpus=2,3 --cpu-shares=128 -t codebite/judge0:1.13.1-py312 .`
- **Testing needs a Linux host.** Judge0 1.13.1 workers need cgroup v1 and `privileged`, which Docker Desktop on macOS doesn't give.

## Steps

### 1. Put the image in the repo
- Add the Dockerfile above as `infra/judge0/Dockerfile`.
- Add `scripts/build-judge0-image.sh`. It runs the build command above on the server (`ssh mini`, from `~/CodeBite/infra/judge0`) and tags the image `codebite/judge0:1.13.1-py312`.
- **Do not add `build:` to the Judge0 services in `docker-compose.prod.yml`.** `.github/workflows/deploy.yml` runs `docker compose build` on every push to master. That uses BuildKit, which does not share the classic builder's cache. It would recompile Python on every deploy, using all 4 cores of the live server and coming close to the deploy's `command_timeout: 20m`. Reference the pre-built image by tag only.

### 2. Fix the four broken Python drivers (issue #47)
`count-desk-clusters`, `detect-portal-loop`, `longest-combo-run` and `verify-task-order`: each Python driver calls the old method name. Change it to the name the starter defines. Verify each on Judge0 with a correct solution against all of the problem's test cases. Independent of Python 3.12; can ship first.

### 3. Deploy A: swap the Judge0 image (no user-visible change)
- In `infra/docker-compose.prod.yml`, change both `judge0` and `judge0-workers` from `judge0/judge0:1.13.1` to `codebite/judge0:1.13.1-py312`.
- Make sure the image exists on `mini` first (step 1 script; it is already there today).
- After deploy, check: `curl localhost:2358/languages` on `mini` lists both 71 and 100. A Python submission on the site still works (still id 71).
- Why separate from step 4: `deploy.yml` rolls the backends first, then runs `docker compose up -d --remove-orphans`, which recreates Judge0 last. If both changes shipped together, new backends would send id 100 to the old Judge0 for a few minutes, and every Python submission would fail.

### 4. Deploy B: switch CodeBite to id 100
- In `JudgeService.LANGUAGE_IDS`, change `"python", 71` to `"python", 100`. The backend picks the id for both Run and Submit; for Submit it sends the id to the worker in the `SubmissionEvent`.
- In the worker, `SubmissionMetrics.LANGUAGE_NAMES` (`worker/src/main/java/com/codebite/worker/consumer/SubmissionMetrics.java:18`) maps ids back to names for the `codebite.submissions.completed` metric. Add `100, "python"`, and keep `71`, which events already in Kafka still carry. Without this, Grafana tags every Python submission as `unknown`.
- Check tests that assert language ids, if any, and update them.
- Run `scripts/check-judge0-python.py` against production Judge0 (port 2358) before merging. Every starter must load on id 100.
- After deploy: Run and Submit a Python solution that uses `list[int]` and `match` on the site.
- To roll back: set it back to 71 and redeploy. The image keeps both languages.

### 5. Optional follow-ups
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

It needs a Judge0 that has both ids 71 and 100. The "other errors on 3.12" section is expected: the starters' body is `pass`, so drivers receive `None`. Only the "fail to load" counts matter.

To run a throwaway test Judge0 again on `mini` (separate from the live `codebite-*` containers), put this in `~/judge0-py312/docker-compose.yml`, run `docker compose up -d`, test on port 2359, then `docker compose down -v`:

```yaml
name: judge0-py312-test
services:
  server:
    image: codebite/judge0:1.13.1-py312
    ports: ["2359:2358"]
    depends_on: [db, redis]
    environment: &env
      REDIS_HOST: redis
      POSTGRES_HOST: db
      POSTGRES_DB: judge0
      POSTGRES_USER: judge0
      POSTGRES_PASSWORD: py312test
  workers:
    image: codebite/judge0:1.13.1-py312
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

- **Restarting production Judge0 (deploy A).** Submissions in Judge0's queue during the restart may stall. Do it at low traffic.
- **Disk.** The image is 14.7 GB next to the 14.2 GB original on `mini` (349 GB free).
- **Old base OS.** Debian buster gets no security updates. This is already true of the current image; isolate is the security boundary.
- **Runtime numbers change.** Python 3.12 is generally faster than 3.8. Python runtimes shown to users and used in stats will shift after deploy B.
