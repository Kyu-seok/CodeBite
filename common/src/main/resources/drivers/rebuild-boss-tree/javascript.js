{USER_CODE}

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

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const preorder = JSON.parse(lines[0]);
const inorder = JSON.parse(lines[1]);
const result = new Solution().assembleBreakdown(preorder, inorder);
console.log(JSON.stringify(_treeToArray(result)));
