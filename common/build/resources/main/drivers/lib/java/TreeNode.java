class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
    TreeNode() {}
    TreeNode(int val) { this.val = val; }
    TreeNode(int val, TreeNode left, TreeNode right) { this.val = val; this.left = left; this.right = right; }

    static TreeNode fromArray(String input) {
        input = input.trim();
        if (input.equals("[]")) return null;
        String inner = input.substring(1, input.length() - 1);
        String[] tokens = inner.split(",");
        for (int i = 0; i < tokens.length; i++) tokens[i] = tokens[i].trim();
        if (tokens.length == 0 || tokens[0].equals("null")) return null;
        TreeNode root = new TreeNode(Integer.parseInt(tokens[0]));
        java.util.Queue<TreeNode> queue = new java.util.LinkedList<>();
        queue.add(root);
        int i = 1;
        while (!queue.isEmpty() && i < tokens.length) {
            TreeNode node = queue.poll();
            if (i < tokens.length && !tokens[i].equals("null")) {
                node.left = new TreeNode(Integer.parseInt(tokens[i]));
                queue.add(node.left);
            }
            i++;
            if (i < tokens.length && !tokens[i].equals("null")) {
                node.right = new TreeNode(Integer.parseInt(tokens[i]));
                queue.add(node.right);
            }
            i++;
        }
        return root;
    }

    static String toJsonArray(TreeNode root) {
        if (root == null) return "[]";
        java.util.List<String> parts = new java.util.ArrayList<>();
        java.util.Queue<TreeNode> queue = new java.util.LinkedList<>();
        queue.add(root);
        while (!queue.isEmpty()) {
            TreeNode node = queue.poll();
            if (node == null) {
                parts.add("null");
            } else {
                parts.add(String.valueOf(node.val));
                queue.add(node.left);
                queue.add(node.right);
            }
        }
        while (!parts.isEmpty() && parts.get(parts.size() - 1).equals("null")) {
            parts.remove(parts.size() - 1);
        }
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < parts.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(parts.get(i));
        }
        sb.append("]");
        return sb.toString();
    }
}
