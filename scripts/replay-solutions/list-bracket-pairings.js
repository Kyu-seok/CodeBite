class Solution {
    listBracketPairings(pairCount) {
        const sequences = [];
        const build = (prefix, opened, closed) => {
            if (prefix.length === 2 * pairCount) {
                sequences.push(prefix);
                return;
            }
            if (opened < pairCount) build(prefix + '(', opened + 1, closed);
            if (closed < opened) build(prefix + ')', opened, closed + 1);
        };
        build('', 0, 0);
        return sequences;
    }
}
