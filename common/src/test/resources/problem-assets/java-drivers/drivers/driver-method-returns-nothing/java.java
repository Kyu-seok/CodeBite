import java.util.*;

{USER_CODE}

// {{LIB:Printer}}

public class Main {
    static int readCount() {
        new Scanner(System.in).nextInt();
    }

    public static void main(String[] args) {
        System.out.println(Printer.list(new Solution().names(readCount())));
    }
}
