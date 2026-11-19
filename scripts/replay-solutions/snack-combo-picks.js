class Solution {
    listSnackCombos(snacks) {
        const sorted = [...snacks].sort((a, b) => a - b);
        const combos = [];
        const build = (start, combo) => {
            combos.push([...combo]);
            for (let i = start; i < sorted.length; i++) {
                if (i > start && sorted[i] === sorted[i - 1]) continue;
                combo.push(sorted[i]);
                build(i + 1, combo);
                combo.pop();
            }
        };
        build(0, []);
        return combos;
    }
}
