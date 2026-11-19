import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String volumesLine = sc.nextLine().trim();
        int days = Integer.parseInt(sc.nextLine().trim());
        String inner = volumesLine.substring(1, volumesLine.length() - 1);
        String[] parts = inner.split(",");
        int[] volumes = new int[parts.length];
        for (int i = 0; i < parts.length; i++) volumes[i] = Integer.parseInt(parts[i].trim());
        int result = new Solution().minDailyCapacity(volumes, days);
        System.out.println(result);
    }
}
