class Solution {
    minEatingRate(piles, hours) {
        let low = 1, high = Math.max(...piles);
        while (low < high) {
            const rate = Math.floor((low + high) / 2);
            let needed = 0;
            for (const pile of piles) needed += Math.ceil(pile / rate);
            if (needed <= hours) high = rate;
            else low = rate + 1;
        }
        return low;
    }
}
