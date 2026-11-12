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


class Run:
    def __init__(self, label, input, expected, extra, setup):
        self.data = {"label": label, "input": input, "expected": expected, "frames": []}
        if extra:
            self.data["extra"] = True
        if setup:
            self.data["setup"] = _snapshot(setup, f"{label} setup")

    def frame(self, caption, answer=_MISSING, **views):
        """One step: a caption (string, or {"en": ..., "ko": ...}) and each view's state by view id."""
        f = {"caption": caption, "views": _snapshot(views, f"{self.data['label']} frame {len(self.data['frames'])}")}
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
            runs.append(d)
        return {**self.data, "runs": runs}

    def write(self, path):
        with open(path, "w", encoding="utf-8") as fh:
            json.dump(self.to_dict(), fh, ensure_ascii=False, indent=1)
            fh.write("\n")
