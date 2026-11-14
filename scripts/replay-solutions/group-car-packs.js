class Solution {
    countCarPacks(target, position, speed) {
        const order = position.map((_, i) => i).sort((a, b) => position[b] - position[a]);
        let packs = 0, leadDistance = 0, leadSpeed = 1;
        for (const i of order) {
            const distance = target - position[i];
            if (distance * leadSpeed > leadDistance * speed[i]) {
                packs++;
                leadDistance = distance;
                leadSpeed = speed[i];
            }
        }
        return packs;
    }
}
