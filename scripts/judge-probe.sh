#!/usr/bin/env bash
# Sends one source file in one Language to a real Judge0, as CodeBite sends a program, and prints
# Judge0's status, compile output, stdout and stderr: what CodeBite's Judge0 does with that code.
# scripts/judge-local.sh and local compilers only say what the local judge does.
#
#   JUDGE0_URL=<url> scripts/judge-probe.sh <language> <file> [--stdin <file>]
#   scripts/judge-probe.sh <language> <file> [--stdin <file>] --production
#
# <language> is a code Language.ofRequest accepts (java, python, javascript, cpp; any case). Its
# Judge0 id is read from the enum in common/.../judge/Language.java on every run, so there is no
# second table; a code missing there is refused, and a Language.java the pattern can't read fails
# naming the file, never guessing an id.
#
# <file> is the whole program Judge0 compiles and runs, with its own main: no Driver is wrapped
# around it. What is sent is what JudgeClientImpl sends: POST /submissions?base64_encoded=true with
# {source_code, language_id, stdin}, source and stdin base64 (stdin empty without --stdin), no
# compiler options or limits, so Judge0 uses its defaults as it does for CodeBite (C++ is GCC 9.2
# at gnu++14). Then GET /submissions/<token>?base64_encoded=true every 150 ms until the status
# leaves In Queue and Processing, for up to 30 s (JUDGE_PROBE_WAIT seconds), as JudgeService polls.
#
# The target is the Judge0 JUDGE0_URL names. Unset, the script exits 2 saying to set it. A
# JUDGE0_URL naming production's Judge0 (192.168.219.200 or mini, the server whose Judge0 the dev
# profile defaults to; the compose name judge0; code-bite.com) is refused: a Tailscale or other name
# for that server isn't known here, so don't point JUDGE0_URL at it.
#
# --production runs the code on the production judge, so it needs the maintainer's go-ahead each
# time it is used. It runs curl on the server over `ssh $SSH_TARGET` (default mini, as
# scripts/cutover-judge0-py312.sh does) against its localhost:2358, and ignores JUDGE0_URL. Without
# the flag, ssh never runs.
#
# Exits 0 when Judge0 says Accepted (it compiled and ran), 1 for any other verdict on the code
# (Compilation Error, a Runtime Error, Time Limit Exceeded), and 2 when nothing was judged: usage, an
# unknown language, no JUDGE0_URL, a production URL without --production, or a Judge0 that doesn't
# answer, answers with an HTTP error, not JSON or no status, takes over 30 s, or reports its own
# Internal Error.
# A 2 prints one line on stderr and no status, so it never reads as a rejection. A warning in the
# compile output doesn't change the exit: CodeBite fails code only on Judge0's status.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"

