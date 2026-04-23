{USER_CODE}

import json

ops = json.loads(input())
args = json.loads(input())

obj = None
result = []
for op, arg in zip(ops, args):
    if op == "MicroFeed":
        obj = MicroFeed()
        result.append(None)
    elif op == "publishPost":
        obj.publishPost(arg[0], arg[1])
        result.append(None)
    elif op == "latestFeed":
        result.append(obj.latestFeed(arg[0]))
    elif op == "subscribe":
        obj.subscribe(arg[0], arg[1])
        result.append(None)
    elif op == "unsubscribe":
        obj.unsubscribe(arg[0], arg[1])
        result.append(None)

print(json.dumps(result, separators=(',', ':')))
