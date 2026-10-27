class ListCoder:
    def pack(self, messages: list[str]) -> str:
        return "".join(f"{len(message)}#{message}" for message in messages)

    def unpack(self, blob: str) -> list[str]:
        messages: list[str] = []
        i = 0
        while i < len(blob):
            hash_at = blob.index("#", i)
            length = int(blob[i:hash_at])
            start = hash_at + 1
            messages.append(blob[start:start + length])
            i = start + length
        return messages
