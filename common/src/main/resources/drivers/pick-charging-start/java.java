import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String energyLine = sc.nextLine().trim();
        String drainLine = sc.nextLine().trim();
        String ei = energyLine.substring(1, energyLine.length() - 1);
        String di = drainLine.substring(1, drainLine.length() - 1);
        String[] ep = ei.split(",");
        String[] dp = di.split(",");
        int[] energy = new int[ep.length];
        int[] drain = new int[dp.length];
        for (int i = 0; i < ep.length; i++) energy[i] = Integer.parseInt(ep[i].trim());
        for (int i = 0; i < dp.length; i++) drain[i] = Integer.parseInt(dp[i].trim());
        int result = new Solution().pickStartStop(energy, drain);
        System.out.println(result);
    }
}
