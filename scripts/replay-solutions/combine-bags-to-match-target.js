class Solution {
    canMatchTarget(bags, target) {
        const reached = [false, false, false];
        for (const bag of bags) {
            if (bag.some((reading, k) => reading > target[k])) continue;
            for (let k = 0; k < 3; k++) if (bag[k] === target[k]) reached[k] = true;
        }
        return reached.every(Boolean);
    }
}
