class Solution {
    private int[] parent;

    public int countParties(int n, int[][] relays) {
        parent = new int[n];
        for (int i = 0; i < n; i++) parent[i] = i;
        int parties = n;
        for (int[] relay : relays) {
            int ra = find(relay[0]), rb = find(relay[1]);
            if (ra != rb) {
                parent[ra] = rb;
                parties--;
            }
        }
        return parties;
    }

    private int find(int x) {
        while (parent[x] != x) {
            parent[x] = parent[parent[x]];
            x = parent[x];
        }
        return x;
    }
}
