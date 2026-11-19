class WildcardLexicon {
    private final java.util.Set<String> words = new java.util.HashSet<>();

    public WildcardLexicon() {
    }

    public void enroll(String word) {
        words.add(word);
    }

    public boolean match(String word) {
        for (String saved : words) {
            if (saved.length() != word.length()) continue;
            boolean fits = true;
            for (int i = 0; i < word.length() && fits; i++) {
                fits = word.charAt(i) == '.' || word.charAt(i) == saved.charAt(i);
            }
            if (fits) return true;
        }
        return false;
    }
}
