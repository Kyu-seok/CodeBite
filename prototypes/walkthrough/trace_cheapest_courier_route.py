"""PROTOTYPE: instrumented cheapest-courier-route reference solution (Bellman-Ford, k+1 rounds) -> walkthrough JSON."""
import json, sys

SAMPLES = [
    ("Example 1", 5, [[0,1,50],[1,2,40],[0,2,200],[2,3,30],[3,4,20],[1,3,150]], 0, 4, 2, 220),
    ("Example 2", 4, [[0,1,80],[1,2,40],[0,2,300],[2,3,90],[0,3,400]], 0, 3, 0, 400),
    ("Sample 3", 3, [[0,1,100],[1,2,100],[0,2,500]], 0, 2, 0, 500),
]
INF = None  # JSON-friendly infinity

def show(x):
    return "∞" if x == float('inf') else str(x)

def run(n, links, src, dst, k):
    frames = []
    def snap(caption, edge=None, improved=False, rnd=0, answer=None, path=(), path_costs=None):
        frames.append({
            "caption": caption,
            "graph": {"edge": edge, "improved": improved, "path": list(path), "pathCosts": path_costs},
            "vars": {"round": rnd, "rounds": k + 1,
                     "cost": [None if c == float('inf') else c for c in cost],
                     "updated": [None if c == float('inf') else c for c in updated]},
            "answer": answer,
        })
    cost = [float('inf')] * n
    cost[src] = 0
    updated = cost[:]
    best_via = [None] * n
    history = [best_via]
    cost_history = [cost[:]]
    snap(f"Only cafe {src} is reachable before any leg: cost 0 there, ∞ elsewhere. "
         f"maxHops = {k} allows {k + 1} leg{'s' if k else ''}, so {k + 1} round{'s' if k else ''} of relaxing.")
    for rnd in range(1, k + 2):
        updated = cost[:]
        via = best_via[:]
        snap(f"Round {rnd}: copy last round's costs. This round reads only last round's row, so each round adds at most one leg.", rnd=rnd)
        for i, (start, end, minutes) in enumerate(links):
            if cost[start] == float('inf'):
                snap(f"Leg {start}→{end}: cafe {start} wasn't reachable last round, skip.", edge=i, rnd=rnd)
            elif cost[start] + minutes < updated[end]:
                old = updated[end]
                updated[end] = cost[start] + minutes
                via[end] = (start, rnd)
                snap(f"Leg {start}→{end}: {cost[start]} + {minutes} = {updated[end]} beats {show(old)}, so cafe {end} costs {updated[end]} now.",
                     edge=i, improved=True, rnd=rnd)
            else:
                snap(f"Leg {start}→{end}: {cost[start]} + {minutes} = {cost[start] + minutes} doesn't beat {show(updated[end])}, keep it.", edge=i, rnd=rnd)
        cost = updated
        best_via = via
        history.append(via)
        cost_history.append(cost[:])
    if cost[dst] == float('inf'):
        answer = -1
        snap(f"After {k + 1} round{'s' if k else ''} cafe {dst} is still ∞: no route within {k} intermediate cafes, answer -1.", rnd=k + 1, answer=answer)
    else:
        answer = cost[dst]
        path, v = [], dst
        r = k + 1
        used = {dst: answer}
        while v != src:
            path.append(v)
            v, set_in = best_via[v]
            used[v] = cost_history[set_in - 1][v]
            best_via = history[set_in - 1]
        path.append(src)
        path.reverse()
        path_costs = [used.get(i) for i in range(n)]
        note = ''
        differ = [i for i in path if used[i] != cost[i]]
        for i in differ:
            note += (f" Cafe {i} shows {used[i]}, the cost it had when the route used it: its final {cost[i]} needs more legs,"
                     f" and one more leg from there would break maxHops.")
        snap(f"After {k + 1} round{'s' if k else ''} cafe {dst} costs {answer}, via {' → '.join(map(str, path))}: answer {answer}." + note,
             rnd=k + 1, answer=answer, path=path, path_costs=path_costs)
    return frames, answer

out = {"slug": "cheapest-courier-route", "title": "Cheapest Courier Route", "kind": "graph",
       "approach": "Bellman-Ford limited to maxHops + 1 rounds: round r finds the cheapest route using at most r legs.",
       "runs": []}
for label, n, links, src, dst, k, expected in SAMPLES:
    frames, answer = run(n, links, src, dst, k)
    assert answer == expected, (label, answer, expected)
    out["runs"].append({"label": label, "input": f"n = {n}, links = {json.dumps(links, separators=(',', ':'))}, src = {src}, dst = {dst}, maxHops = {k}",
                        "expected": expected, "n": n, "links": links, "src": src, "dst": dst, "frames": frames})
json.dump(out, sys.stdout, indent=1)
