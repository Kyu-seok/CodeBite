"""Record a Walkthrough from an instrumented solution (format: references/format.md).

    from walkthrough_trace import Walkthrough   # copy it beside the tracer, or put kit/ on sys.path
    wt = Walkthrough("Title", "Approach in one sentence.", views=[
        {"id": "board", "type": "grid", "values": {"0": {"label": "empty", "tone": "empty"}}},
        {"id": "state", "type": "vars"},
    ])
    run = wt.run("Example 1", input="grid = [[...]]", expected=4)
    run.frame("What happened and why.", board={"cells": grid, "marks": {"lit": [[0, 1]]}},
              state={"items": [{"label": "minute", "value": 0}]})
    ...
    run.frame("Answer 4.", answer=4, board=...)   # the last frame carries the answer
    wt.write("walkthrough.json")                  # fails if a run's answer is not its expected output

A value going from one place to another is a move, by address (an array index, a map key, a set member, an output
index, a queue position from the front, a grid [row, col]):

    from walkthrough_trace import at, move, map_entries, probe, span
    run.frame("4 goes into the map.", xs={"values": nums}, uses={"entries": map_entries(counts)},
              moves=[move(at("xs", i), at("uses", 4))])   # move(dst=...) creates, move(src) drops

A lookup in a `set` view is a probe: `seen={"members": list(seen), "probes": [probe(x, hit=x in seen)]}`.

A window or a record on an array is a span: `xs={"values": nums, "spans": {"window": span(left, right, "window")}}`.

Every state you pass is snapshotted (deep-copied through JSON) when `frame` is called, so keep mutating
your own structures freely. Floats like inf are rejected: show them as a string ("∞").
"""
import json
import math

_MISSING = object()


def _snapshot(value, where):
    def check(v):
        if isinstance(v, float) and not math.isfinite(v):
            raise ValueError(f"{where}: {v} is not JSON; pass a display string such as '∞'")
        if isinstance(v, dict):
            for x in v.values():
                check(x)
        elif isinstance(v, (list, tuple)):
            for x in v:
                check(x)
    check(value)
    return json.loads(json.dumps(value, ensure_ascii=False))


def at(view, where):
    """An address: a place in a view (an array or output index, a map key, a set member, a queue position, a grid [row, col])."""
    return {"view": view, "at": where}


def move(src=None, dst=None, value=_MISSING, mark=None):
    """A value going from `src` to `dst` (addresses from `at`). No src: created at dst; no dst: dropped from src.
    `value` is the flying chip's text (default: the source's); `mark` ("good", "bad", "path") overrides its colour."""
    if src is None and dst is None:
        raise ValueError("a move needs a src, a dst or both")
    m = {}
    if src is not None:
        m["from"] = src
    if dst is not None:
        m["to"] = dst
    if value is not _MISSING:
        m["value"] = value
    if mark is not None:
        m["mark"] = mark
    return m


def span(start, end, label=None, mark=None, below=False, fade=False):
    """An `array` view's span: the range start..end (inclusive) with a label and a mark. Above the cells by default
    (a live window); `below=True` draws it dashed under them (a record, such as the best so far). `fade=True` fades
    the cells outside it. Pass spans by name: `queue={"values": q, "spans": {"window": span(l, r, "window")}}`."""
    s = {"from": start, "to": end}
    if label is not None:
        s["label"] = label
    if mark is not None:
        s["mark"] = mark
    if below:
        s["below"] = True
    if fade:
        s["fade"] = True
    return s


def probe(value, hit=None, label=None):
    """A `set` view's lookup of `value`: `set={"members": list(seen), "probes": [probe(x)]}`. Whether it hits defaults to
    whether `value` is a member; pass `hit=False` for a value looked up and then added in the same step."""
    p = {"value": value}
    if hit is not None:
        p["hit"] = hit
    if label is not None:
        p["label"] = label
    return p


def map_entries(mapping):
    """A dict as a `map` view's entries, in its insertion order."""
    return [{"key": k, "value": v} for k, v in mapping.items()]


class Run:
    def __init__(self, label, input, expected, extra, setup):
        self.data = {"label": label, "input": input, "expected": expected, "frames": []}
        if extra:
            self.data["extra"] = True
        if setup:
            self.data["setup"] = _snapshot(setup, f"{label} setup")

    def frame(self, caption, answer=_MISSING, moves=None, **views):
        """One step: a caption (string, or {"en": ..., "ko": ...}), each view's state by view id, and the values
        that moved in this step (`move(...)` items)."""
        where = f"{self.data['label']} frame {len(self.data['frames'])}"
        f = {"caption": caption, "views": _snapshot(views, where)}
        if moves:
            f["moves"] = _snapshot(moves, where)
        if answer is not _MISSING:
            f["answer"] = _snapshot(answer, "answer")
        self.data["frames"].append(f)
        return self


class Walkthrough:
    def __init__(self, title, approach, views):
        self.data = {"format": "walkthrough/1", "title": title, "approach": approach, "views": views, "runs": []}
        self._runs = []

    def run(self, label, input, expected, extra=False, setup=None):
        """A run of the approach on one input. `extra=True` marks an input that is not one of the problem's samples."""
        r = Run(label, input, expected, extra, setup)
        self._runs.append(r)
        return r

    def to_dict(self):
        ids = {v["id"] for v in self.data["views"]}
        runs = []
        for r in self._runs:
            d = r.data
            name = d["label"] if isinstance(d["label"], str) else json.dumps(d["label"], ensure_ascii=False)
            if not d["frames"]:
                raise ValueError(f"run {name}: no frames")
            last = d["frames"][-1]
            if "answer" not in last:
                raise ValueError(f"run {name}: the last frame has no answer")
            if last["answer"] != d["expected"]:
                raise ValueError(f"run {name}: answer {last['answer']!r} is not the expected {d['expected']!r}")
            for i, f in enumerate(d["frames"]):
                unknown = set(f["views"]) - ids
                if unknown:
                    raise ValueError(f"run {name} frame {i}: unknown view ids {sorted(unknown)}")
                for m in f.get("moves", []):
                    for end in ("from", "to"):
                        if end in m and m[end]["view"] not in ids:
                            raise ValueError(f"run {name} frame {i}: a move names unknown view {json.dumps(m[end]['view'])}")
            runs.append(d)
        return {**self.data, "runs": runs}

    def write(self, path):
        data = self.to_dict()  # checks every run first, so a refused run never truncates the file
        with open(path, "w", encoding="utf-8") as fh:
            json.dump(data, fh, ensure_ascii=False, indent=1)
            fh.write("\n")
