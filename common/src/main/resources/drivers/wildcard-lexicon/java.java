import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String cmdsLine = sc.nextLine().trim();
        String argsLine = sc.nextLine().trim();

        cmdsLine = cmdsLine.substring(1, cmdsLine.length() - 1);
        List<String> cmds = new ArrayList<>();
        for (String s : cmdsLine.split(",")) {
            cmds.add(s.trim().replace("\"", ""));
        }

        argsLine = argsLine.substring(1, argsLine.length() - 1);
        List<String> argsList = new ArrayList<>();
        int depth = 0;
        int start = 0;
        for (int i = 0; i < argsLine.length(); i++) {
            if (argsLine.charAt(i) == '[') depth++;
            else if (argsLine.charAt(i) == ']') depth--;
            else if (argsLine.charAt(i) == ',' && depth == 0) {
                argsList.add(argsLine.substring(start, i).trim());
                start = i + 1;
            }
        }
        argsList.add(argsLine.substring(start).trim());

        WildcardLexicon dict = null;
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < cmds.size(); i++) {
            if (i > 0) sb.append(",");
            String cmd = cmds.get(i);
            String arg = argsList.get(i);
            String word = "";
            if (!arg.equals("[]")) {
                word = arg.substring(1, arg.length() - 1).replace("\"", "");
            }

            if (cmd.equals("WildcardLexicon")) {
                dict = new WildcardLexicon();
                sb.append("null");
            } else if (cmd.equals("enroll")) {
                dict.enroll(word);
                sb.append("null");
            } else if (cmd.equals("match")) {
                sb.append(dict.match(word));
            }
        }
        sb.append("]");
        System.out.println(sb.toString());
    }
}
