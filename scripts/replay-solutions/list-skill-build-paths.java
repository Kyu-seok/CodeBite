class Solution {
    public List<List<Integer>> listBuildPaths(TreeNode root, int target) {
        List<List<Integer>> paths = new ArrayList<>();
        walk(root, target, new ArrayList<>(), paths);
        return paths;
    }

    private void walk(TreeNode node, int remaining, List<Integer> path, List<List<Integer>> paths) {
        if (node == null) return;
        path.add(node.val);
        remaining -= node.val;
        if (node.left == null && node.right == null) {
            if (remaining == 0) paths.add(new ArrayList<>(path));
        } else {
            walk(node.left, remaining, path, paths);
            walk(node.right, remaining, path, paths);
        }
        path.remove(path.size() - 1);
    }
}
