class Solution {
    public Node cloneQuestLog(Node head) {
        java.util.Map<Node, Node> copies = new java.util.HashMap<>();
        for (Node node = head; node != null; node = node.next) {
            copies.put(node, new Node(node.val));
        }
        for (Node node = head; node != null; node = node.next) {
            Node copy = copies.get(node);
            copy.next = copies.get(node.next);
            copy.related = copies.get(node.related);
        }
        return copies.get(head);
    }
}
