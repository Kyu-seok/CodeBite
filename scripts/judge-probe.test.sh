#!/usr/bin/env bash
# Tests scripts/judge-probe.sh against a stub curl and a stub ssh, so no Judge0 and no server is
# reached: an accepted snippet and a compile error print the status and the compile output, a
# Judge0 that doesn't answer (or answers with an HTTP error or not JSON) exits 2 and is never
# reported as a rejection, a language CodeBite doesn't accept is refused, and production is reached
# only with --production.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir "$tmp/bin"
# STUB_JUDGE0 is how the Judge0 behaves: accepted (the default), compile-error, down (connection
# refused), http-error (a 502), not-json, internal-error (Judge0's own failure, status 13),
# no-status (a result whose status is null) or stuck (In Queue for ever). A POST answers a token; a
# GET answers the result. Every call is logged to curl.log (CURL_LOG names another), and a POST's
# body is kept in body.json.
cat > "$tmp/bin/curl" <<'STUB'
#!/usr/bin/env bash
log=$STUB_DIR/${CURL_LOG:-curl.log}
echo "$*" >> "$log"
case "${STUB_JUDGE0:-accepted}" in
  down) echo "curl: (7) Failed to connect to judge0.example port 2358: Connection refused" >&2; exit 7 ;;
  http-error) echo "curl: (22) The requested URL returned error: 502" >&2; exit 22 ;;
  not-json) echo '<html>Bad Gateway</html>'; exit 0 ;;
esac
if [[ "$*" == *"-X POST"* ]]; then
  cat > "$STUB_DIR/body.json"
  echo '{"token":"6f1c2d3e-aaaa-bbbb-cccc-0123456789ab"}'
  exit 0
fi
b64() { printf '%s' "$1" | base64 | tr -d '\n'; }
case "${STUB_JUDGE0:-accepted}" in
  no-status) echo '{"status":null,"stdout":null,"stderr":null,"compile_output":null}'; exit 0 ;;
  stuck) echo '{"status":{"id":1,"description":"In Queue"},"stdout":null,"stderr":null,"compile_output":null}'; exit 0 ;;
esac
# The first poll finds the submission still In Queue, as Judge0 usually answers.
if [[ ! -e "$STUB_DIR/polled" ]]; then
  touch "$STUB_DIR/polled"
  echo '{"status":{"id":1,"description":"In Queue"},"stdout":null,"stderr":null,"compile_output":null}'
  exit 0
fi
case "${STUB_JUDGE0:-accepted}" in
  accepted)
    printf '{"status":{"id":3,"description":"Accepted"},"stdout":"%s","stderr":null,"compile_output":"%s"}\n' \
      "$(b64 $'3\n')" "$(b64 "main.cpp:4:10: warning: structured bindings only available with '-std=c++17'")" ;;
  compile-error)
    printf '{"status":{"id":6,"description":"Compilation Error"},"stdout":null,"stderr":null,"compile_output":"%s"}\n' \
      "$(b64 "main.cpp:2:6: error: 'optional' in namespace 'std' does not name a template type")" ;;
  internal-error)
    printf '{"status":{"id":13,"description":"Internal Error"},"stdout":null,"stderr":null,"compile_output":null,"message":"%s"}\n' \
      "$(b64 "No such file or directory @ rb_sysopen - /box/script.py")" ;;
esac
STUB
chmod +x "$tmp/bin/curl"
# The production path runs curl on the server through ssh. The stub logs the call and runs its
# command under sh, as the server's shell would, with the same stub curl standing in for the
# server's (logged to server-curl.log).
mkdir "$tmp/server"
cp "$tmp/bin/curl" "$tmp/server/curl"
cat > "$tmp/bin/ssh" <<'STUB'
#!/usr/bin/env bash
echo "$*" >> "$STUB_DIR/ssh.log"
if [[ -n "${STUB_SSH_DOWN:-}" ]]; then echo "ssh: connect to host mini port 22: Operation timed out" >&2; exit 255; fi
CURL_LOG=server-curl.log PATH="$STUB_DIR/server:$PATH" exec sh -c "${*: -1}"
STUB
chmod +x "$tmp/bin/ssh"

run() { PATH="$tmp/bin:$PATH" STUB_DIR=$tmp "$here/judge-probe.sh" "$@"; }
fail() { echo "FAIL: $1" >&2; exit 1; }
reset() { rm -f "$tmp/curl.log" "$tmp/server-curl.log" "$tmp/ssh.log" "$tmp/body.json" "$tmp/polled"; }

