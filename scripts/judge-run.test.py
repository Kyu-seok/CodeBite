"""Tests for scripts/judge-run.py, against a stub backend on a free local port and a temporary
repository root holding the reference solutions and a fake scripts/dev-branch-servers.sh.

Run: python3 -I scripts/judge-run.test.py
"""
import json, os, shutil, socket, subprocess, sys, tempfile, threading, time, unittest
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

SCRIPT = Path(__file__).with_name("judge-run.py")
SPACING = 0.3  # JUDGE_RUN_SPACING for the test of the spacing, in place of 5.5 s; the others wait 0


def accepted():
    return 200, {"overallStatus": "ACCEPTED", "results": [
        {"status": "ACCEPTED", "judged": True, "isCustom": False, "compileOutput": None, "stderr": None}]}


def wrong_on_second():
    return 200, {"overallStatus": "WRONG_ANSWER", "results": [
        {"status": "ACCEPTED", "judged": True, "isCustom": False},
        {"status": "WRONG_ANSWER", "judged": True, "isCustom": False, "expectedOutput": "7", "actualOutput": "8"}]}


def compile_error():
    return 200, {"overallStatus": "COMPILATION_ERROR", "results": [
        {"status": "COMPILATION_ERROR", "judged": True, "isCustom": False,
         "compileOutput": "Main.java:3: error: cannot find symbol\n  symbol: Foo\n1 error"}]}


class Stub:
    """A backend: Run answers come from `runs` (a function of the language, or a list consumed in
    order), problem details from `problems`; every request is logged with the time it arrived, and
    its User-Agent in `agents`. An answer whose body is bytes is sent as it is, not as JSON."""

    def __init__(self):
        self.runs = lambda language: accepted()
        self.problems = {}
        self.log = []
        self.agents = []
        stub = self

        class Handler(BaseHTTPRequestHandler):
            def log_message(self, *args):
                pass

            def answer(self, status, body):
                raw = isinstance(body, bytes)
                data = body if raw else json.dumps(body).encode()
                self.send_response(status)
                self.send_header("Content-Type", "text/html" if raw else "application/json")
                self.send_header("Content-Length", str(len(data)))
                self.end_headers()
                self.wfile.write(data)

            def do_POST(self):
                body = json.loads(self.rfile.read(int(self.headers["Content-Length"])))
                stub.log.append((time.monotonic(), "POST", self.path, body))
                stub.agents.append(self.headers["User-Agent"])
                if isinstance(stub.runs, list):
                    self.answer(*stub.runs.pop(0))
                else:
                    self.answer(*stub.runs(body["language"]))

            def do_GET(self):
                stub.log.append((time.monotonic(), "GET", self.path, None))
                stub.agents.append(self.headers["User-Agent"])
                slug = self.path.rsplit("/", 1)[-1]
                if slug in stub.problems:
                    self.answer(200, {"slug": stub.problems[slug], "title": "Piggy Bank Total"})
                else:
                    self.answer(404, {"status": 404, "message": f"Problem not found: {slug}"})

        self.server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
        self.url = f"http://127.0.0.1:{self.server.server_address[1]}/api"
        # shutdown() returns at serve_forever's next poll: the default 0.5 s was half of every test.
        threading.Thread(target=self.server.serve_forever, kwargs={"poll_interval": 0.01}, daemon=True).start()

    def close(self):
        self.server.shutdown()
        self.server.server_close()

    def posts(self):
        return [entry for entry in self.log if entry[1] == "POST"]


def free_port():
    with socket.socket() as s:
        s.bind(("127.0.0.1", 0))
        return s.getsockname()[1]


