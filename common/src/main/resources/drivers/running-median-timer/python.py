{USER_CODE}

import json

ops = json.loads(input())
args = json.loads(input())

obj = None
result = []
for op, arg in zip(ops, args):
    if op == "StreamMedian":
        obj = StreamMedian()
        result.append(None)
    elif op == "record":
        obj.record(arg[0])
        result.append(None)
    elif op == "median":
        median = obj.median()
        result.append(median)

# Format output: nulls stay null, floats with 1 decimal if whole, otherwise as-is
parts = []
for v in result:
    if v is None:
        parts.append("null")
    elif isinstance(v, float) and v == int(v):
        parts.append(f"{v:.1f}")
    else:
        parts.append(str(v))
print("[" + ",".join(parts) + "]")
