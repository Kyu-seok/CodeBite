class Solution {
    public void moveVoidsToEnd(int[] scans) {
        int write = 0;
        for (int scan : scans) {
            if (scan != 0) scans[write++] = scan;
        }
        while (write < scans.length) scans[write++] = 0;
    }
}
