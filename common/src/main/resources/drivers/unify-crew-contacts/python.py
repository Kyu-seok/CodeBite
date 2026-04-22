{USER_CODE}

import json
accounts = json.loads(input())
result = Solution().unifyContactIdentities(accounts)
# Sort emails within each account, then sort by first email
for account in result:
    emails = sorted(account[1:])
    account[1:] = emails
result.sort(key=lambda a: a[1])
print(json.dumps(result, separators=(',', ':')))
