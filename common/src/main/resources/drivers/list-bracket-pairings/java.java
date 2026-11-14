import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int pairCount = Integer.parseInt(sc.nextLine().trim());
        List<String> result = new Solution().listBracketPairings(pairCount);
        Collections.sort(result);
        System.out.println(JsonOutput.stringList(result));
    }
}
