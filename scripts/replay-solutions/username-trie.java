class PrefixIndex {
    private final PrefixIndex[] next = new PrefixIndex[26];
    private boolean word;

    public PrefixIndex() {
    }

    public void insert(String word) {
        PrefixIndex node = this;
        for (char c : word.toCharArray()) {
            if (node.next[c - 'a'] == null) node.next[c - 'a'] = new PrefixIndex();
            node = node.next[c - 'a'];
        }
        node.word = true;
    }

    public boolean search(String word) {
        PrefixIndex node = find(word);
        return node != null && node.word;
    }

    public boolean startsWith(String prefix) {
        return find(prefix) != null;
    }

    private PrefixIndex find(String s) {
        PrefixIndex node = this;
        for (char c : s.toCharArray()) {
            node = node.next[c - 'a'];
            if (node == null) return null;
        }
        return node;
    }
}
