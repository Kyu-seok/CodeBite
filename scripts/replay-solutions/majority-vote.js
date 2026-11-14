class Solution {
    majorityVote(votes) {
        let candidate = votes[0], count = 0;
        for (const vote of votes) {
            if (count === 0) candidate = vote;
            count += vote === candidate ? 1 : -1;
        }
        return candidate;
    }
}
