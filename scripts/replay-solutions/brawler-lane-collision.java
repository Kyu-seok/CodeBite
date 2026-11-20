class Solution {
    public int[] resolveLaneCrashes(int[] fighters) {
        int[] standing = new int[fighters.length];
        int size = 0;
        for (int fighter : fighters) {
            boolean alive = true;
            while (alive && fighter < 0 && size > 0 && standing[size - 1] > 0) {
                if (standing[size - 1] < -fighter) {
                    size--;
                } else if (standing[size - 1] == -fighter) {
                    size--;
                    alive = false;
                } else {
                    alive = false;
                }
            }
            if (alive) standing[size++] = fighter;
        }
        return Arrays.copyOf(standing, size);
    }
}