class JudgeRun(unittest.TestCase):
    def setUp(self):
        self.root = Path(tempfile.mkdtemp(prefix="judge-run-test-"))
        self.addCleanup(shutil.rmtree, self.root)
        (self.root / "scripts/replay-solutions").mkdir(parents=True)
        self.solutions("piggy-bank-total", "py", "java", "js", "cpp")
        self.stub = Stub()
        self.addCleanup(self.stub.close)

    def solutions(self, slug, *extensions):
        for ext in extensions:
            (self.root / f"scripts/replay-solutions/{slug}.{ext}").write_text(f"// {slug} in {ext}\n")

    def servers_status(self, text):
        script = self.root / "scripts/dev-branch-servers.sh"
        script.write_text(f"#!/usr/bin/env bash\n[[ $1 == status ]] || exit 9\ncat <<'EOS'\n{text}\nEOS\n")
        script.chmod(0o755)

    def run_script(self, *args, backend=True, **env):
        argv = [sys.executable, "-I", str(SCRIPT), str(self.root), *args]
        if backend:
            argv += ["--backend", self.stub.url]
        env = {**os.environ, "JUDGE_RUN_SPACING": "0", **env}
        done = subprocess.run(argv, capture_output=True, text=True, env=env, timeout=60)
        return done.returncode, done.stdout + done.stderr

    # --- verdicts ------------------------------------------------------------------------------

    def test_every_language_accepted_exits_0(self):
        code, out = self.run_script("piggy-bank-total")
        self.assertEqual(code, 0, out)
        for language in ("python", "java", "javascript", "cpp"):
            self.assertRegex(out, rf"{language} +ACCEPTED")
        sent = [(path, body["language"]) for _, _, path, body in self.stub.posts()]
        self.assertEqual(sent, [("/api/problems/piggy-bank-total/run", language)
                                for language in ("python", "java", "javascript", "cpp")])

    def test_the_reference_solution_is_the_source_code(self):
        self.run_script("piggy-bank-total", "--languages", "java")
        (_, _, _, body), = self.stub.posts()
        self.assertEqual(body, {"language": "java", "sourceCode": "// piggy-bank-total in java\n"})

    def test_another_verdict_exits_1_and_names_the_case(self):
        self.stub.runs = lambda language: wrong_on_second() if language == "java" else accepted()
        code, out = self.run_script("piggy-bank-total")
        self.assertEqual(code, 1, out)
        self.assertRegex(out, r"java +WRONG_ANSWER on sample 2")
        self.assertRegex(out, r"cpp +ACCEPTED")

    def test_a_compile_error_shows_the_compiler_output(self):
        self.stub.runs = lambda language: compile_error()
        code, out = self.run_script("piggy-bank-total", "--languages", "java")
        self.assertEqual(code, 1, out)
        self.assertRegex(out, r"java +COMPILATION_ERROR on sample 1")
        self.assertIn("cannot find symbol", out)

    def test_an_http_error_is_a_failure_with_its_message(self):
        self.stub.runs = lambda language: (400, {"status": 400, "message": "No driver for cpp"})
        code, out = self.run_script("piggy-bank-total", "--languages", "cpp")
        self.assertEqual(code, 1, out)
        self.assertRegex(out, r"cpp +HTTP 400: No driver for cpp")

    def test_a_language_without_a_reference_solution_is_not_judged_and_leaves_the_exit_code(self):
        self.solutions("only-python", "py")
        code, out = self.run_script("only-python")
        self.assertEqual(code, 0, out)
        self.assertRegex(out, r"python +ACCEPTED")
        for language in ("java", "javascript", "cpp"):
            self.assertRegex(out, rf"{language} +NOT JUDGED: no reference solution")
        self.assertEqual([body["language"] for _, _, _, body in self.stub.posts()], ["python"])

    def test_a_problem_with_no_judged_language_fails(self):
        self.solutions("only-python", "py")
        code, out = self.run_script("only-python", "--languages", "java,cpp")
        self.assertEqual(code, 1, out)
        self.assertIn("no Language judged", out)
        self.assertEqual(self.stub.posts(), [])

    def test_a_language_not_judged_does_not_hide_another_failure(self):
        self.solutions("only-java", "java")
        self.stub.runs = lambda language: compile_error()
        code, out = self.run_script("only-java")
        self.assertEqual(code, 1, out)
        self.assertRegex(out, r"python +NOT JUDGED")

    def test_languages_picks_the_languages(self):
        code, out = self.run_script("piggy-bank-total", "--languages", "python,cpp")
        self.assertEqual(code, 0, out)
        self.assertEqual([body["language"] for _, _, _, body in self.stub.posts()], ["python", "cpp"])
        self.assertNotIn("java", out)

    def test_an_unknown_language_is_a_usage_error(self):
        code, out = self.run_script("piggy-bank-total", "--languages", "rust")
        self.assertEqual(code, 2, out)
        self.assertIn("unknown language rust", out)
        self.assertEqual(self.stub.log, [])

    def test_several_slugs_each_run(self):
        self.solutions("other-problem", "py")
        code, out = self.run_script("piggy-bank-total", "other-problem", "--languages", "python")
        self.assertEqual(code, 0, out)
        self.assertEqual([path for _, _, path, _ in self.stub.posts()],
                         ["/api/problems/piggy-bank-total/run", "/api/problems/other-problem/run"])

    def test_a_problem_the_backend_lacks_says_to_restart(self):
        self.stub.runs = lambda language: (404, {"status": 404, "message": "Problem not found: piggy-bank-total"})
        code, out = self.run_script("piggy-bank-total")
        self.assertEqual(code, 2, out)
        self.assertIn("restart", out)
        self.assertEqual(len(self.stub.posts()), 1, "one 404 is enough to know the problem is missing")

    def test_a_missing_problem_outranks_an_earlier_failure(self):
        self.solutions("other-problem", "py")
        self.stub.runs = lambda language: (wrong_on_second() if language == "python"
                                           else (404, {"status": 404, "message": "Problem not found"}))
        code, out = self.run_script("other-problem", "piggy-bank-total", "--languages", "python,java")
        self.assertEqual(code, 2, out)
        self.assertRegex(out, r"python +WRONG_ANSWER")

    def test_a_failure_after_a_missing_problem_still_exits_2(self):
        self.solutions("other-problem", "py")
        self.stub.runs = [(404, {"status": 404, "message": "Problem not found"}), wrong_on_second()]
        code, out = self.run_script("piggy-bank-total", "other-problem", "--languages", "python")
        self.assertEqual(code, 2, out)

    # --- the client and the proxy in front of the backend ------------------------------------------

    def test_every_request_names_this_client_not_python_urllib(self):
        self.stub.problems = {"old-piggy": "piggy-bank-total"}
        self.run_script("piggy-bank-total", "--former", "old-piggy", "--languages", "python")
        self.assertEqual(self.stub.agents, ["codebite-judge-run", "codebite-judge-run"])

    def test_a_403_without_a_json_body_is_the_proxy_refusing_this_client(self):
        cloudflare_page = b"<!DOCTYPE html><title>Attention Required! | Cloudflare</title>"
        for body in (b"", cloudflare_page, b"[]"):
            with self.subTest(body=body[:20]):
                self.stub.log.clear()
                self.stub.runs = lambda language: (403, body)
                code, out = self.run_script("piggy-bank-total", "--languages", "java,python")
                self.assertEqual(code, 2, out)
                self.assertIn("a proxy in front of the backend refused this client", out)
                self.assertIn("codebite-judge-run", out)
                self.assertNotIn("HTTP 403:", out)
                self.assertEqual(len(self.stub.posts()), 1, "the proxy refuses every later Run too")

    def test_a_403_with_a_json_body_is_the_backends_answer(self):
        self.stub.runs = lambda language: (403, {"status": 403, "message": "Access denied"})
        code, out = self.run_script("piggy-bank-total", "--languages", "java")
        self.assertEqual(code, 1, out)
        self.assertRegex(out, r"java +HTTP 403: Access denied")
        self.assertNotIn("proxy", out)

    # --- the Run cooldown ------------------------------------------------------------------------

    def test_runs_are_spaced_past_the_cooldown(self):
        self.run_script("piggy-bank-total", JUDGE_RUN_SPACING=str(SPACING))
        times = [t for t, *_ in self.stub.posts()]
        gaps = [b - a for a, b in zip(times, times[1:])]
        self.assertEqual(len(gaps), 3)
        self.assertTrue(all(gap >= SPACING * 0.95 for gap in gaps), gaps)

    def test_a_429_is_waited_out_and_never_a_failure(self):
        too_many = (429, {"status": 429, "message": "Too many requests"})
        self.stub.runs = [too_many, too_many, accepted()]
        code, out = self.run_script("piggy-bank-total", "--languages", "python")
        self.assertEqual(code, 0, out)
        self.assertRegex(out, r"python +ACCEPTED")
        self.assertNotIn("429:", out.split("python")[-1].split("\n")[0])
        self.assertEqual(len(self.stub.posts()), 3)

    def test_a_429_that_never_ends_gives_up_unreachable(self):
        self.stub.runs = lambda language: (429, {"status": 429, "message": "Too many requests"})
        code, out = self.run_script("piggy-bank-total", "--languages", "python", JUDGE_RUN_MAX_WAITS="2")
        self.assertEqual(code, 2, out)
        self.assertIn("429", out)

    # --- an unreachable backend ------------------------------------------------------------------

    def test_a_refused_connection_says_the_servers_are_down(self):
        dead = f"http://127.0.0.1:{free_port()}/api"
        code, out = self.run_script("piggy-bank-total", "--backend", dead, backend=False)
        self.assertEqual(code, 2, out)
        self.assertIn("down", out)
        self.assertIn("scripts/dev-branch-servers.sh restart", out)
        self.assertNotIn("Traceback", out)

    # --- the default backend ---------------------------------------------------------------------

    def test_the_backend_defaults_to_the_branch_servers(self):
        port = self.stub.url.split(":")[-1].split("/")[0]
        self.servers_status(f"""
Branch servers for t1:
  frontend  http://127.0.0.1:9999          (open this, not localhost: separate sign-in)
  backend   http://127.0.0.1:{port}/api
  worker    http://127.0.0.1:9998/actuator/health""")
        code, out = self.run_script("piggy-bank-total", "--languages", "python", backend=False)
        self.assertEqual(code, 0, out)
        self.assertEqual(len(self.stub.posts()), 1)

    def test_branch_servers_not_running_says_to_start_them(self):
        self.servers_status("not running (codebite_t1_abc)")
        code, out = self.run_script("piggy-bank-total", backend=False)
        self.assertEqual(code, 2, out)
        self.assertIn("dev-branch-servers.sh start --detach", out)

    def test_a_backend_without_api_is_the_same_backend(self):
        code, out = self.run_script("piggy-bank-total", "--languages", "python",
                                    "--backend", self.stub.url.removesuffix("/api"), backend=False)
        self.assertEqual(code, 0, out)
        self.assertEqual(self.stub.posts()[0][2], "/api/problems/piggy-bank-total/run")

    # --- Former Slugs ----------------------------------------------------------------------------

    def test_former_resolving_to_the_slug_passes(self):
        self.stub.problems = {"old-piggy": "piggy-bank-total"}
        code, out = self.run_script("piggy-bank-total", "--former", "old-piggy", "--languages", "python")
        self.assertEqual(code, 0, out)
        self.assertRegex(out, r"old-piggy +resolves to piggy-bank-total")
        self.assertIn((("GET", "/api/problems/old-piggy")), [(m, p) for _, m, p, _ in self.stub.log])

    def test_former_resolving_elsewhere_fails(self):
        self.stub.problems = {"old-piggy": "some-other-problem"}
        code, out = self.run_script("piggy-bank-total", "--former", "old-piggy", "--languages", "python")
        self.assertEqual(code, 1, out)
        self.assertRegex(out, r"old-piggy +resolves to some-other-problem, not piggy-bank-total")

    def test_former_not_found_fails(self):
        code, out = self.run_script("piggy-bank-total", "--former", "old-piggy", "--languages", "python")
        self.assertEqual(code, 1, out)
        self.assertRegex(out, r"old-piggy +HTTP 404")

    def test_former_belongs_to_the_slug_before_it(self):
        self.solutions("other-problem", "py")
        self.stub.problems = {"old-a": "piggy-bank-total", "old-b": "other-problem"}
        code, out = self.run_script("piggy-bank-total", "--former", "old-a", "other-problem", "--former", "old-b",
                                    "--languages", "python")
        self.assertEqual(code, 0, out)
        self.assertRegex(out, r"old-a +resolves to piggy-bank-total")
        self.assertRegex(out, r"old-b +resolves to other-problem")

    def test_the_shell_entry_point_passes_the_repository_root(self):
        done = subprocess.run([str(SCRIPT.with_suffix(".sh"))], capture_output=True, text=True, timeout=30)
        self.assertEqual(done.returncode, 2)
        self.assertIn("usage: scripts/judge-run.sh <slug>", done.stderr)

    def test_former_before_any_slug_is_a_usage_error(self):
        code, out = self.run_script("--former", "old-a", "piggy-bank-total")
        self.assertEqual(code, 2, out)
        self.assertIn("usage", out)


if __name__ == "__main__":
    unittest.main()
