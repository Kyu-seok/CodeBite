import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line1 = sc.nextLine().trim();
        String line2 = sc.nextLine().trim();
        int[] nums1 = parseIntArray(line1);
        int[] nums2 = parseIntArray(line2);
        double result = new Solution().mergedZoneMedian(nums1, nums2);
        if (result == (long) result) {
            System.out.println(String.format("%.1f", result));
        } else {
            System.out.println(String.format("%.1f", result));
        }
    }

    private static int[] parseIntArray(String s) {
        String inner = s.substring(1, s.length() - 1).trim();
        if (inner.isEmpty()) return new int[0];
        String[] parts = inner.split(",");
        int[] arr = new int[parts.length];
        for (int i = 0; i < parts.length; i++) arr[i] = Integer.parseInt(parts[i].trim());
        return arr;
    }
}
