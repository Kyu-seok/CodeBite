import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String cardsLine = sc.nextLine().trim();
        int groupSize = Integer.parseInt(sc.nextLine().trim());
        String inner = cardsLine.substring(1, cardsLine.length() - 1);
        String[] parts = inner.split(",");
        int[] cards = new int[parts.length];
        for (int i = 0; i < parts.length; i++) cards[i] = Integer.parseInt(parts[i].trim());
        boolean result = new Solution().canGroupCards(cards, groupSize);
        System.out.println(result);
    }
}
