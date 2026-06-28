# Git Workflow

CodeBite 의 git 사용 규칙. 솔로 개발이지만 회사 협업에서도 그대로 통용되는 워크플로우를 따른다.

## TL;DR

1. `master` 에 직접 커밋하지 않는다. 모든 변경은 단기 feature 브랜치에서.
2. 브랜치 1개 = Issue 1개 = PR 1개.
3. Conventional Commits (`feat:`, `fix:`, `perf:`, ...) 사용, 1 커밋 = 1 논리 변경.
4. PR 본문에 `Closes #N` 적으면 머지 시 이슈 자동 종료.
5. Squash merge 로 합치고, 브랜치는 삭제한다.

---

## 1. 브랜치 모델 — GitHub Flow

`master` = 항상 배포 가능한 상태. 모든 작업은 단기 feature 브랜치에서.

```
master ─────●─────●─────●─────●─────●─────
            \           /     \         /
             ●─●─●─●─● /       ●─●─●─● /
             feat/foo          perf/bar
```

대안 비교:
- **Git Flow** (develop / release / hotfix 브랜치) — 정기 릴리스 사이클 있는 팀 전용. 솔로엔 과함.
- **Trunk-based** — feature flag + 매우 짧은 브랜치(<1일). 팀에 좋지만 솔로엔 GitHub Flow 와 사실상 동일.

---

## 2. 브랜치 네이밍

```
<type>/<short-kebab-summary>
<type>/<issue#>-<short>
```

예시:
- `feat/oauth-github-provider`
- `fix/auth-jwt-expired-claim`
- `perf/12-judge0-batch-endpoint`
- `docs/architecture-update`
- `refactor/run-service-split`

### Type prefix

| Type | 의미 |
|---|---|
| `feat` | 새 기능 |
| `fix` | 버그 수정 |
| `perf` | 성능 개선 |
| `refactor` | 동작 동일, 구조 변경 |
| `docs` | 문서만 |
| `test` | 테스트 추가/수정 |
| `chore` | 빌드/설정/잡일 |

---

## 3. 커밋 메시지 — Conventional Commits

```
<type>(<scope>): <subject>

[optional body — 왜 (why) 를 설명]

[optional footer — Closes #N, BREAKING CHANGE: ...]
```

규칙:
- subject: 명령형 현재시제 (`add`, `fix`, `remove` — 과거형 `added` 금지), 첫 글자 소문자, 마침표 없이, 72자 이내.
- 1 커밋 = 1 논리 변경 (atomic commit). 여러 무관 변경은 분리.
- body 는 *what* 이 아닌 *why*. 코드 자체가 *what* 을 말함.

### 예시

```
perf(worker): use Judge0 batch endpoint to collapse N round-trips

Previously the worker submitted each test case to Judge0 individually
and polled per case, taking O(N) HTTP round-trips. Switching to the
batch endpoint reduces this to a single submit + single polling loop.

Measured: 10-test submission improved from ~6s to ~1.5s end-to-end.

Closes #12
```

```
fix(auth): clear blacklisted JWT entries when TTL expires

The cleanup job never ran because @Scheduled was not enabled. Adds
@EnableScheduling to the main application class.

Closes #34
```

---

## 4. Issue → Branch → PR 라이프사이클

### 4.1 새 작업 시작

```bash
# 1. master 최신화
git checkout master
git pull origin master

# 2. 작업 브랜치 생성 (이슈 번호 포함 권장)
git checkout -b perf/12-judge0-batch

# 3. 작업
# ... 코드 변경 ...

# 4. 의미 있는 단위로 커밋
git add path/to/changed/files
git commit -m "perf(worker): use Judge0 batch endpoint"

# 5. 원격 push (첫 push 는 -u)
git push -u origin perf/12-judge0-batch
```

### 4.2 PR 생성

```bash
gh pr create \
  --base master \
  --title "perf: use Judge0 batch endpoint for submissions" \
  --body "$(cat <<'EOF'
## Summary
- Replace per-test-case Judge0 calls with /submissions/batch
- Collapses 2N HTTP calls into 2 (1 submit + 1 polling loop)

## Test plan
- [x] Unit tests pass: ./gradlew :common:test :worker:test
- [x] Local docker-compose: submit 10-test problem, measure end-to-end time
- [x] Grafana: codebite_submissions_processing_duration p95 dropped from X to Y

Closes #12
EOF
)"
```

### 4.3 PR 본문 표준 섹션

- **Summary**: 1~3 bullets — 무엇을 왜.
- **Test plan**: 체크리스트 — 어떻게 검증했는지.
- **Screenshots** (UI 변경 시): before / after.
- **Closes #N**: 자동 이슈 종료.

### 4.4 머지 후 정리

```bash
# 1. master 로 돌아가서 최신화
git checkout master
git pull origin master

# 2. 로컬 브랜치 삭제
git branch -d perf/12-judge0-batch

# 3. 원격 브랜치는 GitHub 의 "Delete branch" 또는
gh api -X DELETE repos/Kyu-seok/CodeBite/git/refs/heads/perf/12-judge0-batch
```

### 4.5 PR 머지 전략

