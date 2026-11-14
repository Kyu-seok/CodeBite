class Solution {
    public int[] busiestMachines(int[] checkIns, int k) {
        Map<Integer, Integer> counts = new HashMap<>();
        for (int machine : checkIns) counts.merge(machine, 1, Integer::sum);
        List<Integer> machines = new ArrayList<>(counts.keySet());
        machines.sort((a, b) -> counts.get(b) - counts.get(a));
        int[] top = new int[k];
        for (int i = 0; i < k; i++) top[i] = machines.get(i);
        return top;
    }
}
