import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String numsLine = sc.nextLine().trim();
        String inner = numsLine.substring(1, numsLine.length() - 1);
        String[] parts = inner.split(",");
        int[] nums = new int[parts.length];
        for (int i = 0; i < parts.length; i++) nums[i] = Integer.parseInt(parts[i].trim());
        int result = new Solution().pinpointPeak(nums.clone());
        System.out.println(isReturnedPeak(nums, result) ? "VALID" : "INVALID:" + result);
    }

    private static boolean isReturnedPeak(int[] readings, int i) {
        int n = readings.length;
        if (i < 0 || i >= n) return false;
        return (i == 0 || readings[i] > readings[i - 1]) && (i == n - 1 || readings[i] > readings[i + 1]);
    }
}
