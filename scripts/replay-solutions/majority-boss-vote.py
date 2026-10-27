class Solution:
    def majorityHeadline(self, votes: list[int]) -> int:
        candidate = votes[0]
        count = 0
        for vote in votes:
            if count == 0:
                candidate = vote
            count += 1 if vote == candidate else -1
        return candidate
