import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int n = Integer.parseInt(sc.nextLine().trim());
        List<String> result = new Solution().fizzBuzz(n);
        System.out.println(JsonOutput.stringList(result));
    }
}
