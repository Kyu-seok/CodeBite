{USER_CODE}

import json

ops = json.loads(input())
args = json.loads(input())

obj = None
result = []
for op, arg in zip(ops, args):
    if op == "FeedDesigner":
        obj = FeedDesigner()
        result.append(None)
    elif op == "postMessage":
        obj.postMessage(arg[0], arg[1])
        result.append(None)
    elif op == "getNewsFeed":
        result.append(obj.getNewsFeed(arg[0]))
    elif op == "follow":
        obj.follow(arg[0], arg[1])
        result.append(None)
    elif op == "unfollow":
        obj.unfollow(arg[0], arg[1])
        result.append(None)

print(json.dumps(result, separators=(',', ':')))
