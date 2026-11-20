#!/usr/bin/env python3
"""Fails when two files in scripts/walkthroughs/ define the same top-level function.

A helper a second tracer needs belongs in codebite.py, imported by both: #364's tracers carried up
to seven copies each of ordinal, listed, centre_text and node_order, found only by review.

The same function is the same name, parameters (defaults too) and statements, compared as
ast.dump gives them, so layout and comments don't count, and neither does a docstring: a copy
with its docstring dropped or reworded is still a copy. A local helper may share a name with
another tracer's (show, tag, solve) as long as it does something else. Methods and nested
functions are not compared.

    scripts/check-tracer-helpers.py [tracer directory]

Exits 1 and prints one COPY line per function, naming the files that define it; exits 2 when a
file doesn't parse. Tracers are Python 3.12 (a quote nested in an f-string), so an older python3
hands over to $CODEBITE_PYTHON312 or python3.12, whichever is first a 3.12 or newer.
"""
import ast
import os
import shutil
import subprocess
import sys
from collections import defaultdict
from pathlib import Path

SHARED = "codebite.py"


def stop(message):
    print(f"check-tracer-helpers: {message}", file=sys.stderr)
    sys.exit(2)


def same_function_key(node):
    body = node.body
    if isinstance(body[0], ast.Expr) and isinstance(getattr(body[0].value, "value", None), str):
        body = body[1:]
    return node.name, ast.dump(node.args), "".join(ast.dump(statement) for statement in body)


def copies(directory):
    """[(name, [file names])] for every top-level function two or more files define, by name."""
    found = defaultdict(list)
    for path in sorted(directory.glob("*.py")):
        try:
            tree = ast.parse(path.read_text(encoding="utf-8"))
        except SyntaxError as error:
            stop(f"{path.name}:{error.lineno}: does not parse: {error.msg}")
        for node in tree.body:
            if isinstance(node, ast.FunctionDef) and path.name not in found[same_function_key(node)]:
                found[same_function_key(node)].append(path.name)
    return sorted((key[0], names) for key, names in found.items() if len(names) > 1)


def python_312():
    """A Python 3.12 or newer to hand over to, each candidate asked its version as judge-local.py's
    python_tool does: an older or missing one named by CODEBITE_PYTHON312 would hand over forever."""
    for candidate in (os.environ.get("CODEBITE_PYTHON312"), "python3.12"):
        path = candidate and shutil.which(candidate)
        if not path:
            continue
        try:
            newer = subprocess.run([path, "-c", "import sys; print(sys.version_info >= (3, 12))"],
                                   capture_output=True, text=True, timeout=30).stdout.strip()
        except (OSError, subprocess.TimeoutExpired):
            continue
        if newer == "True":
            return path
    stop("tracers are Python 3.12 and none was found (install python3.12, or set CODEBITE_PYTHON312)")


def joined(names):
    return names[0] if len(names) == 1 else f"{', '.join(names[:-1])} and {names[-1]}"


def main():
    if sys.version_info < (3, 12):
        python = python_312()
        os.execv(python, [python, "-I", os.path.abspath(__file__), *sys.argv[1:]])
    directory = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parent / "walkthroughs"
    found = copies(directory)
    for name, names in found:
        if SHARED in names:
            tracers = [n for n in names if n != SHARED]
            print(f"  COPY  {name}: {joined(tracers)} {'defines' if len(tracers) == 1 else 'define'} "
                  f"a function {SHARED} has; import it from there")
        else:
            print(f"  COPY  {name}: {joined(names)} define the same function; "
                  f"move it into {SHARED} and import it from there")
    return 1 if found else 0


if __name__ == "__main__":
    sys.exit(main())
