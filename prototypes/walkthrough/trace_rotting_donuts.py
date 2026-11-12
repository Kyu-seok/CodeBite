"""PROTOTYPE: instrumented rotting-donuts reference solution -> walkthrough JSON."""
import json, sys, copy

SAMPLES = [
    ("Example 1", [[2,1,1],[1,0,1],[1,1,1]], 4),
    ("Example 2", [[2,0,1],[0,0,1],[1,1,1]], -1),
    ("Example 3", [[2,0],[0,1]], -1),
]

def run(ward):
    frames = []
    def snap(caption, lit=(), ring=(), stuck=(), answer=None):
        frames.append({
            "caption": caption,
            "grid": {"cells": copy.deepcopy(ward), "lit": [list(p) for p in lit],
                     "ring": [list(p) for p in ring], "stuck": [list(p) for p in stuck]},
            "vars": {"minute": minutes, "fresh": fresh, "wave": [list(p) for p in rotten]},
            "answer": answer,
        })
    rows, cols = len(ward), len(ward[0])
    fresh = sum(row.count(1) for row in ward)
    rotten = [(r, c) for r in range(rows) for c in range(cols) if ward[r][c] == 2]
    minutes = 0
    snap(f"Count {fresh} fresh donuts and put every stale one into the first wave.", ring=rotten)
    while rotten and fresh:
        next_wave = []
        for r, c in rotten:
            for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                if 0 <= nr < rows and 0 <= nc < cols and ward[nr][nc] == 1:
                    ward[nr][nc] = 2
                    fresh -= 1
                    next_wave.append((nr, nc))
        spread_from = rotten
        rotten = next_wave
        minutes += 1
        if next_wave:
            snap(f"Minute {minutes}: the wave touches {len(next_wave)} fresh neighbour{'s' if len(next_wave) > 1 else ''}; "
                 f"{'they go' if len(next_wave) > 1 else 'it goes'} stale and become{'' if len(next_wave) > 1 else 's'} the next wave. {fresh} fresh left.", lit=next_wave, ring=next_wave)
        else:
            snap(f"Minute {minutes}: no fresh neighbour next to the wave, so the wave dies out.", ring=spread_from)
    stuck = [(r, c) for r in range(rows) for c in range(cols) if ward[r][c] == 1]
    if fresh:
        answer = -1
        snap(f"The wave is gone but {fresh} fresh donut{'s are' if fresh > 1 else ' is'} still walled off by empty slots: answer -1.",
             stuck=stuck, answer=answer)
    else:
        answer = minutes
        snap(f"No fresh donut is left. It took {minutes} wave{'s' if minutes != 1 else ''}, one per minute: answer {minutes}.", answer=answer)
    return frames, answer

out = {"slug": "rotting-donuts", "title": "Rotting Donuts", "kind": "grid",
       "approach": "Multi-source BFS: every stale donut starts at once, and each wave is one minute.",
       "legend": {"0": "empty slot", "1": "fresh", "2": "stale"}, "runs": []}
for label, ward, expected in SAMPLES:
    frames, answer = run(copy.deepcopy(ward))
    assert answer == expected, (label, answer, expected)
    out["runs"].append({"label": label, "input": f"ward = {json.dumps(ward, separators=(',', ':'))}",
                        "expected": expected, "frames": frames})
json.dump(out, sys.stdout, indent=1)
