import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String numsLine = sc.nextLine().trim();
        String inner = numsLine.substring(1, numsLine.length() - 1);
        int[] seatIds;
        if (inner.isEmpty()) {
            seatIds = new int[0];
        } else {
            String[] parts = inner.split(",");
            seatIds = new int[parts.length];
            for (int i = 0; i < parts.length; i++) seatIds[i] = Integer.parseInt(parts[i].trim());
        }
        int result = new Solution().longestSeatRun(seatIds);
        System.out.println(result);
    }
}
