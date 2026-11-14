class Solution {
    recoverTierOrder(tags) {
        const letters = [...new Set(tags.join(''))].sort();
        const after = new Map(letters.map(ch => [ch, new Set()]));
        const indegree = new Map(letters.map(ch => [ch, 0]));
        for (let i = 0; i + 1 < tags.length; i++) {
            const first = tags[i], second = tags[i + 1];
            const len = Math.min(first.length, second.length);
            let j = 0;
            while (j < len && first[j] === second[j]) j++;
            if (j === len) {
                if (first.length > second.length) return "";
            } else if (!after.get(first[j]).has(second[j])) {
                after.get(first[j]).add(second[j]);
                indegree.set(second[j], indegree.get(second[j]) + 1);
            }
        }
        const ready = letters.filter(ch => indegree.get(ch) === 0);
        let order = "";
        while (ready.length) {
            ready.sort();
            const ch = ready.shift();
            order += ch;
            for (const next of after.get(ch)) {
                indegree.set(next, indegree.get(next) - 1);
                if (indegree.get(next) === 0) ready.push(next);
            }
        }
        return order.length === letters.length ? order : "";
    }
}
