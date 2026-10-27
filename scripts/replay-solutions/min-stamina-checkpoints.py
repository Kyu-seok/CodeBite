class Solution:
    def pickLeastEffort(self, cost: list[int]) -> int:
        # two_back, one_back: least stamina to stand at positions i - 2 and i - 1.
        two_back, one_back = 0, 0
        for i in range(2, len(cost) + 1):
            two_back, one_back = one_back, min(one_back + cost[i - 1], two_back + cost[i - 2])
        return one_back
