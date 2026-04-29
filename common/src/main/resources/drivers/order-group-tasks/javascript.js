{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const numCourses = parseInt(lines[0]);
const prerequisites = JSON.parse(lines[1]);
const result = new Solution().sequenceAssemblySteps(numCourses, prerequisites);

function hasCycle(n, prereqs) {
    const adj = Array.from({ length: n }, () => []);
    const indeg = new Array(n).fill(0);
    for (const [a, b] of prereqs) {
        adj[b].push(a);
        indeg[a]++;
    }
    const queue = [];
    for (let i = 0; i < n; i++) if (indeg[i] === 0) queue.push(i);
    let head = 0;
    let processed = 0;
    while (head < queue.length) {
        const u = queue[head++];
        processed++;
        for (const v of adj[u]) {
            if (--indeg[v] === 0) queue.push(v);
        }
    }
    return processed !== n;
}

function isValid(n, prereqs, result) {
    if (!Array.isArray(result)) return false;
    if (result.length === 0) return hasCycle(n, prereqs);
    if (result.length !== n) return false;
    const seen = new Array(n).fill(false);
    const pos = new Array(n).fill(0);
    for (let i = 0; i < result.length; i++) {
        const v = result[i];
        if (v < 0 || v >= n || seen[v]) return false;
        seen[v] = true;
        pos[v] = i;
    }
    for (const [a, b] of prereqs) {
        if (pos[b] >= pos[a]) return false;
    }
    return true;
}

console.log(isValid(numCourses, prerequisites, result) ? "VALID" : "INVALID");
