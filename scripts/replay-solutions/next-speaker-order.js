class Solution {
    nextLineup(lineup) {
        let i = lineup.length - 2;
        while (i >= 0 && lineup[i] >= lineup[i + 1]) i--;
        if (i >= 0) {
            let j = lineup.length - 1;
            while (lineup[j] <= lineup[i]) j--;
            [lineup[i], lineup[j]] = [lineup[j], lineup[i]];
        }
        for (let a = i + 1, b = lineup.length - 1; a < b; a++, b--) {
            [lineup[a], lineup[b]] = [lineup[b], lineup[a]];
        }
    }
}
