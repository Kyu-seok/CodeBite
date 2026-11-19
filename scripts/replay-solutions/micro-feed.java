import java.util.*;

class MicroFeed {
    private int clock = 0;
    private final Map<Integer, List<int[]>> posts = new HashMap<>();
    private final Map<Integer, Set<Integer>> following = new HashMap<>();

    public MicroFeed() {}

    public void publishPost(int userId, int messageId) {
        posts.computeIfAbsent(userId, k -> new ArrayList<>()).add(new int[]{clock++, messageId});
    }

    public List<Integer> latestFeed(int userId) {
        Set<Integer> authors = new HashSet<>(following.getOrDefault(userId, Collections.emptySet()));
        authors.add(userId);
        List<int[]> all = new ArrayList<>();
        for (int author : authors) all.addAll(posts.getOrDefault(author, Collections.emptyList()));
        all.sort((a, b) -> b[0] - a[0]);
        List<Integer> feed = new ArrayList<>();
        for (int i = 0; i < Math.min(10, all.size()); i++) feed.add(all.get(i)[1]);
        return feed;
    }

    public void subscribe(int followerId, int followeeId) {
        if (followerId != followeeId) following.computeIfAbsent(followerId, k -> new HashSet<>()).add(followeeId);
    }

    public void unsubscribe(int followerId, int followeeId) {
        Set<Integer> set = following.get(followerId);
        if (set != null) set.remove(followeeId);
    }
}
