MOD = 10**9 + 7


class Solution:
    def countAssemblyOrders(self, prevRoom: list[int]) -> int:
        # Valid orders = n! / (product of every subtree's size), modulo a prime.
        n = len(prevRoom)
        children: list[list[int]] = [[] for _ in range(n)]
        for task in range(1, n):
            children[prevRoom[task]].append(task)
        order = [0]  # breadth-first: parents before children
        for task in order:
            order.extend(children[task])
        size = [1] * n
        for task in reversed(order[1:]):
            size[prevRoom[task]] += size[task]
        factorial = 1
        for i in range(2, n + 1):
            factorial = factorial * i % MOD
        denominator = 1
        for s in size:
            denominator = denominator * s % MOD
        return factorial * pow(denominator, MOD - 2, MOD) % MOD
