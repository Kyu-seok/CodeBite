import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String gasLine = sc.nextLine().trim();
        String costLine = sc.nextLine().trim();
        String gi = gasLine.substring(1, gasLine.length() - 1);
        String ci = costLine.substring(1, costLine.length() - 1);
        String[] gp = gi.split(",");
        String[] cp = ci.split(",");
        int[] gas = new int[gp.length];
        int[] cost = new int[cp.length];
        for (int i = 0; i < gp.length; i++) gas[i] = Integer.parseInt(gp[i].trim());
        for (int i = 0; i < cp.length; i++) cost[i] = Integer.parseInt(cp[i].trim());
        int result = new Solution().pickStartStation(gas, cost);
        System.out.println(result);
    }
}
