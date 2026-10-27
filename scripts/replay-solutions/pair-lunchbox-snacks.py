class Solution:
    def pairCrates(self, crates: list[int], capacity: int) -> int:
        weights = sorted(crates)
        light, heavy = 0, len(weights) - 1
        boxes = 0
        while light <= heavy:
            if weights[light] + weights[heavy] <= capacity:
                light += 1
            heavy -= 1
            boxes += 1
        return boxes
