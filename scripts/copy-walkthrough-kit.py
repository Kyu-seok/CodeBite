#!/usr/bin/env python3
"""Copies the walkthrough kit into CodeBite, or checks that the copy is still what it recorded.

  scripts/copy-walkthrough-kit.py [--kit <kit repo>] [--ref <commit>]
  scripts/copy-walkthrough-kit.py --check [--kit <kit repo>]

CodeBite carries the kit's kit/ directory verbatim (docs/adr/0012). Copying in writes every file
under kit/ at the commit (HEAD unless --ref; HEAD must have no uncommitted kit/ changes) to the
place COPY_RULES gives it, deletes a file the last copy wrote that the kit no longer has, and
records the kit commit and each file's git blob id in KIT_VERSION.json beside the player.

--check fails (exit 1) when a copied file differs from its recorded blob, is missing, or a file the
copy didn't write sits beside the player: an edit made here instead of in the kit. When the kit is
on this machine it also fails when the recorded commit doesn't hold those blobs, and notes (without
failing) a kit HEAD whose kit/ has moved on. Without the kit (CI) it checks the record alone.
The pre-commit hook and CI's scripts-check run it.

The kit is --kit, else $WALKTHROUGH_KIT, else walkthrough-skill beside the main checkout.
"""
import argparse, hashlib, json, os, subprocess, sys
from pathlib import Path

# Where each kit file goes, first match wins: a kit path, or a directory prefix ending in "/".
# A new kit file lands under the player by the last rule; one the tracers read (as
# walkthrough_trace.py is) needs its own line above it.
COPY_RULES = [
    ("kit/walkthrough_trace.py", "scripts/walkthroughs/walkthrough_trace.py"),
    ("kit/", "frontend/src/components/walkthrough/"),
]
PLAYER_DIR = "frontend/src/components/walkthrough"
RECORD = PLAYER_DIR + "/KIT_VERSION.json"
RECORD_NOTE = "Written by scripts/copy-walkthrough-kit.py; never edit by hand. Blobs are git blob ids."


class Refusal(Exception):
    pass


def destination(kit_path):
    for source, dest in COPY_RULES:
        if source.endswith("/") and kit_path.startswith(source):
            return dest + kit_path[len(source):]
        if kit_path == source:
            return dest
    raise Refusal(f"no rule in COPY_RULES places {kit_path}")


def blob_id(data):
    return hashlib.sha1(b"blob %d\0" % len(data) + data).hexdigest()


def git(repo, *args, binary=False):
    run = subprocess.run(["git", "-C", str(repo), *args], capture_output=True)
    if run.returncode:
        raise Refusal(f"git {' '.join(args)} in {repo}: {run.stderr.decode().strip()}")
    return run.stdout if binary else run.stdout.decode().strip()


def kit_tree(kit, commit):
    """{kit path: blob id} for every file under kit/ at commit."""
    tree = {}
    for line in git(kit, "ls-tree", "-r", commit, "--", "kit/").splitlines():
        meta, path = line.split("\t", 1)
        tree[path] = meta.split()[2]
    return tree


def find_kit(given, root):
    if given:
        return Path(given)
    if os.environ.get("WALKTHROUGH_KIT"):
        return Path(os.environ["WALKTHROUGH_KIT"])
    run = subprocess.run(["git", "-C", str(root), "rev-parse", "--path-format=absolute", "--git-common-dir"],
                         capture_output=True, text=True)
    if run.returncode == 0:
        sibling = Path(run.stdout.strip()).parent.parent / "walkthrough-skill"
        if (sibling / "kit").is_dir():
            return sibling
    return None


def require_kit(kit):
    if kit is None:
        raise Refusal("no kit found: pass --kit <walkthrough-skill checkout> or set WALKTHROUGH_KIT")
    if not (kit / "kit").is_dir() or subprocess.run(["git", "-C", str(kit), "rev-parse"],
                                                    capture_output=True).returncode:
        raise Refusal(f"{kit} is not a walkthrough kit (a git checkout with a kit/ directory)")


def read_record(root):
    path = root / RECORD
    if not path.exists():
        return None
    return json.loads(path.read_text())


