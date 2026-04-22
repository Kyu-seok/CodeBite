{USER_CODE}

import json
ops = json.loads(input())
args = json.loads(input())
result = []
s = None
for op, arg in zip(ops, args):
    if op == "RandomBag":
        s = RandomBag()
        result.append(None)
    elif op == "insert":
        result.append(s.insert(arg[0]))
    elif op == "remove":
        result.append(s.remove(arg[0]))
    elif op == "drawRandom":
        result.append(s.drawRandom())
output = json.dumps(result, separators=(',', ':'))
output = output.replace('True', 'true').replace('False', 'false')
print(output)
