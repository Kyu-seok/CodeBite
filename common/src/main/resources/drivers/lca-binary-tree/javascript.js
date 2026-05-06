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

function _findNode(root, val) {
    if (root === null) return null;
    if (root.val === val) return root;
    const left = _findNode(root.left, val);
    if (left !== null) return left;
    return _findNode(root.right, val);
}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const arr = JSON.parse(lines[0]);
const pVal = parseInt(lines[1]);
const qVal = parseInt(lines[2]);
const root = _buildTree(arr);
const p = _findNode(root, pVal);
const q = _findNode(root, qVal);
const result = new Solution().lowestCommonAncestor(root, p, q);
console.log(result.val);
