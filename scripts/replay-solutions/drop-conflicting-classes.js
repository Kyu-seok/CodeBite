class Solution {
    dropClassConflicts(classes) {
        const sorted = [...classes].sort((a, b) => a[1] - b[1]);
        let dropped = 0, end = -Infinity;
        for (const [start, finish] of sorted) {
            if (start >= end) end = finish;
            else dropped++;
        }
        return dropped;
    }
}
