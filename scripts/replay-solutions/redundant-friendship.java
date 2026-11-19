class Solution {
    private int[] parent;

    public int[] spotRedundantLink(int[][] links) {
        parent = new int[links.length + 1];
        for (int i = 0; i < parent.length; i++) parent[i] = i;
        for (int[] link : links) {
            int rootA = find(link[0]), rootB = find(link[1]);
            if (rootA == rootB) return new int[]{link[0], link[1]};
            parent[rootA] = rootB;
        }
        return new int[0];
    }

    private int find(int x) {
        while (parent[x] != x) {
            parent[x] = parent[parent[x]];
            x = parent[x];
        }
        return x;
    }
}
