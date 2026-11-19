class Solution {
    public int[][] rebuildLine(int[][] players) {
        int[][] sorted = players.clone();
        Arrays.sort(sorted, (a, b) -> a[0] != b[0] ? b[0] - a[0] : a[1] - b[1]);
        List<int[]> line = new ArrayList<>();
        for (int[] player : sorted) line.add(player[1], player);
        return line.toArray(new int[0][]);
    }
}
