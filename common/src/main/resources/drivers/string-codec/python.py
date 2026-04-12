{USER_CODE}

import json
strs = json.loads(input())
codec = Codec()
encoded = codec.encode(strs)
result = codec.decode(encoded)
print(json.dumps(result, separators=(',', ':')))
