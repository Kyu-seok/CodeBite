class Solution {
    public List<Integer> splitStickerRuns(String stickers) {
        int[] last = new int[26];
        for (int i = 0; i < stickers.length(); i++) last[stickers.charAt(i) - 'a'] = i;
        List<Integer> sizes = new ArrayList<>();
        int start = 0, end = 0;
        for (int i = 0; i < stickers.length(); i++) {
            end = Math.max(end, last[stickers.charAt(i) - 'a']);
            if (i == end) { // every letter seen in this run has finished
                sizes.add(end - start + 1);
                start = i + 1;
            }
        }
        return sizes;
    }
}
