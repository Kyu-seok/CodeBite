{USER_CODE}

function _buildTree(arr) {
    if (!arr.length) return null;
    const root = new TreeNode(arr[0]);
    const queue = [root];
    let i = 1;
    while (queue.length && i < arr.length) {
        const node = queue.shift();
        if (i < arr.length && arr[i] !== null) {
            node.left = new TreeNode(arr[i]);
            queue.push(node.left);
        }
        i++;
        if (i < arr.length && arr[i] !== null) {
            node.right = new TreeNode(arr[i]);
            queue.push(node.right);
        }
        i++;
    }
    return root;
}

function _treeToArray(root) {
    if (!root) return [];
    const result = [];
    const queue = [root];
    while (queue.length) {
        const node = queue.shift();
        if (node) {
            result.push(node.val);
            queue.push(node.left);
            queue.push(node.right);
        } else {
            result.push(null);
        }
    }
    while (result.length && result[result.length - 1] === null) {
        result.pop();
    }
    return result;
}

function _formatTree(arr) {
    if (!arr.length) return '[]';
    const parts = arr.map(v => v === null ? 'null' : String(v));
    return '[' + parts.join(',') + ']';
}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const arr = JSON.parse(input);
const root = _buildTree(arr);
const codec = new Codec();
const serialized = codec.serialize(root);
const result = codec.deserialize(serialized);
console.log(_formatTree(_treeToArray(result)));
