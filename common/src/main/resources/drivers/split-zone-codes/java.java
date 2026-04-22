import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String s = sc.nextLine().trim();
        List<String> result = new Solution().splitZoneCodes(s);
        Collections.sort(result);
        System.out.println(JsonOutput.stringList(result));
    }
}
