{USER_CODE}

import json
strs = json.loads(input())
codec = ListCoder()
encoded = codec.pack(strs)
result = codec.unpack(encoded)
print(json.dumps(result, separators=(',', ':')))
