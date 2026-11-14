class Solution {
    public Node cloneMap(Node node) {
        if (node == null) return null;
        Map<Node, Node> copies = new HashMap<>();
        copies.put(node, new Node(node.val));
        Deque<Node> stack = new ArrayDeque<>();
        stack.push(node);
        while (!stack.isEmpty()) {
            Node original = stack.pop();
            for (Node neighbor : original.neighbors) {
                if (!copies.containsKey(neighbor)) {
                    copies.put(neighbor, new Node(neighbor.val));
                    stack.push(neighbor);
                }
                copies.get(original).neighbors.add(copies.get(neighbor));
            }
        }
        return copies.get(node);
    }
}
