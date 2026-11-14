class Solution {
    public boolean canFinishAllTasks(int numTasks, int[][] prereqs) {
        List<List<Integer>> unlocks = new ArrayList<>();
        for (int i = 0; i < numTasks; i++) unlocks.add(new ArrayList<>());
        int[] waiting = new int[numTasks];
        for (int[] p : prereqs) {
            unlocks.get(p[1]).add(p[0]);
            waiting[p[0]]++;
        }
        Deque<Integer> ready = new ArrayDeque<>();
        for (int i = 0; i < numTasks; i++) if (waiting[i] == 0) ready.add(i);
        int done = 0;
        while (!ready.isEmpty()) {
            int task = ready.poll();
            done++;
            for (int next : unlocks.get(task)) {
                if (--waiting[next] == 0) ready.add(next);
            }
        }
        return done == numTasks;
    }
}
