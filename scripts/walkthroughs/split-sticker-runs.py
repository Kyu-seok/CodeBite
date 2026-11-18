#!/usr/bin/env python3.12
"""split-sticker-runs' Walkthrough: the reference solution (scripts/replay-solutions/split-sticker-runs.py), a
first pass recording each letter's last index in a map, then a second pass that stretches the current run to the
last index of every letter it reads and cuts it where the read index meets that end, on each sample Test Case.

The current run is a span above the stickers; each letter read looks up its last index (the map's probe), and a
later one moves from its card to the sticker it names, the run's new end. A finished run is a span below, and its
length moves into the answer.

    CODEBITE_DB=<database> scripts/walkthroughs/split-sticker-runs.py

writes common/src/main/resources/walkthroughs/split-sticker-runs.json.
"""
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough, at, map_entries, move, span  # noqa: E402

SLUG = "split-sticker-runs"

wt = Walkthrough(
    {"en": "Split Sticker Runs", "ko": "스티커 문자열 구간 분할"},
    {"en": "Note each letter's last index first. Then a run must reach the last index of every letter in it: "
           "stretch its end as letters are read, and cut the moment the index read is that end.",
     "ko": "먼저 글자마다 마지막 위치를 적어 둡니다. 구간은 그 안의 모든 글자의 마지막 위치까지 가야 하므로, "
           "글자를 읽을 때마다 구간의 끝을 늘리고 읽은 위치가 그 끝이 되는 순간 자릅니다."},
    views=[
        {"id": "stickers", "type": "array", "title": {"en": "stickers", "ko": "stickers (스티커)"}},
        {"id": "last", "type": "map", "title": {"en": "last index of each letter", "ko": "글자별 마지막 위치"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
        {"id": "sizes", "type": "output", "title": {"en": "run lengths", "ko": "구간 길이"},
         "empty": {"en": "none yet", "ko": "아직 없음"}},
    ],
)


def solve(stickers, run):
    """Solution.splitStickerRuns with a frame per letter in each pass. Returns the run lengths."""
    letters = list(stickers)
    n = len(letters)
    last = {}
    sizes = []
    done = {}  # below spans: the finished runs
    current = None  # (start, end) of the run being stretched, drawn above

    def frame(caption, i=None, lit=(), good=(), path=(), probe=None, last_marks=None, run_mark=None,
              sizes_marks=None, moves=None, **answer):
        spans = dict(done)
        if current is not None:
            start, end = current
            spans["run"] = span(start, end, {"en": f"run to {end}", "ko": f"{end}까지 구간"}, mark=run_mark)
        entries = [{"key": k, "value": f"i={v}"} for k, v in last.items()]
        state = {"entries": entries, "marks": last_marks or {}}
        if probe is not None:
            state["probe"] = probe
        run.frame(caption,
                  stickers={"values": letters, "pointers": {"i": i}, "spans": spans,
                            "marks": {"path": list(path), "good": list(good), "lit": list(lit)}},
                  last=state,
                  sizes={"values": sizes, "marks": sizes_marks or {}},
                  moves=moves, **answer)

    frame({"en": f"\"{stickers}\" has {n} stickers. First pass: write down the last index of every letter.",
           "ko": f"\"{stickers}\"에는 스티커가 {n}장 있습니다. 첫 번째로 훑으며 글자마다 마지막 위치를 적습니다."})
    for i, letter in enumerate(letters):
        seen = letter in last
        last[letter] = i
        if seen:
            en = f"'{letter}' again at index {i}: its last index so far moves on to {i}."
            ko = f"인덱스 {i}에 '{letter}' 글자가 또 나와, 이 글자의 마지막 위치가 {josa(i, '(으)로')} 바뀝니다."
        else:
            en = f"'{letter}' first appears at index {i}; its last index so far is {i}."
            ko = f"인덱스 {i}에 '{letter}' 글자가 처음 나옵니다. 지금까지의 마지막 위치는 {i}입니다."
        frame({"en": en, "ko": ko}, i=i, lit=[i], last_marks={"good": [letter]},
              moves=[move(at("stickers", i), at("last", letter), value=f"i={i}")])

    start = end = 0
    for i, letter in enumerate(letters):
        ends_at = last[letter]
        before = end
        end = max(end, ends_at)
        current = (start, end)
        look = {"key": letter, "hit": True,
                "label": {"en": f"last of '{letter}'?", "ko": f"'{letter}'의 마지막?"}}
        moves = []
        good = []
        if end > before or i == start:
            moves.append(move(at("last", letter), at("stickers", ends_at), value=str(ends_at)))
            good = [ends_at] if ends_at != i else []
        if i == start:
            stretch_en = f"A new run starts at index {i}, and '{letter}' last appears at {ends_at}, so it must reach {end}."
            stretch_ko = f"인덱스 {i}에서 새 구간이 시작하고, '{letter}' 글자는 {ends_at}에서 마지막으로 나오므로 구간은 {end}까지 가야 합니다."
        elif end > before:
            stretch_en = f"'{letter}' at index {i} last appears at {ends_at}, past the run's end {before}: stretch it to {end}."
            stretch_ko = f"인덱스 {i}의 '{letter}' 글자는 {ends_at}에서 마지막으로 나와 구간의 끝 {before}보다 뒤이므로, 끝을 {josa(end, '(으)로')} 늘립니다."
        else:
            stretch_en = f"'{letter}' at index {i} last appears at {ends_at}, inside the run to {end}: the end stays."
            stretch_ko = f"인덱스 {i}의 '{letter}' 글자는 {ends_at}에서 마지막으로 나와 {end}까지인 구간 안에 있으므로 끝은 그대로입니다."
        if i == end:
            size = end - start + 1
            sizes.append(size)
            done[f"done{len(sizes)}"] = span(start, end, str(size), below=True, mark="good")
            current = None
            moves.append(move(at("stickers", i), at("sizes", len(sizes) - 1), value=str(size)))
            cut_en = f" Index {i} is the end, so every letter in it is finished: cut a run of {size}."
            cut_ko = f" 인덱스 {josa(i, '이가')} 끝이라 구간 안의 글자가 모두 끝났으니, 길이 {size}인 구간을 자릅니다."
            frame({"en": stretch_en + cut_en, "ko": stretch_ko + cut_ko}, i=i, lit=[i], probe=look,
                  sizes_marks={"good": [len(sizes) - 1]}, moves=moves)
            done[f"done{len(sizes)}"]["mark"] = "path"
            start = i + 1
        else:
            frame({"en": stretch_en, "ko": stretch_ko}, i=i, lit=[i], good=good, probe=look, run_mark=(
                "good" if moves else None), moves=moves)
    answer = driver_list(sizes)
    k = len(sizes)
    frame({"en": f"Every sticker is in a run: {k} {plural(k, 'run', 'runs')}, of lengths {answer}.",
           "ko": f"모든 스티커가 구간에 들어갔습니다. 구간 {k}개의 길이는 {answer}입니다."},
          path=range(n), sizes_marks={"path": list(range(k))}, answer=answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    stickers = sample["input"].strip()
    run = sample_run(wt, number, sample, input=f"stickers = \"{stickers}\"")
    solve(stickers, run)
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
