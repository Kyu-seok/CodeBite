class Solution {
    public int minPrintSlots(char[] jobs, int n) {
        int[] counts = new int[26];
        for (char job : jobs) counts[job - 'A']++;
        int most = 0, tied = 0;
        for (int count : counts) {
            if (count > most) { most = count; tied = 1; }
            else if (count == most && count > 0) tied++;
        }
        return Math.max(jobs.length, (most - 1) * (n + 1) + tied);
    }
}
