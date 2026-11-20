class Solution {
    private final Map<String, String> parent = new LinkedHashMap<>();

    public List<List<String>> unifyContactIdentities(List<List<String>> accounts) {
        Map<String, String> owner = new HashMap<>();
        for (List<String> account : accounts) {
            String first = account.get(1);
            for (String email : account.subList(1, account.size())) {
                parent.putIfAbsent(email, email);
                owner.put(email, account.get(0));
                parent.put(find(email), find(first));
            }
        }
        Map<String, List<String>> groups = new LinkedHashMap<>();
        for (String email : parent.keySet()) {
            groups.computeIfAbsent(find(email), root -> new ArrayList<>()).add(email);
        }
        List<List<String>> merged = new ArrayList<>();
        for (Map.Entry<String, List<String>> group : groups.entrySet()) {
            List<String> emails = group.getValue();
            Collections.sort(emails);
            List<String> contact = new ArrayList<>();
            contact.add(owner.get(group.getKey()));
            contact.addAll(emails);
            merged.add(contact);
        }
        return merged;
    }

    // No path compression: it would write to the map while the caller walks its keys.
    private String find(String email) {
        while (!parent.get(email).equals(email)) {
            email = parent.get(email);
        }
        return email;
    }
}
