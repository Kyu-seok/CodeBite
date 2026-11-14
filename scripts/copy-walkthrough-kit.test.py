"""Tests for scripts/copy-walkthrough-kit.py, on a throwaway kit repository and CodeBite root.

Run: python3 -I scripts/copy-walkthrough-kit.test.py
"""
import json, os, shutil, subprocess, sys, tempfile, unittest
from pathlib import Path

SCRIPT = Path(__file__).with_name("copy-walkthrough-kit.py")
FRONTEND = "frontend/src/components/walkthrough"
TRACE = "scripts/walkthroughs/walkthrough_trace.py"
RECORD = FRONTEND + "/KIT_VERSION.json"


def git(repo, *args):
    return subprocess.run(["git", "-C", str(repo), *args], check=True, capture_output=True, text=True).stdout.strip()


class CopyWalkthroughKit(unittest.TestCase):
    def setUp(self):
        tmp = Path(tempfile.mkdtemp(prefix="copy-walkthrough-kit-test-"))
        self.addCleanup(shutil.rmtree, tmp)
        self.kit = tmp / "kit-repo"
        self.root = tmp / "codebite"
        (self.root / "scripts/walkthroughs").mkdir(parents=True)
        (self.root / "scripts/walkthroughs/codebite.py").write_text("# CodeBite's own\n")
        git(tmp, "init", "-q", str(self.kit))
        git(self.kit, "config", "user.email", "t@example.com")
        git(self.kit, "config", "user.name", "t")
        self.kit_commit({"kit/walkthrough.js": "js 1\n", "kit/walkthrough.css": "css 1\n",
                         "kit/react/Walkthrough.tsx": "tsx 1\n", "kit/walkthrough_trace.py": "trace 1\n",
                         "SKILL.md": "not copied\n"})

    def kit_write(self, files):
        for name, text in files.items():
            path = self.kit / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(text)

    def kit_commit(self, files):
        self.kit_write(files)
        git(self.kit, "add", "-A")
        git(self.kit, "commit", "-q", "-m", "kit")
        return git(self.kit, "rev-parse", "HEAD")

    def run_script(self, *args, kit=None):
        env = dict(os.environ, WALKTHROUGH_KIT=str(kit) if kit else "")
        run = subprocess.run([sys.executable, "-I", str(SCRIPT), "--root", str(self.root), *args],
                             capture_output=True, text=True, env=env)
        return run.returncode, run.stdout + run.stderr

    def copy_in(self, *args):
        code, out = self.run_script(*args, kit=self.kit)
        self.assertEqual(code, 0, out)

    def check(self, kit=None):
        return self.run_script("--check", kit=kit)

    def read(self, name):
        return (self.root / name).read_text()

    def edit(self, name, text):
        (self.root / name).write_text(text)

    # Copying in

    def test_copies_every_kit_file_to_its_place_and_records_the_kit_commit(self):
        self.copy_in()
        self.assertEqual(self.read(FRONTEND + "/walkthrough.js"), "js 1\n")
        self.assertEqual(self.read(FRONTEND + "/react/Walkthrough.tsx"), "tsx 1\n")
        self.assertEqual(self.read(TRACE), "trace 1\n")
        self.assertFalse((self.root / FRONTEND / "walkthrough_trace.py").exists())
        self.assertFalse((self.root / FRONTEND / "SKILL.md").exists())
        self.assertEqual(self.read("scripts/walkthroughs/codebite.py"), "# CodeBite's own\n")
        record = json.loads(self.read(RECORD))
        self.assertEqual(record["kit_commit"], git(self.kit, "rev-parse", "HEAD"))
        self.assertEqual(record["files"][TRACE]["from"], "kit/walkthrough_trace.py")
        self.assertEqual(record["files"][TRACE]["blob"], git(self.kit, "rev-parse", "HEAD:kit/walkthrough_trace.py"))

    def test_a_new_kit_file_is_copied_and_a_removed_one_deleted(self):
        self.copy_in()
        git(self.kit, "rm", "-q", "kit/walkthrough.css")
        self.kit_commit({"kit/addresses.json": "{}\n"})
        self.copy_in()
        self.assertEqual(self.read(FRONTEND + "/addresses.json"), "{}\n")
        self.assertFalse((self.root / FRONTEND / "walkthrough.css").exists())
        self.assertEqual(self.check(), (0, ""))

    def test_copies_a_given_ref_rather_than_the_kit_head(self):
        first = git(self.kit, "rev-parse", "HEAD")
        self.kit_commit({"kit/walkthrough.js": "js 2\n"})
        self.copy_in("--ref", first[:7])
        self.assertEqual(self.read(FRONTEND + "/walkthrough.js"), "js 1\n")
        self.assertEqual(json.loads(self.read(RECORD))["kit_commit"], first)

    def test_refuses_a_kit_with_uncommitted_changes_and_writes_nothing(self):
        self.kit_write({"kit/walkthrough.js": "js uncommitted\n"})
        code, out = self.run_script(kit=self.kit)
        self.assertEqual(code, 1)
        self.assertIn("uncommitted", out)
        self.assertFalse((self.root / FRONTEND).exists())

    def test_refuses_a_path_that_is_not_a_kit(self):
        code, out = self.run_script(kit=self.root)
        self.assertEqual(code, 1)
        self.assertIn("not a walkthrough kit", out)

    # The check, without the kit (CI)

    def test_a_fresh_copy_passes(self):
        self.copy_in()
        self.assertEqual(self.check(), (0, ""))

    def test_a_hand_edited_player_file_fails(self):
        self.copy_in()
        self.edit(FRONTEND + "/react/Walkthrough.tsx", "tsx edited\n")
        code, out = self.check()
        self.assertEqual(code, 1)
        self.assertIn(FRONTEND + "/react/Walkthrough.tsx", out)

    def test_a_hand_edited_recorder_fails(self):
        self.copy_in()
        self.edit(TRACE, "trace edited\n")
        code, out = self.check()
        self.assertEqual(code, 1)
        self.assertIn(TRACE, out)

    def test_a_deleted_copied_file_fails(self):
        self.copy_in()
        (self.root / FRONTEND / "walkthrough.css").unlink()
        code, out = self.check()
        self.assertEqual(code, 1)
        self.assertIn(FRONTEND + "/walkthrough.css", out)

    def test_a_file_added_beside_the_copy_fails(self):
        self.copy_in()
        self.edit(FRONTEND + "/helper.ts", "export {}\n")
        code, out = self.check()
        self.assertEqual(code, 1)
        self.assertIn(FRONTEND + "/helper.ts", out)

    def test_a_missing_record_fails(self):
        self.copy_in()
        (self.root / RECORD).unlink()
        code, out = self.check()
        self.assertEqual(code, 1)
        self.assertIn(RECORD, out)

    # The check, with the kit (pre-commit on a machine that has it)

    def test_a_record_naming_a_commit_that_holds_other_files_fails(self):
        self.copy_in()
        later = self.kit_commit({"kit/walkthrough.js": "js 2\n"})
        record = json.loads(self.read(RECORD))
        record["kit_commit"] = later
        self.edit(RECORD, json.dumps(record))
        self.assertEqual(self.check()[0], 0)
        code, out = self.check(kit=self.kit)
        self.assertEqual(code, 1)
        self.assertIn(FRONTEND + "/walkthrough.js", out)

    def test_a_kit_that_moved_on_is_noted_but_passes(self):
        self.copy_in()
        self.kit_commit({"kit/walkthrough.js": "js 2\n"})
        code, out = self.check(kit=self.kit)
        self.assertEqual(code, 0)
        self.assertIn("kit/walkthrough.js", out)

    def test_a_kit_that_moved_on_outside_kit_is_silent(self):
        self.copy_in()
        self.kit_commit({"SKILL.md": "changed\n"})
        self.assertEqual(self.check(kit=self.kit), (0, ""))


if __name__ == "__main__":
    unittest.main()
