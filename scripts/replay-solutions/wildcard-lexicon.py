class WildcardLexicon:
    def __init__(self) -> None:
        self.root: dict = {}

    def add_word(self, word: str) -> None:
        node = self.root
        for ch in word:
            node = node.setdefault(ch, {})
        node["$"] = True

    def match(self, word: str) -> bool:
        def walk(node: dict, i: int) -> bool:
            if i == len(word):
                return "$" in node
            ch = word[i]
            if ch == ".":
                return any(walk(child, i + 1) for key, child in node.items() if key != "$")
            child = node.get(ch)
            return child is not None and walk(child, i + 1)

        return walk(self.root, 0)
