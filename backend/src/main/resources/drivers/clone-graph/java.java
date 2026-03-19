import java.util.*;

// {{LIB:Node}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        Node node = Node.fromAdjList(line);
        Node cloned = new Solution().cloneGraph(node);
        System.out.println(Node.toAdjListJson(cloned));
    }
}
