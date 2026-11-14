{USER_CODE}

cards = eval(input())
groupSize = int(input())
result = Solution().canGroupCards(cards, groupSize)
print(str(result).lower())