| 전략 | 사용 시기 |
|---|---|
| **Squash merge** (권장 기본) | feature 브랜치의 여러 WIP 커밋을 1개 깔끔한 커밋으로. `master` 히스토리가 선형. |
| Rebase merge | 커밋 하나하나가 의미 있고 보존 가치 있을 때 (드뭄). |
| Merge commit | 큰 feature 브랜치의 분기점을 보존하고 싶을 때. `master` 가 복잡해짐 — 솔로엔 비추천. |

CodeBite 기본값: **Squash merge**.

---

## 5. Issue 관리

### 5.1 라벨

| Label | 용도 |
|---|---|
| `bug` | 버그 |
| `enhancement` | 기능 추가/개선 |
| `performance` | 성능 |
| `security` | 보안 |
| `documentation` | 문서 |
| `refactor` | 구조 개선 |
| `good first issue` | 진입 쉬운 작업 (외부 기여자용) |
| `wontfix` | 의도적으로 안 함 |
| `duplicate` | 중복 |

### 5.2 Issue body 권장 구조

```markdown
## Problem
사용자/시스템 관점에서 무엇이 문제인지. 재현 단계.

## Proposed Fix
무엇을 어떻게 바꾸려는지.

## Files Affected
- path/to/file.java:NN
- path/to/other.ts

## Acceptance Criteria
- [ ] 조건 1
- [ ] 조건 2
- [ ] 테스트 통과
```

### 5.3 Issue ↔ PR 연결

- PR description 에 `Closes #N`, `Fixes #N`, `Resolves #N` 중 하나 → 머지 시 자동 close.
- 단순 참조만 하려면 `Related to #N`, `See #N` (close 안 됨).

---

## 6. master 보호 (권장)

GitHub repo → Settings → Branches → Branch protection rules → `master`:

- ☑ Require a pull request before merging
- ☑ Require status checks to pass before merging (CI 추가 후)
- ☑ Require linear history (squash/rebase 만 허용)
- ☐ Require approvals (솔로면 skip, 협업 시 1+)

솔로 프로젝트라도 **PR 강제는 가치 있음**:
- 회사에서의 PR 흐름 적응 훈련
- 머지 전 본인 변경 사항 셀프 리뷰 기회
- 외부에서 봤을 때 "이 사람은 자기 코드를 PR 흐름으로 다룬다" 신호

---

## 7. 절대 하지 말 것

- `git push --force` **to `master`** — 다른 사람(미래의 나 포함)의 작업을 덮음. (feature 브랜치엔 `--force-with-lease` 까지는 OK.)
- `master` 직접 커밋 (`git commit` 후 `git push origin master`) — PR 우회.
- `--no-verify` 로 pre-commit / pre-push hook 우회 — hook 의 의미가 사라짐.
- `--no-gpg-sign` / `--no-edit` 같은 검증/리뷰 우회 플래그를 습관적으로 쓰지 말 것.
- `.env`, credentials 파일 커밋. `.gitignore` 와 `git-secrets` / `pre-commit` hook 으로 막을 것.

---

## 8. 자주 쓰는 명령 치트시트

```bash
# 현재 상태 보기
git status
git log --oneline -10
git diff                          # unstaged 변경
git diff --staged                 # staged 변경

# 브랜치
git checkout -b <branch>          # 새 브랜치 생성 + 전환
git branch -d <branch>            # 로컬 브랜치 삭제 (머지 확인됨)
git branch -D <branch>            # 강제 삭제 (주의)

# 동기화
git pull --rebase origin master   # 로컬 변경을 master 위로 rebase
git fetch origin                  # 원격 정보만 가져오기 (머지 X)

# 임시 보관
git stash                         # 변경 사항 잠시 치우기
git stash pop                     # 되돌리기

# 마지막 커밋 수정 (push 전에만!)
git commit --amend                # 메시지/내용 수정
                                   # push 후엔 새 커밋 만들기

# 되돌리기
git restore <file>                # working tree 변경 취소
git restore --staged <file>       # stage 만 취소 (변경은 유지)
git revert <commit>               # 안전한 되돌리기 (새 커밋 생성)

# PR
gh pr create
gh pr list
gh pr view <number>
gh pr checkout <number>
gh pr merge <number> --squash --delete-branch

# Issue
gh issue create
gh issue list
gh issue view <number>
gh issue close <number>
```

---

## 9. 예시 시나리오: 성능 개선 작업 한 사이클

```bash
# Step 1: 이슈 확인
gh issue view 12

# Step 2: 브랜치 생성
git checkout master && git pull
git checkout -b perf/12-judge0-batch

# Step 3: 작업 + 커밋
# ... 코드 변경 ...
git add common/src/main/java/com/codebite/judge/
git commit -m "perf(judge): add batch submission support to JudgeClient

Adds JudgeClient#submitBatch and #getBatch methods that wrap
Judge0's /submissions/batch endpoint."

git add worker/src/main/java/com/codebite/worker/consumer/
git commit -m "perf(worker): use batch endpoint in SubmissionConsumer

Replaces per-test-case loop with single batch submission, reducing
N HTTP round-trips to 1 + polling.

Closes #12"

# Step 4: push + PR
git push -u origin perf/12-judge0-batch
gh pr create --base master --title "perf: Judge0 batch submissions" --body "..."

# Step 5: CI 통과 확인 후 셀프 리뷰 → 머지
gh pr merge --squash --delete-branch

# Step 6: 정리
git checkout master && git pull
git branch -d perf/12-judge0-batch
```
