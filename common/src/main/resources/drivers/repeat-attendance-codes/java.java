import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String codesLine = sc.nextLine().trim();
        String inner = codesLine.substring(1, codesLine.length() - 1);
        int[] codes;
        if (inner.isEmpty()) {
            codes = new int[0];
        } else {
            String[] parts = inner.split(",");
            codes = new int[parts.length];
            for (int i = 0; i < parts.length; i++) codes[i] = Integer.parseInt(parts[i].trim());
        }
        List<Integer> result = new Solution().listRepeatedCodes(codes);
        Collections.sort(result);
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < result.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(result.get(i));
        }
        sb.append("]");
        System.out.println(sb.toString());
    }
}
