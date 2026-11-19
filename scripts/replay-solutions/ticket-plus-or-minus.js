class Solution {
    countSignAssignments(tickets, target) {
        let ways = new Map([[0, 1]]);
        for (const value of tickets) {
            const following = new Map();
            for (const [total, count] of ways) {
                following.set(total + value, (following.get(total + value) || 0) + count);
                following.set(total - value, (following.get(total - value) || 0) + count);
            }
            ways = following;
        }
        return ways.get(target) || 0;
    }
}
