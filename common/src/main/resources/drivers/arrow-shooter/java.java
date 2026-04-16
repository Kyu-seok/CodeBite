import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();

        String inner = line.substring(1, line.length() - 1);
        List<int[]> list = new ArrayList<>();
        int depth = 0, start = 0;
        for (int i = 0; i < inner.length(); i++) {
            if (inner.charAt(i) == '[') { depth++; start = i; }
            else if (inner.charAt(i) == ']') {
                depth--;
                if (depth == 0) {
                    String p = inner.substring(start + 1, i);
                    String[] parts = p.split(",");
                    list.add(new int[]{(int)Long.parseLong(parts[0].trim()), (int)Long.parseLong(parts[1].trim())});
                }
            }
        }
        int[][] targets = list.toArray(new int[0][]);
        int result = new Solution().findMinArrows(targets);
        System.out.println(result);
    }
}
