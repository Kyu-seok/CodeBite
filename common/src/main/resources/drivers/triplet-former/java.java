import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String tripletsLine = sc.nextLine().trim();
        String targetLine = sc.nextLine().trim();
        // Parse 2D array [[a,b,c],[d,e,f],...]
        List<int[]> list = new ArrayList<>();
        int i = 0;
        while (i < tripletsLine.length()) {
            if (tripletsLine.charAt(i) == '[' && i > 0) {
                int j = tripletsLine.indexOf(']', i);
                String sub = tripletsLine.substring(i + 1, j);
                String[] parts = sub.split(",");
                int[] row = new int[parts.length];
                for (int k = 0; k < parts.length; k++) row[k] = Integer.parseInt(parts[k].trim());
                list.add(row);
                i = j + 1;
            } else {
                i++;
            }
        }
        int[][] triplets = list.toArray(new int[0][]);
        // Parse target [x,y,z]
        String inner = targetLine.substring(1, targetLine.length() - 1);
        String[] tParts = inner.split(",");
        int[] target = new int[tParts.length];
        for (int k = 0; k < tParts.length; k++) target[k] = Integer.parseInt(tParts[k].trim());
        boolean result = new Solution().canFormTarget(triplets, target);
        System.out.println(result);
    }
}
