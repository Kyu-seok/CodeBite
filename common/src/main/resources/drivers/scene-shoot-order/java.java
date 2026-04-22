import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        // Parse ["wrt","wrf","er","ett","rftt"]
        String inner = line.substring(1, line.length() - 1);
        List<String> words = new ArrayList<>();
        if (!inner.isEmpty()) {
            int i = 0;
            while (i < inner.length()) {
                if (inner.charAt(i) == '"') {
                    int j = inner.indexOf('"', i + 1);
                    words.add(inner.substring(i + 1, j));
                    i = j + 1;
                } else {
                    i++;
                }
            }
        }
        String result = new Solution().orderSceneShoot(words.toArray(new String[0]));
        System.out.println(result);
    }
}
