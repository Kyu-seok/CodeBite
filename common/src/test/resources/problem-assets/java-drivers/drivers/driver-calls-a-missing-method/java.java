import java.util.*;

{USER_CODE}

// {{LIB:Printer}}

public class Main {
    public static void main(String[] args) {
        List<String> ops = new ArrayList<>();
        ops.record("names");
        System.out.println(Printer.list(new Solution().names(ops.size())));
    }
}
