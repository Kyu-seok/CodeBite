import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        int target = Integer.parseInt(sc.nextLine().trim());
        String inner = line.substring(1, line.length() - 1);
        int[] candidates;
        if (inner.isEmpty()) {
            candidates = new int[0];
        } else {
            String[] parts = inner.split(",");
            candidates = new int[parts.length];
            for (int i = 0; i < parts.length; i++) candidates[i] = Integer.parseInt(parts[i].trim());
        }
        List<List<Integer>> result = new Solution().listQuotaBatches(candidates, target);
        for (List<Integer> combo : result) Collections.sort(combo);
        result.sort((a, b) -> {
            for (int i = 0; i < Math.min(a.size(), b.size()); i++) {
                int cmp = Integer.compare(a.get(i), b.get(i));
                if (cmp != 0) return cmp;
            }
            return a.size() - b.size();
        });
        System.out.println(JsonOutput.intList2D(result));
    }
}
