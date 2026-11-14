class Solution {
    isCalm(reading) {
        const seen = new Set();
        while (reading !== 1 && !seen.has(reading)) {
            seen.add(reading);
            let next = 0;
            for (let x = reading; x > 0; x = Math.floor(x / 10)) next += (x % 10) ** 2;
            reading = next;
        }
        return reading === 1;
    }
}
