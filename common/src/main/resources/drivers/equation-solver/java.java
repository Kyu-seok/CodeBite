import java.util.*;

{USER_CODE}

public class Main {
    private static List<List<String>> parse2DStringArray(String line) {
        List<List<String>> result = new ArrayList<>();
        line = line.trim();
        // Remove outer brackets
        line = line.substring(1, line.length() - 1);
        int i = 0;
        while (i < line.length()) {
            if (line.charAt(i) == '[') {
                int j = line.indexOf(']', i);
                String inner = line.substring(i + 1, j);
                List<String> pair = new ArrayList<>();
                for (String s : inner.split(",")) {
                    s = s.trim();
                    if (s.startsWith("\"")) s = s.substring(1);
                    if (s.endsWith("\"")) s = s.substring(0, s.length() - 1);
                    pair.add(s);
                }
                result.add(pair);
                i = j + 1;
            } else {
                i++;
            }
        }
        return result;
    }

    private static double[] parseDoubleArray(String line) {
        line = line.trim();
        String inner = line.substring(1, line.length() - 1);
        String[] parts = inner.split(",");
        double[] arr = new double[parts.length];
        for (int i = 0; i < parts.length; i++) {
            arr[i] = Double.parseDouble(parts[i].trim());
        }
        return arr;
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String eqLine = sc.nextLine().trim();
        String valLine = sc.nextLine().trim();
        String qLine = sc.nextLine().trim();

        List<List<String>> equations = parse2DStringArray(eqLine);
        double[] values = parseDoubleArray(valLine);
        List<List<String>> queries = parse2DStringArray(qLine);

        double[] result = new Solution().calcEquation(equations, values, queries);

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < result.length; i++) {
            if (i > 0) sb.append(",");
            sb.append(String.format("%.5f", result[i]));
        }
        sb.append("]");
        System.out.println(sb.toString());
    }
}
