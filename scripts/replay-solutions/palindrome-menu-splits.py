class Solution:
    def splitMirrorPhrases(self, menu: str) -> list[list[str]]:
        splits: list[list[str]] = []
        pieces: list[str] = []

        def split_from(start: int) -> None:
            if start == len(menu):
                splits.append(pieces.copy())
                return
            for end in range(start + 1, len(menu) + 1):
                piece = menu[start:end]
                if piece == piece[::-1]:
                    pieces.append(piece)
                    split_from(end)
                    pieces.pop()

        split_from(0)
        return splits
