class Solution {
    crushHeaviestBlocks(blocks) {
        const pile = [...blocks];
        while (pile.length > 1) {
            pile.sort((a, b) => b - a);
            const y = pile.shift(), x = pile.shift();
            if (y !== x) pile.push(y - x);
        }
        return pile.length ? pile[0] : 0;
    }
}
