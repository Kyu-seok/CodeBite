class Solution {
    public double[] resolvePriceRatios(List<List<String>> ratios, double[] values, List<List<String>> queries) {
        Map<String, Map<String, Double>> graph = new HashMap<>();
        for (int i = 0; i < ratios.size(); i++) {
            String a = ratios.get(i).get(0), b = ratios.get(i).get(1);
            graph.computeIfAbsent(a, k -> new HashMap<>()).put(b, values[i]);
            graph.computeIfAbsent(b, k -> new HashMap<>()).put(a, 1.0 / values[i]);
        }
        double[] out = new double[queries.size()];
        for (int q = 0; q < queries.size(); q++) {
            String from = queries.get(q).get(0), to = queries.get(q).get(1);
            out[q] = -1.0;
            if (!graph.containsKey(from) || !graph.containsKey(to)) continue;
            Map<String, Double> seen = new HashMap<>();
            Deque<String> stack = new ArrayDeque<>();
            seen.put(from, 1.0);
            stack.push(from);
            while (!stack.isEmpty()) {
                String item = stack.pop();
                if (item.equals(to)) { out[q] = seen.get(item); break; }
                for (Map.Entry<String, Double> e : graph.get(item).entrySet()) {
                    if (!seen.containsKey(e.getKey())) {
                        seen.put(e.getKey(), seen.get(item) * e.getValue());
                        stack.push(e.getKey());
                    }
                }
            }
        }
        return out;
    }
}
