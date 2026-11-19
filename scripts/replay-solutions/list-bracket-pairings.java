class Solution {
    public List<String> listBracketPairings(int pairCount) {
        List<String> sequences = new ArrayList<>();
        build(new StringBuilder(), 0, 0, pairCount, sequences);
        return sequences;
    }

    private void build(StringBuilder prefix, int opened, int closed, int pairCount, List<String> out) {
        if (prefix.length() == 2 * pairCount) {
            out.add(prefix.toString());
            return;
        }
        if (opened < pairCount) {
            prefix.append('(');
            build(prefix, opened + 1, closed, pairCount, out);
            prefix.deleteCharAt(prefix.length() - 1);
        }
        if (closed < opened) {
            prefix.append(')');
            build(prefix, opened, closed + 1, pairCount, out);
            prefix.deleteCharAt(prefix.length() - 1);
        }
    }
}
