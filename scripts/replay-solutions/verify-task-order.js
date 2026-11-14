class Solution {
    canFinishAllTasks(numTasks, prereqs) {
        const unlocks = Array.from({ length: numTasks }, () => []);
        const waiting = new Array(numTasks).fill(0);
        for (const [task, before] of prereqs) {
            unlocks[before].push(task);
            waiting[task]++;
        }
        const ready = [];
        for (let i = 0; i < numTasks; i++) if (waiting[i] === 0) ready.push(i);
        let done = 0;
        while (ready.length) {
            const task = ready.pop();
            done++;
            for (const next of unlocks[task]) {
                if (--waiting[next] === 0) ready.push(next);
            }
        }
        return done === numTasks;
    }
}
