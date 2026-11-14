import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String stickers = sc.nextLine().trim();
        List<Integer> result = new Solution().splitStickerRuns(stickers);
        int[] arr = result.stream().mapToInt(Integer::intValue).toArray();
        System.out.println(JsonOutput.intArray(arr));
    }
}
