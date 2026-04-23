{USER_CODE}

import json
ops = json.loads(input())
args = json.loads(input())
result = []
stack = None
for op, arg in zip(ops, args):
    if op == "LowTrackStack":
        stack = LowTrackStack()
        result.append(None)
    elif op == "push":
        stack.push(arg[0])
        result.append(None)
    elif op == "pop":
        stack.pop()
        result.append(None)
    elif op == "top":
        result.append(stack.top())
    elif op == "getMin":
        result.append(stack.getMin())
print(json.dumps(result, separators=(',', ':')))
