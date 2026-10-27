class Solution:
    def listSlateSequences(self, pairCount: int) -> list[str]:
        sequences: list[str] = []

        def build(prefix: str, opened: int, closed: int) -> None:
            if len(prefix) == 2 * pairCount:
                sequences.append(prefix)
                return
            if opened < pairCount:
                build(prefix + "(", opened + 1, closed)
            if closed < opened:
                build(prefix + ")", opened, closed + 1)

        build("", 0, 0)
        return sequences
