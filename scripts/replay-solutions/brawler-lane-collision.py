class Solution:
    def resolveLaneCrashes(self, fighters: list[int]) -> list[int]:
        standing: list[int] = []
        for fighter in fighters:
            alive = True
            while alive and fighter < 0 and standing and standing[-1] > 0:
                if standing[-1] < -fighter:
                    standing.pop()
                elif standing[-1] == -fighter:
                    standing.pop()
                    alive = False
                else:
                    alive = False
            if alive:
                standing.append(fighter)
        return standing
