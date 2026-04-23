{USER_CODE}

function _buildGraph(adjList) {
    if (!adjList.length) return null;
    const n = adjList.length;
    const nodes = [null];
    for (let i = 1; i <= n; i++) nodes.push(new Node(i));
    for (let i = 0; i < n; i++) {
        for (const nbr of adjList[i]) {
            nodes[i + 1].neighbors.push(nodes[nbr]);
        }
    }
    return nodes[1];
}

function _graphToAdjList(node) {
    if (!node) return [];
    const visited = new Map();
    const queue = [node];
    visited.set(node.val, node);
    while (queue.length) {
        const curr = queue.shift();
        for (const nbr of curr.neighbors) {
            if (!visited.has(nbr.val)) {
                visited.set(nbr.val, nbr);
                queue.push(nbr);
            }
        }
    }
    const keys = [...visited.keys()].sort((a, b) => a - b);
    return keys.map(k => visited.get(k).neighbors.map(n => n.val));
}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const adjList = JSON.parse(input);
const node = _buildGraph(adjList);
const cloned = new Solution().snapshotMeshLayout(node);
console.log(JSON.stringify(_graphToAdjList(cloned)));
