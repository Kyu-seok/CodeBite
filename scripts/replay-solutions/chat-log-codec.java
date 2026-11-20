class ListCoder {
    public String pack(List<String> messages) {
        StringBuilder blob = new StringBuilder();
        for (String message : messages) {
            blob.append(message.length()).append('#').append(message);
        }
        return blob.toString();
    }

    public List<String> unpack(String blob) {
        List<String> messages = new ArrayList<>();
        int i = 0;
        while (i < blob.length()) {
            int hashAt = blob.indexOf('#', i);
            int length = Integer.parseInt(blob.substring(i, hashAt));
            int start = hashAt + 1;
            messages.add(blob.substring(start, start + length));
            i = start + length;
        }
        return messages;
    }
}
