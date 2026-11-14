{USER_CODE}

import json
stickers = input().strip()
result = Solution().splitStickerRuns(stickers)
print(json.dumps(result, separators=(',', ':')))
