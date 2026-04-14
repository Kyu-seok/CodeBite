{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const data = JSON.parse(input);

if (!data.length) {
    console.log("[]");
} else {
    const nodes = data.map(p => new Node(p[0]));
    for (let i = 0; i < nodes.length - 1; i++) {
        nodes[i].next = nodes[i + 1];
    }
    for (let i = 0; i < data.length; i++) {
        if (data[i][1] !== null) {
            nodes[i].random = nodes[data[i][1]];
        }
    }

    const result = new Solution().copyRandomList(nodes[0]);

    const indexMap = new Map();
    let curr = result;
    let idx = 0;
    while (curr) {
        indexMap.set(curr, idx++);
        curr = curr.next;
    }

    const output = [];
    curr = result;
    while (curr) {
        const randIdx = curr.random !== null ? indexMap.get(curr.random) : null;
        output.push([curr.val, randIdx]);
        curr = curr.next;
    }

    console.log(JSON.stringify(output));
}
