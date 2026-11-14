class Solution {
    static const long long MOD = 1000000007LL;

    long long power(long long base, long long exp) {
        long long result = 1;
        base %= MOD;
        while (exp > 0) {
            if (exp & 1) result = result * base % MOD;
            base = base * base % MOD;
            exp >>= 1;
        }
        return result;
    }

public:
    int countTaskOrders(vector<int>& parent) {
        // Valid orders = n! / (product of every subtree's size), modulo a prime.
        int n = parent.size();
        vector<vector<int>> children(n);
        for (int task = 1; task < n; task++) children[parent[task]].push_back(task);
        vector<int> order = {0};
        for (int i = 0; i < (int) order.size(); i++)
            for (int child : children[order[i]]) order.push_back(child);
        vector<long long> size(n, 1);
        for (int i = n - 1; i >= 1; i--) size[parent[order[i]]] += size[order[i]];
        long long factorial = 1, denominator = 1;
        for (int i = 2; i <= n; i++) factorial = factorial * i % MOD;
        for (long long s : size) denominator = denominator * (s % MOD) % MOD;
        return (int) (factorial * power(denominator, MOD - 2) % MOD);
    }
};
