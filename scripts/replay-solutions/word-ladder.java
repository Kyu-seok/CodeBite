import java.util.*;

class Solution {
    public int ladderLength(String beginWord, String endWord, List<String> wordList) {
        Set<String> unvisited = new HashSet<>(wordList);
        if (!unvisited.contains(endWord)) return 0;
        unvisited.remove(beginWord);
        Deque<String> queue = new ArrayDeque<>();
        queue.add(beginWord);
        int length = 1;
        while (!queue.isEmpty()) {
            for (int remaining = queue.size(); remaining > 0; remaining--) {
                char[] letters = queue.poll().toCharArray();
                for (int i = 0; i < letters.length; i++) {
                    char original = letters[i];
                    for (char letter = 'a'; letter <= 'z'; letter++) {
                        letters[i] = letter;
                        String candidate = new String(letters);
                        if (unvisited.remove(candidate)) {
                            if (candidate.equals(endWord)) return length + 1;
                            queue.add(candidate);
                        }
                    }
                    letters[i] = original;
                }
            }
            length++;
        }
        return 0;
    }
}
