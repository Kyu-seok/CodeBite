"""Tests for scripts/check-doc-references.py, on a throwaway repository.

Run: python3 -I scripts/check-doc-references.test.py
"""
import importlib.util, shutil, subprocess, sys, tempfile, unittest
from pathlib import Path

SCRIPT = Path(__file__).with_name("check-doc-references.py")
spec = importlib.util.spec_from_file_location("check_doc_references", SCRIPT)
checker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checker)
CEILING = checker.CLAUDE_MD_CEILING

GLOSSARY = """# Glossary

### Problems

**Slug**:
A problem's name in its URL.

**Problem Report**:
A user's report that something in a problem is wrong.
"""


class CheckDocReferences(unittest.TestCase):
    def setUp(self):
        self.root = Path(tempfile.mkdtemp(prefix="check-doc-references-test-"))
        self.addCleanup(shutil.rmtree, self.root)
        subprocess.run(["git", "init", "-q", str(self.root)], check=True)
        self.write("GLOSSARY.md", GLOSSARY)
        self.write(".gitignore", "infra/.env\n")
        self.write("scripts/judge-local.sh", "")
        self.write("common/src/main/java/com/codebite/common/time/DayRuns.java", "")

    def write(self, name, text):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text)

    def check(self):
        run = subprocess.run([sys.executable, "-I", str(SCRIPT), str(self.root)], capture_output=True, text=True)
        return run.returncode, run.stdout

    def test_paths_and_terms_that_exist_pass(self):
        self.write("CLAUDE.md", "Run `scripts/judge-local.sh`; the package `common/time/` holds DayRuns; "
                   "secrets in `infra/.env`. A Slug (GLOSSARY.md), Problem Reports "
                   "(GLOSSARY.md), the Problems (GLOSSARY.md) section.\n")
        self.assertEqual(self.check(), (0, ""))

    def test_an_ignored_folder_passes_on_a_clean_checkout(self):
        # CI's checkout has no build output, and git matches a folder-only rule (`build/`) to a
        # missing path only when it ends in a slash: #263 passed locally and failed on CI.
        self.write(".gitignore", "infra/.env\nbuild/\n")
        self.write("CLAUDE.md", "Two builds corrupt `backend/build` and `frontend/build/`.\n")
        self.assertEqual(self.check(), (0, ""))

    def test_a_missing_path_fails_with_its_line(self):
        self.write("docs/agents/triage.md", "ok\nRoute to `.claude/skills/correct-test-cases/SKILL.md`.\n")
        code, out = self.check()
        self.assertEqual(code, 1)
        self.assertIn("docs/agents/triage.md:2: `.claude/skills/correct-test-cases/SKILL.md` does not exist", out)

    def test_a_term_missing_from_the_glossary_fails_in_docs_and_source(self):
        self.write(".claude/skills/x/SKILL.md", "The **Guarantee** (GLOSSARY.md) proves it.\n")
        self.write("frontend/src/report.ts", "/** A Bug Report (GLOSSARY.md). */\n")
        code, out = self.check()
        self.assertEqual(code, 1)
        self.assertIn('.claude/skills/x/SKILL.md:1: "Guarantee" is not a GLOSSARY.md entry', out)
        self.assertIn('frontend/src/report.ts:1: "Bug Report" is not a GLOSSARY.md entry', out)

    def test_placeholders_fences_and_adr_paths_are_skipped(self):
        self.write("CLAUDE.md", "`scripts/replay-solutions/<slug>.py`, `drivers/{slug}/`, "
                   "`backend/src/test/.../guarantee/`\n```\nscripts/gone.sh\n`scripts/gone.sh`\n```\n")
        self.write("docs/adr/0001-x.md", "A spike (`scripts/prototype-spike/`) confirmed it.\n")
        self.assertEqual(self.check(), (0, ""))

    def test_a_paragraph_inside_a_table_fails_with_its_line(self):
        self.write("CLAUDE.md", "| Path | Page |\n|---|---|\n| `/a` | A |\n"
                   "A paragraph pasted into the table.\n| `/b` | B |\n")
        code, out = self.check()
        self.assertEqual(code, 1)
        self.assertIn("CLAUDE.md:4: splits a table", out)

    def test_a_table_followed_by_a_blank_line_and_a_paragraph_passes(self):
        self.write("CLAUDE.md", "| Path | Page |\n|---|---|\n| `/a` | A |\n\nA paragraph after it.\n"
                   "| not a table row on its own |\n\n```\n| a | fenced |\ntext\n| b | table |\n```\n")
        self.assertEqual(self.check(), (0, ""))

    def test_a_claude_md_over_the_byte_ceiling_fails_and_says_why(self):
        self.write("CLAUDE.md", "x" * CEILING + "\n")
        code, out = self.check()
        self.assertEqual(code, 1)
        self.assertIn(f"CLAUDE.md: {CEILING + 1} bytes is over the {CEILING}-byte ceiling", out)
        self.assertIn("loads on every turn", out)
        self.assertIn("CLAUDE_MD_CEILING", out)

    def test_a_claude_md_at_the_ceiling_passes(self):
        self.write("CLAUDE.md", "x" * (CEILING - 1) + "\n")
        self.assertEqual(self.check(), (0, ""))


if __name__ == "__main__":
    unittest.main()
