import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String numsLine = sc.nextLine().trim();
        int target = Integer.parseInt(sc.nextLine().trim());
        String inner = numsLine.substring(1, numsLine.length() - 1);
        String[] parts = inner.split(",");
        int[] nums = new int[parts.length];
        for (int i = 0; i < parts.length; i++) nums[i] = Integer.parseInt(parts[i].trim());
        int[] result = new Solution().findPairIndices(nums, target);
        if (result != null && result.length == 2 && result[0] > result[1]) {
            int tmp = result[0]; result[0] = result[1]; result[1] = tmp;
        }
        System.out.println(JsonOutput.intArray(result));
    }
}
