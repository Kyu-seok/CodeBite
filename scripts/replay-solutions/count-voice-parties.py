class Solution:
    def count_components(self, n: int, relays: list[list[int]]) -> int:
        parent = list(range(n))

        def find(x: int) -> int:
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        components = n
        for a, b in relays:
            ra, rb = find(a), find(b)
            if ra != rb:
                parent[ra] = rb
                components -= 1
        return components
