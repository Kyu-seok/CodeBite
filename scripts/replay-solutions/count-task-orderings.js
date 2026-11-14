class Solution {
    countTaskOrders(parent) {
        // Valid orders = n! / (product of every subtree's size), modulo a prime.
        const MOD = 1000000007n;
        const n = parent.length;
        const children = Array.from({ length: n }, () => []);
        for (let task = 1; task < n; task++) children[parent[task]].push(task);
        const order = [0];
        for (let i = 0; i < order.length; i++) for (const child of children[order[i]]) order.push(child);
        const size = new Array(n).fill(1);
        for (let i = n - 1; i >= 1; i--) size[parent[order[i]]] += size[order[i]];
        let factorial = 1n, denominator = 1n;
        for (let i = 2n; i <= BigInt(n); i++) factorial = factorial * i % MOD;
        for (const s of size) denominator = denominator * BigInt(s) % MOD;
        let result = 1n, base = denominator, exp = MOD - 2n;
        while (exp > 0n) {
            if (exp & 1n) result = result * base % MOD;
            base = base * base % MOD;
            exp >>= 1n;
        }
        return Number(factorial * result % MOD);
    }
}
