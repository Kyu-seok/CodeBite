import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        // Parse ["hello","world"]
        String inner = line.substring(1, line.length() - 1);
        List<String> strs = new ArrayList<>();
        if (!inner.isEmpty()) {
            String[] parts = inner.split(",");
            for (String part : parts) strs.add(part.trim().replaceAll("\"", ""));
        }
        Codec codec = new Codec();
        String encoded = codec.encode(strs);
        List<String> result = codec.decode(encoded);
        System.out.println(JsonOutput.stringList(result));
    }
}
