class Solution {
    public boolean detectClash(int[] lockers) {
        Set<Integer> seen = new HashSet<>();
        for (int number : lockers) {
            if (!seen.add(number)) return true;
        }
        return false;
    }
}
