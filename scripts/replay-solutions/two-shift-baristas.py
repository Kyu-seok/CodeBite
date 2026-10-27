class Solution:
    def splitIntoTwoShifts(self, graph: list[list[int]]) -> bool:
        shift = [-1] * len(graph)
        for start in range(len(graph)):
            if shift[start] != -1:
                continue
            shift[start] = 0
            stack = [start]
            while stack:
                node = stack.pop()
                for other in graph[node]:
                    if shift[other] == -1:
                        shift[other] = 1 - shift[node]
                        stack.append(other)
                    elif shift[other] == shift[node]:
                        return False
        return True
