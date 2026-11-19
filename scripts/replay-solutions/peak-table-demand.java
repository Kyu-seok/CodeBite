class Solution {
    public int minTables(int[][] visits) {
        int n = visits.length;
        int[] arrive = new int[n], leave = new int[n];
        for (int i = 0; i < n; i++) { arrive[i] = visits[i][0]; leave[i] = visits[i][1]; }
        java.util.Arrays.sort(arrive);
        java.util.Arrays.sort(leave);
        int seated = 0, most = 0, j = 0;
        for (int i = 0; i < n; i++) {
            while (leave[j] <= arrive[i]) { j++; seated--; }
            seated++;
            most = Math.max(most, seated);
        }
        return most;
    }
}
