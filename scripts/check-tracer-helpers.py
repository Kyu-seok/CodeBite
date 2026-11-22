#!/usr/bin/env python3
"""Fails when two files in scripts/walkthroughs/ define the same function, top-level or nested.

A helper a second tracer needs belongs in codebite.py, imported by both: #364's tracers carried up
to seven copies each of ordinal, listed, centre_text and node_order, found only by review.

The same function is the same name, parameters (defaults too) and statements, compared as
ast.dump gives them, so layout and comments don't count, and neither does a docstring: a copy
with its docstring dropped or reworded is still a copy. A local helper may share a name with
another tracer's (show, tag, solve) as long as it does something else. Methods are not compared;
a function nested in one is.

No copy is let through: a nested function that closes over the tracer's own state moves into
codebite.py taking that state as parameters, and the tracer binds it (functools.partial).

    scripts/check-tracer-helpers.py [tracer directory]

Exits 1 and prints one COPY line per function, naming the files that define it; exits 2 when a
file doesn't parse. Tracers are Python 3.12 (a quote nested in an f-string), so an older python3
hands over to the one scripts/python312.sh finds.
"""
import ast
import os
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


def functions(tree):
    """(function, whether it is nested) for every function in the file that is not a method."""
    def walk(node, in_class, nested):
        for child in ast.iter_child_nodes(node):
            if isinstance(child, ast.FunctionDef):
                if not in_class:
                    yield child, nested
                yield from walk(child, False, True)
            else:
                yield from walk(child, isinstance(child, ast.ClassDef), nested)
    return walk(tree, False, False)


def copies(directory):
    """([(name, [file names])], the same for nested functions) for every function two or more
    files define, by name."""
    found = {False: defaultdict(list), True: defaultdict(list)}
    for path in sorted(directory.glob("*.py")):
        try:
            tree = ast.parse(path.read_text(encoding="utf-8"))
        except SyntaxError as error:
            stop(f"{path.name}:{error.lineno}: does not parse: {error.msg}")
        for node, nested in functions(tree):
            files = found[nested][same_function_key(node)]
            if path.name not in files:
                files.append(path.name)
    return tuple(sorted((key[0], names) for key, names in found[nested].items() if len(names) > 1)
                 for nested in (False, True))


def python_312():
    """The Python 3.12 or newer to hand over to: the finder asks each candidate its version, so the
    handover never lands on an older one and starts again."""
    found = subprocess.run([str(Path(__file__).with_name("python312.sh"))], capture_output=True, text=True)
    if found.returncode != 0:
        stop(f"tracers are Python 3.12: {found.stderr.strip()}")
    return found.stdout.strip()


def joined(names):
    return names[0] if len(names) == 1 else f"{', '.join(names[:-1])} and {names[-1]}"


def main():
    if sys.version_info < (3, 12):
        python = python_312()
        os.execv(python, [python, "-I", os.path.abspath(__file__), *sys.argv[1:]])
    directory = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parent / "walkthroughs"
    top_level, nested = copies(directory)
    for kind, found in (("function", top_level), ("nested function", nested)):
        for name, names in found:
            if SHARED in names:
                tracers = [n for n in names if n != SHARED]
                print(f"  COPY  {name}: {joined(tracers)} {'defines' if len(tracers) == 1 else 'define'} "
                      f"a function {SHARED} has; import it from there")
            else:
                print(f"  COPY  {name}: {joined(names)} define the same {kind}; "
                      f"move it into {SHARED} and import it from there")
    return 1 if top_level or nested else 0


if __name__ == "__main__":
    sys.exit(main())
