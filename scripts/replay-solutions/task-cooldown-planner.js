class Solution {
    minPrintSlots(jobs, n) {
        const counts = new Map();
        for (const job of jobs) counts.set(job, (counts.get(job) || 0) + 1);
        const most = Math.max(...counts.values());
        let tied = 0;
        for (const count of counts.values()) if (count === most) tied++;
        return Math.max(jobs.length, (most - 1) * (n + 1) + tied);
    }
}
