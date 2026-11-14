class Solution {
    canGroupCards(cards, groupSize) {
        if (cards.length % groupSize !== 0) return false;
        const left = new Map();
        for (const card of cards) left.set(card, (left.get(card) || 0) + 1);
        const starts = [...left.keys()].sort((a, b) => a - b);
        for (const start of starts) {
            const groups = left.get(start);
            if (groups === 0) continue;
            for (let card = start; card < start + groupSize; card++) {
                const have = left.get(card) || 0;
                if (have < groups) return false;
                left.set(card, have - groups);
            }
        }
        return true;
    }
}
