class Solution {
    findTaskOrder(numTasks, prereqs) {
        const unlocks = Array.from({ length: numTasks }, () => []);
        const waiting = new Array(numTasks).fill(0);
        for (const [task, needed] of prereqs) {
            unlocks[needed].push(task);
            waiting[task]++;
        }
        const order = [];
        for (let t = 0; t < numTasks; t++) if (waiting[t] === 0) order.push(t);
        for (let head = 0; head < order.length; head++) {
            for (const next of unlocks[order[head]]) {
                if (--waiting[next] === 0) order.push(next);
            }
        }
        return order.length === numTasks ? order : [];
    }
}
