import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        String inner = line.substring(1, line.length() - 1);
        String[] parts = inner.split(",");
        char[] s = new char[parts.length];
        for (int i = 0; i < parts.length; i++) s[i] = parts[i].trim().charAt(1);
        new Solution().reverseString(s);
        System.out.println(JsonOutput.charArray(s));
    }
}
