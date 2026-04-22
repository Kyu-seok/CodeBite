import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String digits = sc.hasNextLine() ? sc.nextLine().trim() : "";
        List<String> result = new Solution().mapKeypadCodes(digits);
        Collections.sort(result);
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < result.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append("\"").append(result.get(i)).append("\"");
        }
        sb.append("]");
        System.out.println(sb.toString());
    }
}
