{USER_CODE}

import json
image = json.loads(input())
Solution().rotateImage(image)
print(json.dumps(image, separators=(',', ':')))
