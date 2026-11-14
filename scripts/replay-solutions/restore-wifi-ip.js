class Solution {
    restoreIpAddresses(digits) {
        const valid = (segment) => segment.length > 0 && segment.length <= 3
            && (segment === '0' || segment[0] !== '0') && Number(segment) <= 255;
        const addresses = [];
        for (let a = 1; a <= 3; a++)
            for (let b = a + 1; b <= a + 3; b++)
                for (let c = b + 1; c <= b + 3; c++) {
                    if (c >= digits.length) continue;
                    const parts = [digits.slice(0, a), digits.slice(a, b), digits.slice(b, c), digits.slice(c)];
                    if (parts.every(valid)) addresses.push(parts.join('.'));
                }
        return addresses;
    }
}
