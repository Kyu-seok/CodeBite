import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String jobsLine = sc.nextLine().trim();
        int n = Integer.parseInt(sc.nextLine().trim());
        // Parse ["A","A","B"] -> char[]
        String inner = jobsLine.substring(1, jobsLine.length() - 1);
        String[] parts = inner.split(",");
        char[] jobs = new char[parts.length];
        for (int i = 0; i < parts.length; i++) {
            String s = parts[i].trim();
            jobs[i] = s.charAt(1); // strip quotes
        }
        int result = new Solution().planStationRuns(jobs, n);
        System.out.println(result);
    }
}
