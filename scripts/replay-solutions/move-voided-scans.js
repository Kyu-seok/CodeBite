class Solution {
    moveVoidsToEnd(scans) {
        let write = 0;
        for (const scan of scans) {
            if (scan !== 0) scans[write++] = scan;
        }
        while (write < scans.length) scans[write++] = 0;
    }
}
