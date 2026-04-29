import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int numCourses = Integer.parseInt(sc.nextLine().trim());
        String line = sc.nextLine().trim();

        int[][] prerequisites;
        if (line.equals("[]")) {
            prerequisites = new int[0][];
        } else {
            String inner = line.substring(1, line.length() - 1);
            List<int[]> list = new ArrayList<>();
            int depth = 0;
            int start = 0;
            for (int i = 0; i < inner.length(); i++) {
                if (inner.charAt(i) == '[') { depth++; start = i; }
                else if (inner.charAt(i) == ']') {
                    depth--;
                    if (depth == 0) {
                        String pairStr = inner.substring(start + 1, i);
                        String[] parts = pairStr.split(",");
                        list.add(new int[]{Integer.parseInt(parts[0].trim()), Integer.parseInt(parts[1].trim())});
                    }
                }
            }
            prerequisites = list.toArray(new int[0][]);
        }

        int[] result = new Solution().sequenceAssemblySteps(numCourses, prerequisites);
        System.out.println(isValid(numCourses, prerequisites, result) ? "VALID" : "INVALID");
    }

    private static boolean isValid(int n, int[][] prereqs, int[] result) {
        if (result == null) return false;
        if (result.length == 0) return hasCycle(n, prereqs);
        if (result.length != n) return false;
        boolean[] seen = new boolean[n];
        int[] pos = new int[n];
        for (int i = 0; i < result.length; i++) {
            int v = result[i];
            if (v < 0 || v >= n || seen[v]) return false;
            seen[v] = true;
            pos[v] = i;
        }
        for (int[] e : prereqs) {
            if (pos[e[1]] >= pos[e[0]]) return false;
        }
        return true;
    }

    private static boolean hasCycle(int n, int[][] prereqs) {
        List<List<Integer>> adj = new ArrayList<>();
        int[] indeg = new int[n];
        for (int i = 0; i < n; i++) adj.add(new ArrayList<>());
        for (int[] e : prereqs) {
            adj.get(e[1]).add(e[0]);
            indeg[e[0]]++;
        }
        Deque<Integer> queue = new ArrayDeque<>();
        for (int i = 0; i < n; i++) if (indeg[i] == 0) queue.add(i);
        int processed = 0;
        while (!queue.isEmpty()) {
            int u = queue.poll();
            processed++;
            for (int v : adj.get(u)) {
                if (--indeg[v] == 0) queue.add(v);
            }
        }
        return processed != n;
    }
}
