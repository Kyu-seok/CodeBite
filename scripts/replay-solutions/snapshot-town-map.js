class Node {
    constructor(val = 0, neighbors = []) {
        this.val = val;
        this.neighbors = neighbors;
    }
}

class Solution {
    cloneMap(node) {
        if (!node) return null;
        const copies = new Map([[node, new Node(node.val)]]);
        const stack = [node];
        while (stack.length) {
            const original = stack.pop();
            for (const neighbor of original.neighbors) {
                if (!copies.has(neighbor)) {
                    copies.set(neighbor, new Node(neighbor.val));
                    stack.push(neighbor);
                }
                copies.get(original).neighbors.push(copies.get(neighbor));
            }
        }
        return copies.get(node);
    }
}
