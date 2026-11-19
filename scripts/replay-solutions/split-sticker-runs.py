class Solution:
    def splitStickerRuns(self, stickers: str) -> list[int]:
        last = {letter: i for i, letter in enumerate(stickers)}
        sizes = []
        start = end = 0
        for i, letter in enumerate(stickers):
            end = max(end, last[letter])
            if i == end:  # every letter seen in this run has finished
                sizes.append(end - start + 1)
                start = i + 1
        return sizes
