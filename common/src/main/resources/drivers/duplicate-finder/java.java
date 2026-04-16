import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String numsLine = sc.nextLine().trim();
        String inner = numsLine.substring(1, numsLine.length() - 1);
        int[] nums;
        if (inner.isEmpty()) {
            nums = new int[0];
        } else {
            String[] parts = inner.split(",");
            nums = new int[parts.length];
            for (int i = 0; i < parts.length; i++) nums[i] = Integer.parseInt(parts[i].trim());
        }
        List<Integer> result = new Solution().findDuplicates(nums);
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
