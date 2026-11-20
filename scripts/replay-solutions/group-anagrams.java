class Solution {
    public List<List<String>> groupAnagrams(String[] strs) {
        Map<String, List<String>> groups = new LinkedHashMap<>();
        for (String word : strs) {
            char[] letters = word.toCharArray();
            Arrays.sort(letters);
            groups.computeIfAbsent(new String(letters), key -> new ArrayList<>()).add(word);
        }
        return new ArrayList<>(groups.values());
    }
}
