{USER_CODE}

import json
ops = json.loads(input())
args = json.loads(input())
result = []
queue = None
for op, arg in zip(ops, args):
    if op == "QueueFromStacks":
        queue = QueueFromStacks()
        result.append(None)
    elif op == "push":
        queue.push(arg[0])
        result.append(None)
    elif op == "pop":
        result.append(queue.pop())
    elif op == "peek":
        result.append(queue.peek())
    elif op == "empty":
        result.append(queue.empty())
output = json.dumps(result, separators=(',', ':'))
output = output.replace('True', 'true').replace('False', 'false')
print(output)
