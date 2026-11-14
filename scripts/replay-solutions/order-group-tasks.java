class Solution {
    public int[] findTaskOrder(int numTasks, int[][] prereqs) {
        java.util.List<java.util.List<Integer>> unlocks = new java.util.ArrayList<>();
        for (int i = 0; i < numTasks; i++) unlocks.add(new java.util.ArrayList<>());
        int[] waiting = new int[numTasks];
        for (int[] p : prereqs) {
            unlocks.get(p[1]).add(p[0]);
            waiting[p[0]]++;
        }
        java.util.ArrayDeque<Integer> ready = new java.util.ArrayDeque<>();
        for (int t = 0; t < numTasks; t++) if (waiting[t] == 0) ready.add(t);
        int[] order = new int[numTasks];
        int done = 0;
        while (!ready.isEmpty()) {
            int task = ready.poll();
            order[done++] = task;
            for (int next : unlocks.get(task)) {
                if (--waiting[next] == 0) ready.add(next);
            }
        }
        return done == numTasks ? order : new int[0];
    }
}
