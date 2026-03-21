class Node {
    public int val;
    public java.util.List<Node> neighbors;
    public Node() { val = 0; neighbors = new java.util.ArrayList<>(); }
    public Node(int val) { this.val = val; neighbors = new java.util.ArrayList<>(); }
    public Node(int val, java.util.List<Node> neighbors) { this.val = val; this.neighbors = neighbors; }

    static Node fromAdjList(String input) {
        input = input.trim();
        if (input.equals("[]")) return null;
        java.util.List<java.util.List<Integer>> adjList = new java.util.ArrayList<>();
        String inner = input.substring(1, input.length() - 1);
        int i = 0;
        while (i < inner.length()) {
            if (inner.charAt(i) == '[') {
                int j = inner.indexOf(']', i);
                String sub = inner.substring(i + 1, j);
                java.util.List<Integer> nbrs = new java.util.ArrayList<>();
                if (!sub.isEmpty()) {
                    for (String p : sub.split(",")) {
                        nbrs.add(Integer.parseInt(p.trim()));
                    }
                }
                adjList.add(nbrs);
                i = j + 1;
            } else {
                i++;
            }
        }
        int n = adjList.size();
        Node[] nodes = new Node[n + 1];
        for (int k = 1; k <= n; k++) nodes[k] = new Node(k);
        for (int k = 0; k < n; k++) {
            for (int nbr : adjList.get(k)) {
                nodes[k + 1].neighbors.add(nodes[nbr]);
            }
        }
        return nodes[1];
    }

    static String toAdjListJson(Node node) {
        if (node == null) return "[]";
        java.util.Map<Integer, Node> visited = new java.util.TreeMap<>();
        java.util.Queue<Node> queue = new java.util.LinkedList<>();
        queue.add(node);
        visited.put(node.val, node);
        while (!queue.isEmpty()) {
            Node curr = queue.poll();
            for (Node nbr : curr.neighbors) {
                if (!visited.containsKey(nbr.val)) {
                    visited.put(nbr.val, nbr);
                    queue.add(nbr);
                }
            }
        }
        StringBuilder sb = new StringBuilder("[");
        boolean first = true;
        for (java.util.Map.Entry<Integer, Node> entry : visited.entrySet()) {
            if (!first) sb.append(",");
            first = false;
            sb.append("[");
            Node n = entry.getValue();
            for (int j = 0; j < n.neighbors.size(); j++) {
                if (j > 0) sb.append(",");
                sb.append(n.neighbors.get(j).val);
            }
            sb.append("]");
        }
        sb.append("]");
        return sb.toString();
    }
}