usage() {
  echo "usage: JUDGE0_URL=<url> scripts/judge-probe.sh <language> <file> [--stdin <file>] [--production (maintainer's go-ahead only)]" >&2
  exit 2
}
[[ $# -ge 2 && "$1" != -* && "$2" != -* ]] || usage
language=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
source_file=$2
shift 2
stdin_file=/dev/null
production=
while [[ $# -gt 0 ]]; do
  case $1 in
    --stdin) [[ $# -ge 2 ]] || usage; stdin_file=$2; shift 2 ;;
    --production) production=1; shift ;;
    *) usage ;;
  esac
done
for file in "$source_file" "$stdin_file"; do
  [[ -r "$file" ]] || { echo "judge-probe.sh: can't read $file" >&2; exit 2; }
done

# The language id, from the enum constant whose code is $language: JAVA("java", 62, "java").
language_id=$(python3 -I - "$root/common/src/main/java/com/codebite/judge/Language.java" "$language" <<'PY'
import re, sys
path, wanted = sys.argv[1], sys.argv[2]
try:
    source = open(path, encoding="utf-8").read()
except OSError as e:
    sys.exit(f"judge-probe.sh: can't read the language ids: {e}")
ids = dict(re.findall(r'^\s*[A-Z][A-Z0-9_]*\("([^"]+)",\s*(\d+),\s*"[^"]*"\)[,;]', source, re.M))
if not ids:
    sys.exit(f"judge-probe.sh: found no language constants in {path}; this script's pattern needs updating")
if wanted not in ids:
    sys.exit(f"judge-probe.sh: {wanted} is not a language CodeBite accepts; use one of {', '.join(ids)}")
print(ids[wanted])
PY
) || exit 2

if [[ -n "$production" ]]; then
  ssh_target=${SSH_TARGET:-mini}
  base=http://localhost:2358
  where="production (localhost:2358 on $ssh_target, over ssh)"
else
  base=${JUDGE0_URL:-}
  [[ -n "$base" ]] || {
    echo "judge-probe.sh: set JUDGE0_URL to a Judge0 that isn't production's (or, with the maintainer's go-ahead, pass --production)" >&2
    exit 2
  }
  base=${base%/}
  host=$(printf '%s' "$base" | tr '[:upper:]' '[:lower:]' | sed -E 's#^[a-z]+://##; s#[/?].*##; s#.*@##; s#:[0-9]*$##')
  case $host in
    192.168.219.200 | mini | judge0 | code-bite.com | www.code-bite.com)
      echo "judge-probe.sh: JUDGE0_URL $base is production's Judge0; code runs there only with --production and the maintainer's go-ahead" >&2
      exit 2 ;;
  esac
  where=$base
fi

work=$(mktemp -d "${TMPDIR:-/tmp}/judge-probe.XXXXXX")
trap 'rm -rf "$work"' EXIT

unreachable() { echo "judge-probe.sh: $1; nothing was judged" >&2; exit 2; }
# call <GET|POST> <path> <answer file> <field>: one request, its answer JSON holding <field> (a
# string, or an object with a numeric id, as a status is); a POST's body is stdin. Timeouts are JudgeClientConfig's: 5 s to connect, 10 s for the answer.
call() {
  local method=$1 path=$2 out=$3 field=$4 ok=1
  local -a options=(-fsS --connect-timeout 5 -m 10)
  [[ "$method" == POST ]] && options+=(-X POST -H 'Content-Type: application/json' --data-binary @-)
  if [[ -n "$production" ]]; then
    # One string for the server's shell, each word quoted; the body goes through ssh's stdin.
    ssh -o BatchMode=yes -o ConnectTimeout=10 "$ssh_target" \
      "curl $(printf '%q ' "${options[@]}" "$base$path")" > "$out" 2> "$work/curl.err" || ok=
  else
    curl "${options[@]}" "$base$path" > "$out" 2> "$work/curl.err" || ok=
  fi
  [[ -n "$ok" ]] || unreachable "no answer from Judge0 at $where ($(tail -n 1 "$work/curl.err"))"
  python3 -I -c '
import json, sys
value = json.load(sys.stdin)[sys.argv[1]]
assert isinstance(value, str) or isinstance(value["id"], int)' "$field" < "$out" 2>/dev/null \
    || unreachable "Judge0 at $where answered $path with something other than Judge0's JSON"
}

JUDGE_PROBE_LANGUAGE_ID=$language_id python3 -I -c '
import base64, json, os, sys
b64 = lambda path: base64.b64encode(open(path, "rb").read()).decode()
print(json.dumps({"source_code": b64(sys.argv[1]), "language_id": int(os.environ["JUDGE_PROBE_LANGUAGE_ID"]),
                  "stdin": b64(sys.argv[2])}))
' "$source_file" "$stdin_file" > "$work/request.json"

call POST "/submissions?base64_encoded=true" "$work/token.json" token < "$work/request.json"
token=$(python3 -I -c 'import json, sys; print(json.load(sys.stdin)["token"])' < "$work/token.json")
[[ "$token" =~ ^[0-9a-f-]+$ ]] || unreachable "Judge0 at $where answered with a token that isn't one: $token"

status_id() { python3 -I -c 'import json, sys; print(json.load(sys.stdin)["status"]["id"])' < "$work/result.json"; }
wait_seconds=${JUDGE_PROBE_WAIT:-30}
deadline=$((SECONDS + wait_seconds))
while :; do
  call GET "/submissions/$token?base64_encoded=true" "$work/result.json" status < /dev/null
  case $(status_id) in 1 | 2) ;; *) break ;; esac
  (( SECONDS < deadline )) || unreachable "Judge0 at $where still hadn't judged it after $wait_seconds s"
  sleep 0.15
done
status=$(status_id)
[[ "$status" -ne 13 ]] || unreachable "Judge0 at $where reported an Internal Error ($(python3 -I -c '
import base64, json, sys
r = json.load(sys.stdin)
print(base64.b64decode(r.get("message") or "").decode(errors="replace").strip() or "no message")' < "$work/result.json"))"

echo "judge0: $where"
echo "language: $language (Judge0 id $language_id)"
python3 -I -c '
import base64, json, sys
r = json.load(sys.stdin)
text = lambda field: base64.b64decode(r[field]).decode(errors="replace") if r.get(field) else ""
status = r["status"]
print("status: %s (%d)" % (status["description"], status["id"]))
for field, label in (("compile_output", "compile output"), ("stdout", "stdout"), ("stderr", "stderr")):
    print(f"{label}:")
    print(text(field).rstrip("\n") or "(none)")
' < "$work/result.json"
[[ "$status" -eq 3 ]] || exit 1
