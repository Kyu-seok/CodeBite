class Solution {
    private final List<List<String>> splits = new ArrayList<>();
    private final List<String> pieces = new ArrayList<>();
    private String menu;

    public List<List<String>> splitMirrorPhrases(String menu) {
        this.menu = menu;
        splitFrom(0);
        return splits;
    }

    private void splitFrom(int start) {
        if (start == menu.length()) {
            splits.add(new ArrayList<>(pieces));
            return;
        }
        for (int end = start + 1; end <= menu.length(); end++) {
            if (isPalindrome(start, end - 1)) {
                pieces.add(menu.substring(start, end));
                splitFrom(end);
                pieces.remove(pieces.size() - 1);
            }
        }
    }

    private boolean isPalindrome(int left, int right) {
        while (left < right) {
            if (menu.charAt(left++) != menu.charAt(right--)) return false;
        }
        return true;
    }
}
