{USER_CODE}

import json

equations = json.loads(input())
values = json.loads(input())
queries = json.loads(input())
result = Solution().calcEquation(equations, values, queries)
formatted = ','.join(f'{v:.5f}' for v in result)
print(f'[{formatted}]')
