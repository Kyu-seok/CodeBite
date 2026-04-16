{USER_CODE}

import json
begin_word = input().strip()
end_word = input().strip()
word_list = json.loads(input().strip())
result = Solution().chainLength(begin_word, end_word, word_list)
print(result)
