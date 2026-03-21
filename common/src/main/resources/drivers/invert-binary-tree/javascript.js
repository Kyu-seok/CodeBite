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
        if (node === null) {
            result.push(null);
        } else {
            result.push(node.val);
            queue.push(node.left);
            queue.push(node.right);
        }
    }
    while (result.length && result[result.length - 1] === null) {
        result.pop();
    }
    return result;
}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const arr = JSON.parse(input);
const root = _buildTree(arr);
const result = new Solution().invertTree(root);
console.log(JSON.stringify(_treeToArray(result)));
