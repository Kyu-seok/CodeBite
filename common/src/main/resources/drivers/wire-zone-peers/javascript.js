{USER_CODE}

function _buildTree(arr) {
    if (!arr.length) return null;
    const root = new Node(arr[0]);
    const queue = [root];
    let i = 1;
    while (queue.length && i < arr.length) {
        const node = queue.shift();
        if (i < arr.length && arr[i] !== null) {
            node.left = new Node(arr[i]);
            queue.push(node.left);
        }
        i++;
        if (i < arr.length && arr[i] !== null) {
            node.right = new Node(arr[i]);
            queue.push(node.right);
        }
        i++;
    }
    return root;
}

function _serialize(root) {
    if (root === null) return '[]';
    const parts = [];
    let levelStart = root;
    while (levelStart !== null) {
        let curr = levelStart;
        while (curr !== null) {
            parts.push(String(curr.val));
            curr = curr.next;
        }
        parts.push('#');
        levelStart = levelStart.left;
    }
    return '[' + parts.join(',') + ']';
}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const arr = JSON.parse(input);
const root = _buildTree(arr);
const result = new Solution().wireSiblingHubs(root);
console.log(_serialize(result));
