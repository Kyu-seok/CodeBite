{USER_CODE}

import json

ops = json.loads(input())
args = json.loads(input())

obj = None
result = []
for op, arg in zip(ops, args):
    if op == "HitCounter":
        obj = HitCounter()
        result.append(None)
    elif op == "hit":
        obj.hit(arg[0])
        result.append(None)
    elif op == "getHits":
        result.append(obj.getHits(arg[0]))

print(json.dumps(result, separators=(',', ':')))