def copy_in(root, kit, ref):
    require_kit(kit)
    if ref is None:
        dirty = git(kit, "status", "--porcelain", "--", "kit/")
        if dirty:
            raise Refusal(f"the kit has uncommitted changes under kit/; commit them first:\n{dirty}")
    commit = git(kit, "rev-parse", "--verify", (ref or "HEAD") + "^{commit}")
    tree = kit_tree(kit, commit)
    if not tree:
        raise Refusal(f"{kit} has no files under kit/ at {commit}")
    files = {destination(path): {"from": path, "blob": blob} for path, blob in sorted(tree.items())}
    contents = {dest: git(kit, "cat-file", "blob", f["blob"], binary=True) for dest, f in files.items()}

    previous = read_record(root) or {"files": {}}
    for dest in previous["files"]:
        if dest not in files and (root / dest).exists():
            (root / dest).unlink()
    for dest, data in contents.items():
        (root / dest).parent.mkdir(parents=True, exist_ok=True)
        (root / dest).write_bytes(data)
    record = {"note": RECORD_NOTE, "kit_commit": commit, "files": files}
    (root / RECORD).write_text(json.dumps(record, indent=2) + "\n")
    print(f"copied {len(files)} kit files at {commit[:7]}; recorded in {RECORD}")


def check(root, kit):
    """Returns (problems, notes)."""
    record = read_record(root)
    if record is None:
        return [f"{RECORD} is missing: copy the kit in with scripts/copy-walkthrough-kit.py"], []
    problems, notes = [], []
    files = record["files"]
    for dest, f in sorted(files.items()):
        path = root / dest
        if not path.exists():
            problems.append(f"{dest}: missing")
        elif blob_id(path.read_bytes()) != f["blob"]:
            problems.append(f"{dest}: differs from {f['from']} at kit {record['kit_commit'][:7]}")
        if destination(f["from"]) != dest:
            problems.append(f"{dest}: COPY_RULES now place {f['from']} at {destination(f['from'])}")
    for path in sorted((root / PLAYER_DIR).rglob("*")):
        rel = path.relative_to(root).as_posix()
        if path.is_file() and rel != RECORD and rel not in files:
            problems.append(f"{rel}: not from the kit")

    if kit is not None and (kit / "kit").is_dir():
        recorded = {f["from"]: f["blob"] for f in files.values()}
        try:
            at_commit = kit_tree(kit, record["kit_commit"])
        except Refusal:
            notes.append(f"the kit at {kit} lacks commit {record['kit_commit'][:7]}; checked the record alone")
        else:
            for path in sorted(set(at_commit) | set(recorded)):
                if at_commit.get(path) != recorded.get(path):
                    where = destination(path)
                    problems.append(f"{where}: the record's kit {record['kit_commit'][:7]} holds another {path}")
            if not problems:
                head = kit_tree(kit, "HEAD")
                moved = sorted(p for p in set(head) | set(recorded) if head.get(p) != recorded.get(p))
                if moved:
                    notes.append(f"note: the kit's HEAD ({kit}) has changed {', '.join(moved)} since "
                                 f"{record['kit_commit'][:7]}; copy in with scripts/copy-walkthrough-kit.py")
    if problems:
        problems.append("The copy changes only through the kit: change it there, commit, and run "
                        "scripts/copy-walkthrough-kit.py (docs/adr/0012).")
    return problems, notes


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--check", action="store_true", help="check the copy against its record")
    parser.add_argument("--kit", help="the walkthrough-skill checkout")
    parser.add_argument("--ref", help="the kit commit to copy (default HEAD)")
    parser.add_argument("--root", default=str(Path(__file__).resolve().parents[1]), help=argparse.SUPPRESS)
    args = parser.parse_args()
    root = Path(args.root)
    kit = find_kit(args.kit, root)
    try:
        if args.check:
            problems, notes = check(root, kit)
            for line in notes:
                print(line, file=sys.stderr)
            if problems:
                print("copy-walkthrough-kit: the kit copy has drifted:", file=sys.stderr)
                for line in problems:
                    print(f"  {line}", file=sys.stderr)
                return 1
            return 0
        copy_in(root, kit, args.ref)
        return 0
    except Refusal as refusal:
        print(f"copy-walkthrough-kit: {refusal}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
