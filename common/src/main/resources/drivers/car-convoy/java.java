import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int target = Integer.parseInt(sc.nextLine().trim());
        String posLine = sc.nextLine().trim();
        String spdLine = sc.nextLine().trim();
        String posInner = posLine.substring(1, posLine.length() - 1);
        String spdInner = spdLine.substring(1, spdLine.length() - 1);
        String[] posParts = posInner.split(",");
        String[] spdParts = spdInner.split(",");
        int[] position = new int[posParts.length];
        int[] speed = new int[spdParts.length];
        for (int i = 0; i < posParts.length; i++) position[i] = Integer.parseInt(posParts[i].trim());
        for (int i = 0; i < spdParts.length; i++) speed[i] = Integer.parseInt(spdParts[i].trim());
        int result = new Solution().carConvoy(target, position, speed);
        System.out.println(result);
    }
}
