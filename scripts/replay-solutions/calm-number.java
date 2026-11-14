class Solution {
    public boolean isCalm(int reading) {
        Set<Integer> seen = new HashSet<>();
        while (reading != 1 && seen.add(reading)) {
            int next = 0;
            for (int x = reading; x > 0; x /= 10) next += (x % 10) * (x % 10);
            reading = next;
        }
        return reading == 1;
    }
}
