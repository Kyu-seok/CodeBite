class Solution:
    def checkKeyReachability(self, rooms: list[list[int]]) -> bool:
        visited = {0}
        stack = [0]
        while stack:
            for key in rooms[stack.pop()]:
                if key not in visited:
                    visited.add(key)
                    stack.append(key)
        return len(visited) == len(rooms)
