class Solution {
    private static final long MOD = 1_000_000_007L;

    public int countTaskOrders(int[] parent) {
        // Valid orders = n! / (product of every subtree's size), modulo a prime.
        int n = parent.length;
        List<List<Integer>> children = new ArrayList<>();
        for (int task = 0; task < n; task++) children.add(new ArrayList<>());
        for (int task = 1; task < n; task++) children.get(parent[task]).add(task);
        List<Integer> order = new ArrayList<>(List.of(0)); // breadth-first: parents before children
        for (int i = 0; i < order.size(); i++) order.addAll(children.get(order.get(i)));
        long[] size = new long[n];
        Arrays.fill(size, 1);
        for (int i = n - 1; i >= 1; i--) size[parent[order.get(i)]] += size[order.get(i)];
        long factorial = 1, denominator = 1;
        for (int i = 2; i <= n; i++) factorial = factorial * i % MOD;
        for (long s : size) denominator = denominator * s % MOD;
        return (int) (factorial * power(denominator, MOD - 2) % MOD);
    }

    private long power(long base, long exp) {
        long result = 1;
        base %= MOD;
        while (exp > 0) {
            if ((exp & 1) == 1) result = result * base % MOD;
            base = base * base % MOD;
            exp >>= 1;
        }
        return result;
    }
}
