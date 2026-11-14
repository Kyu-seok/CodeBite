class Solution {
    public List<String> restoreIpAddresses(String digits) {
        List<String> addresses = new ArrayList<>();
        int len = digits.length();
        for (int a = 1; a <= 3; a++)
            for (int b = a + 1; b <= a + 3; b++)
                for (int c = b + 1; c <= b + 3; c++) {
                    if (c >= len) continue;
                    String[] parts = {digits.substring(0, a), digits.substring(a, b), digits.substring(b, c), digits.substring(c)};
                    boolean ok = true;
                    for (String part : parts) ok &= valid(part);
                    if (ok) addresses.add(String.join(".", parts));
                }
        return addresses;
    }

    private boolean valid(String segment) {
        if (segment.isEmpty() || segment.length() > 3) return false;
        if (segment.length() > 1 && segment.charAt(0) == '0') return false;
        return Integer.parseInt(segment) <= 255;
    }
}
