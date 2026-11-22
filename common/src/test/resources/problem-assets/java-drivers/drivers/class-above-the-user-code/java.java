import java.util.*;

class Names {
    static String list(List<String> names) {
        return String.join(",", names);
    }
}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        int n = new Scanner(System.in).nextInt();
        System.out.println(Names.list(new Solution().names(n)));
    }
}
