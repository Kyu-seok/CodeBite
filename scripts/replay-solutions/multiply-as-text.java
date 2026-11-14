class Solution {
    public String productAsText(String left, String right) {
        int[] digits = new int[left.length() + right.length()];
        for (int i = left.length() - 1; i >= 0; i--) {
            for (int j = right.length() - 1; j >= 0; j--) {
                int sum = digits[i + j + 1] + (left.charAt(i) - '0') * (right.charAt(j) - '0');
                digits[i + j + 1] = sum % 10;
                digits[i + j] += sum / 10;
            }
        }
        StringBuilder out = new StringBuilder();
        for (int d : digits) if (out.length() > 0 || d != 0) out.append(d);
        return out.length() == 0 ? "0" : out.toString();
    }
}