cat > "$tmp/bind.cpp" <<'CPP'
#include <iostream>
#include <utility>
int main() {
    std::pair<int, int> p{1, 2};
    auto [a, b] = p;
    std::cout << a + b << std::endl;
}
CPP

# An accepted snippet: the status, the compile output (a warning) and stdout, exit 0.
reset
code=0
JUDGE0_URL=http://judge0.example:2358 run cpp "$tmp/bind.cpp" > "$tmp/out" 2>&1 || code=$?
[[ "$code" -eq 0 ]] || fail "an accepted snippet should exit 0, got $code: $(cat "$tmp/out")"
grep -q '^status: Accepted' "$tmp/out" || fail "should print the status: $(cat "$tmp/out")"
grep -q "warning: structured bindings only available" "$tmp/out" || fail "should print the compile output: $(cat "$tmp/out")"
grep -q '^3$' "$tmp/out" || fail "should print stdout: $(cat "$tmp/out")"
# What reached Judge0 is what CodeBite's JudgeClientImpl sends: base64 on, language id 54 for C++,
# the source and stdin base64-encoded, and nothing else (no compiler options).
grep -q -- '-X POST .*http://judge0.example:2358/submissions?base64_encoded=true' "$tmp/curl.log" \
  || fail "should POST to /submissions?base64_encoded=true: $(cat "$tmp/curl.log")"
grep -q 'http://judge0.example:2358/submissions/6f1c2d3e-aaaa-bbbb-cccc-0123456789ab?base64_encoded=true' "$tmp/curl.log" \
  || fail "should poll the token: $(cat "$tmp/curl.log")"
python3 -I - "$tmp/body.json" "$tmp/bind.cpp" <<'PY' || fail "the body is not what CodeBite sends: $(cat "$tmp/body.json")"
import base64, json, sys
body = json.load(open(sys.argv[1]))
assert sorted(body) == ["language_id", "source_code", "stdin"], body
assert body["language_id"] == 54, body
assert base64.b64decode(body["source_code"]).decode() == open(sys.argv[2]).read(), body
assert base64.b64decode(body["stdin"]).decode() == "", body
PY
[[ ! -e "$tmp/ssh.log" ]] || fail "ssh must not run without --production"

# A compile error is Judge0's verdict on the code: the status and the compile output, exit 1.
reset
code=0
STUB_JUDGE0=compile-error JUDGE0_URL=http://judge0.example:2358 run cpp "$tmp/bind.cpp" > "$tmp/out" 2>&1 || code=$?
[[ "$code" -eq 1 ]] || fail "a compile error should exit 1, got $code: $(cat "$tmp/out")"
grep -q '^status: Compilation Error' "$tmp/out" || fail "should print the compile-error status: $(cat "$tmp/out")"
grep -q "error: 'optional' in namespace 'std'" "$tmp/out" || fail "should print the compile output: $(cat "$tmp/out")"

# A Judge0 that doesn't answer, answers with an HTTP error, with something other than Judge0's JSON
# or with a result that has no status, fails inside (Internal Error) or never leaves In Queue
# (JUDGE_PROBE_WAIT is the seconds it is given, 30 by default): exit 2, one line on stderr naming
# the URL, and no status, so it never reads as a rejection.
for behaviour in down http-error not-json no-status internal-error stuck; do
  reset
  code=0
  JUDGE_PROBE_WAIT=1 STUB_JUDGE0=$behaviour JUDGE0_URL=http://judge0.example:2358 run cpp "$tmp/bind.cpp" > "$tmp/out" 2> "$tmp/err" || code=$?
  [[ "$code" -eq 2 ]] || fail "$behaviour: should exit 2, got $code: $(cat "$tmp/out" "$tmp/err")"
  grep -q '^judge-probe.sh: .*http://judge0.example:2358' "$tmp/err" || fail "$behaviour: should say which Judge0 failed: $(cat "$tmp/err")"
  [[ ! -s "$tmp/out" ]] || fail "$behaviour: should print no status: $(cat "$tmp/out")"
  [[ $(wc -l < "$tmp/err") -eq 1 ]] || fail "$behaviour: should be one line: $(cat "$tmp/err")"
done

