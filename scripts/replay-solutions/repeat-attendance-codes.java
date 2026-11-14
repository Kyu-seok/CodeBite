class Solution {
    public List<Integer> listRepeatedCodes(int[] codes) {
        List<Integer> repeated = new ArrayList<>();
        for (int code : codes) {
            int index = Math.abs(code) - 1;
            if (codes[index] < 0) repeated.add(Math.abs(code));
            else codes[index] = -codes[index];
        }
        return repeated;
    }
}
