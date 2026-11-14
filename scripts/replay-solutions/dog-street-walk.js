class Solution {
    /**
     * @param {string[][]} routes
     * @return {string[]}
     */
    planWalk(routes) {
        const outgoing = new Map();
        const sorted = routes.slice().sort((a, b) =>
            a[0] < b[0] ? 1 : a[0] > b[0] ? -1 : a[1] < b[1] ? 1 : a[1] > b[1] ? -1 : 0);
        for (const [from, to] of sorted) {
            if (!outgoing.has(from)) outgoing.set(from, []);
            outgoing.get(from).push(to);
        }
        const walk = [];
        const stack = ['HUB'];
        while (stack.length) {
            const next = outgoing.get(stack[stack.length - 1]);
            if (next && next.length) stack.push(next.pop());
            else walk.push(stack.pop());
        }
        return walk.reverse();
    }
}
