class Solution {
    maxSnackHaul(snacks) {
        let skipped = 0, taken = 0;
        for (const haul of snacks) {
            [skipped, taken] = [Math.max(skipped, taken), skipped + haul];
        }
        return Math.max(skipped, taken);
    }
}
