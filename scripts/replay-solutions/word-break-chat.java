class Solution {
    public boolean canSplitMessage(String message, List<String> words) {
        Set<String> known = new HashSet<>(words);
        boolean[] splittable = new boolean[message.length() + 1];
        splittable[0] = true;
        for (int end = 1; end <= message.length(); end++) {
            for (String word : known) {
                int start = end - word.length();
                if (start >= 0 && splittable[start] && message.startsWith(word, start)) {
                    splittable[end] = true;
                    break;
                }
            }
        }
        return splittable[message.length()];
    }
}
