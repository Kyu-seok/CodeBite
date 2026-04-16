{USER_CODE}

import json
ops = json.loads(input())
args = json.loads(input())
result = []
buf = None
for op, arg in zip(ops, args):
    if op == "RingBuffer":
        buf = RingBuffer(arg[0])
        result.append(None)
    elif op == "enQueue":
        result.append(buf.enQueue(arg[0]))
    elif op == "deQueue":
        result.append(buf.deQueue())
    elif op == "front":
        result.append(buf.front())
    elif op == "rear":
        result.append(buf.rear())
    elif op == "isEmpty":
        result.append(buf.isEmpty())
    elif op == "isFull":
        result.append(buf.isFull())
print(json.dumps(result, separators=(',', ':')))
