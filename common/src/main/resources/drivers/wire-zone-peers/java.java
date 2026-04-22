import java.util.*;

class Node {
    public int val;
    public Node left;
    public Node right;
    public Node next;

    public Node() {}
    public Node(int val) { this.val = val; }
    public Node(int val, Node left, Node right, Node next) {
        this.val = val;
        this.left = left;
        this.right = right;
        this.next = next;
    }
}

{USER_CODE}

public class Main {
    static Node buildTree(String input) {
        input = input.trim();
        if (input.equals("[]")) return null;
        String inner = input.substring(1, input.length() - 1);
        String[] tokens = inner.split(",");
        for (int i = 0; i < tokens.length; i++) tokens[i] = tokens[i].trim();
        if (tokens.length == 0 || tokens[0].equals("null")) return null;
        Node root = new Node(Integer.parseInt(tokens[0]));
        Queue<Node> queue = new LinkedList<>();
        queue.add(root);
        int i = 1;
        while (!queue.isEmpty() && i < tokens.length) {
            Node node = queue.poll();
            if (i < tokens.length && !tokens[i].equals("null")) {
                node.left = new Node(Integer.parseInt(tokens[i]));
                queue.add(node.left);
            }
            i++;
            if (i < tokens.length && !tokens[i].equals("null")) {
                node.right = new Node(Integer.parseInt(tokens[i]));
                queue.add(node.right);
            }
            i++;
        }
        return root;
    }

    static String serialize(Node root) {
        if (root == null) return "[]";
        StringBuilder sb = new StringBuilder("[");
        Node levelStart = root;
        while (levelStart != null) {
            Node curr = levelStart;
            while (curr != null) {
                if (sb.length() > 1) sb.append(",");
                sb.append(curr.val);
                curr = curr.next;
            }
            sb.append(",#");
            levelStart = levelStart.left;
        }
        sb.append("]");
        return sb.toString();
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        Node root = buildTree(line);
        Node result = new Solution().wireSiblingHubs(root);
        System.out.println(serialize(result));
    }
}
