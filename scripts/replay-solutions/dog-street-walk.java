class Solution {
    public List<String> planWalk(List<List<String>> routes) {
        Map<String, PriorityQueue<String>> outgoing = new HashMap<>();
        for (List<String> r : routes) {
            outgoing.computeIfAbsent(r.get(0), k -> new PriorityQueue<>()).add(r.get(1));
        }
        LinkedList<String> walk = new LinkedList<>();
        Deque<String> stack = new ArrayDeque<>();
        stack.push("HUB");
        while (!stack.isEmpty()) {
            PriorityQueue<String> next = outgoing.get(stack.peek());
            if (next != null && !next.isEmpty()) {
                stack.push(next.poll());
            } else {
                walk.addFirst(stack.pop());
            }
        }
        return walk;
    }
}
