{USER_CODE}

import json
rooms = json.loads(input())
Solution().wallsAndGates(rooms)
print(json.dumps(rooms, separators=(',', ':')))
