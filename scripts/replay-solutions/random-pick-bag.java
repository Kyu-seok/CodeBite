import java.util.*;

class RandomBag {
    private final List<Integer> cards = new ArrayList<>();
    private final Map<Integer, Integer> where = new HashMap<>();
    private final Random random = new Random();

    public RandomBag() {
    }

    public boolean insert(int val) {
        if (where.containsKey(val)) return false;
        where.put(val, cards.size());
        cards.add(val);
        return true;
    }

    public boolean remove(int val) {
        if (!where.containsKey(val)) return false;
        int i = where.remove(val);
        int last = cards.remove(cards.size() - 1);
        if (last != val) {
            cards.set(i, last);
            where.put(last, i);
        }
        return true;
    }

    public int drawRandom() {
        return cards.get(random.nextInt(cards.size()));
    }
}
