class Solution {
    peakComboPerWindow(combo, k) {
        const window = [];
        let head = 0;
        const peaks = [];
        for (let i = 0; i < combo.length; i++) {
            while (window.length > head && combo[window[window.length - 1]] <= combo[i]) window.pop();
            window.push(i);
            if (window[head] <= i - k) head++;
            if (i >= k - 1) peaks.push(combo[window[head]]);
        }
        return peaks;
    }
}
