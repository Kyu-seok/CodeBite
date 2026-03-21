import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int numRows = Integer.parseInt(sc.nextLine().trim());
        List<List<Integer>> result = new Solution().generate(numRows);
        System.out.println(JsonOutput.intList2D(result));
    }
}
