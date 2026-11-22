import java.util.*;

{USER_CODE}

// {{LIB:JsonOutput}}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String digits = sc.nextLine().trim();
        List<String> result = new Solution().restoreIpAddresses(digits);
        Collections.sort(result);
        System.out.println(JsonOutput.stringList(result));
    }
}
