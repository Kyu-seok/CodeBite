import java.util.*;

class Solution {
    private static class Trie {
        final Map<Character, Trie> next = new HashMap<>();
        String word;
    }

    private final List<String> found = new ArrayList<>();
    private char[][] board;

    public List<String> findWords(char[][] board, String[] words) {
        this.board = board;
        Trie trie = new Trie();
        for (String word : words) {
            Trie node = trie;
            for (char letter : word.toCharArray()) {
                node = node.next.computeIfAbsent(letter, key -> new Trie());
            }
            node.word = word;
        }
        for (int r = 0; r < board.length; r++) {
            for (int c = 0; c < board[0].length; c++) {
                if (trie.next.containsKey(board[r][c])) search(r, c, trie);
            }
        }
        return found;
    }

    private void search(int r, int c, Trie parent) {
        char letter = board[r][c];
        Trie node = parent.next.get(letter);
        if (node.word != null) {
            found.add(node.word);
            node.word = null;
        }
        board[r][c] = '#';
        int[][] steps = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        for (int[] step : steps) {
            int nr = r + step[0], nc = c + step[1];
            if (nr >= 0 && nr < board.length && nc >= 0 && nc < board[0].length
                    && node.next.containsKey(board[nr][nc])) {
                search(nr, nc, node);
            }
        }
        board[r][c] = letter;
        if (node.next.isEmpty()) parent.next.remove(letter); // prune finished branches
    }
}
