class Solution:
    def listVisitOrders(self, stops: list[int]) -> list[list[int]]:
        orders: list[list[int]] = []
        order: list[int] = []
        used = [False] * len(stops)

        def build() -> None:
            if len(order) == len(stops):
                orders.append(order.copy())
                return
            for i, stop in enumerate(stops):
                if used[i]:
                    continue
                used[i] = True
                order.append(stop)
                build()
                order.pop()
                used[i] = False

        build()
        return orders
