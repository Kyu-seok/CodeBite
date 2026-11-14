
class Codec {
    public String serialize(TreeNode root) {
        StringBuilder sb = new StringBuilder();
        write(root, sb);
        return sb.toString();
    }

    private void write(TreeNode node, StringBuilder sb) {
        if (node == null) { sb.append("#,"); return; }
        sb.append(node.val).append(',');
        write(node.left, sb);
        write(node.right, sb);
    }

    public TreeNode deserialize(String data) {
        Deque<String> tokens = new ArrayDeque<>(Arrays.asList(data.split(",")));
        return read(tokens);
    }

    private TreeNode read(Deque<String> tokens) {
        String t = tokens.poll();
        if (t == null || t.equals("#")) return null;
        TreeNode node = new TreeNode(Integer.parseInt(t));
        node.left = read(tokens);
        node.right = read(tokens);
        return node;
    }
}