# A language CodeBite doesn't accept (Language.ofRequest's 400) is refused before anything is sent,
# naming the ones it does; codes are case-insensitive, as Language.fromCode reads them.
reset
code=0
JUDGE0_URL=http://judge0.example:2358 run c "$tmp/bind.cpp" > "$tmp/out" 2> "$tmp/err" || code=$?
[[ "$code" -eq 2 ]] || fail "an unknown language should exit 2, got $code"
grep -q "not a language CodeBite accepts.*cpp" "$tmp/err" || fail "should name the accepted languages: $(cat "$tmp/err")"
[[ ! -e "$tmp/curl.log" ]] || fail "an unknown language must not reach Judge0"
reset
JUDGE0_URL=http://judge0.example:2358 run CPP "$tmp/bind.cpp" > /dev/null || fail "CPP should be read as cpp"
reset
JUDGE0_URL=http://judge0.example:2358 run java "$tmp/bind.cpp" > /dev/null
grep -q '"language_id": 62' "$tmp/body.json" || fail "java should be id 62: $(cat "$tmp/body.json")"

# No JUDGE0_URL and no --production: exit 2 saying what to set, nothing sent.
reset
code=0
(unset JUDGE0_URL; run cpp "$tmp/bind.cpp") > "$tmp/out" 2> "$tmp/err" || code=$?
[[ "$code" -eq 2 ]] || fail "no JUDGE0_URL should exit 2, got $code"
grep -q 'set JUDGE0_URL' "$tmp/err" || fail "should say to set JUDGE0_URL: $(cat "$tmp/err")"
[[ ! -e "$tmp/curl.log" && ! -e "$tmp/ssh.log" ]] || fail "nothing should be sent without a Judge0"

# Production's Judge0, by any name the repo knows it by (the server on the LAN, its ssh alias, the
# compose service, the public site), is refused without --production: neither curl nor ssh runs.
for url in http://192.168.219.200:2358 http://mini:2358 http://judge0:2358 https://code-bite.com HTTP://192.168.219.200:2359/; do
  reset
  code=0
  JUDGE0_URL=$url run cpp "$tmp/bind.cpp" > "$tmp/out" 2> "$tmp/err" || code=$?
  [[ "$code" -eq 2 ]] || fail "$url: production without --production should exit 2, got $code"
  grep -q -- '--production' "$tmp/err" || fail "$url: should name --production: $(cat "$tmp/err")"
  [[ ! -e "$tmp/curl.log" && ! -e "$tmp/ssh.log" ]] || fail "$url: production must not be reached without --production"
done

# --production: curl runs on the server over ssh (SSH_TARGET, default mini) against its
# localhost:2358, whatever JUDGE0_URL says; the local curl never runs.
reset
JUDGE0_URL=http://judge0.example:2358 run cpp "$tmp/bind.cpp" --production > "$tmp/out" 2>&1 \
  || fail "--production should judge through ssh: $(cat "$tmp/out")"
grep -q '^status: Accepted' "$tmp/out" || fail "--production should print the status: $(cat "$tmp/out")"
grep -q '^judge0: production' "$tmp/out" || fail "--production should say it judged on production: $(cat "$tmp/out")"
grep -q -- '-o BatchMode=yes .* mini curl ' "$tmp/ssh.log" || fail "should run curl on mini: $(cat "$tmp/ssh.log")"
grep -q -- '-X POST -H Content-Type: application/json --data-binary @- http://localhost:2358/submissions?base64_encoded=true$' "$tmp/server-curl.log" \
  || fail "should POST to the server's Judge0: $(cat "$tmp/server-curl.log")"
grep -q 'http://localhost:2358/submissions/6f1c2d3e-aaaa-bbbb-cccc-0123456789ab?base64_encoded=true$' "$tmp/server-curl.log" \
  || fail "should poll the server's Judge0: $(cat "$tmp/server-curl.log")"
grep -q '"language_id": 54' "$tmp/body.json" || fail "the body should reach the server's curl: $(cat "$tmp/body.json")"
[[ ! -e "$tmp/curl.log" ]] || fail "--production must not use the local curl or JUDGE0_URL"
reset
SSH_TARGET=prod-box run cpp "$tmp/bind.cpp" --production > /dev/null || fail "SSH_TARGET should pick the server"
grep -q ' prod-box ' "$tmp/ssh.log" || fail "should ssh to SSH_TARGET: $(cat "$tmp/ssh.log")"
reset
code=0
STUB_SSH_DOWN=1 run cpp "$tmp/bind.cpp" --production > "$tmp/out" 2> "$tmp/err" || code=$?
[[ "$code" -eq 2 ]] || fail "an unreachable server should exit 2, got $code"
grep -q '^judge-probe.sh: no answer from Judge0 .*mini' "$tmp/err" || fail "should say the server didn't answer: $(cat "$tmp/err")"

echo "judge-probe.test.sh: ok"
