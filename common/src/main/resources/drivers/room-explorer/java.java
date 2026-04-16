import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        // Parse 2D int array [[1],[2],[3],[]]
        List<List<Integer>> rooms = new ArrayList<>();
        String inner = line.substring(1, line.length() - 1);
        int i = 0;
        while (i < inner.length()) {
            if (inner.charAt(i) == '[') {
                int j = inner.indexOf(']', i);
                String content = inner.substring(i + 1, j);
                List<Integer> room = new ArrayList<>();
                if (!content.isEmpty()) {
                    for (String s : content.split(",")) {
                        room.add(Integer.parseInt(s.trim()));
                    }
                }
                rooms.add(room);
                i = j + 1;
            } else {
                i++;
            }
        }
        boolean result = new Solution().canVisitAllRooms(rooms);
        System.out.println(result);
    }
}
