class Node:
    def __init__(self, key=0, value=0):
        self.key = key
        self.value = value
        self.prev = None
        self.next = None


class LRUCache:
    """A hash map from key to node, and a doubly linked list of the nodes from least to most recently used between two
    sentinels: head.next is the least recently used, tail.prev the most."""

    def __init__(self, capacity: int) -> None:
        self.capacity = capacity
        self.nodes: dict[int, Node] = {}
        self.head, self.tail = Node(), Node()
        self.head.next, self.tail.prev = self.tail, self.head

    def _unlink(self, node: Node) -> None:
        node.prev.next = node.next
        node.next.prev = node.prev

    def _append(self, node: Node) -> None:
        """Put `node` just before tail, as the most recently used."""
        last = self.tail.prev
        last.next = node
        node.prev = last
        node.next = self.tail
        self.tail.prev = node

    def get(self, key: int) -> int:
        node = self.nodes.get(key)
        if node is None:
            return -1
        self._unlink(node)
        self._append(node)
        return node.value

    def put(self, key: int, value: int) -> None:
        node = self.nodes.get(key)
        if node is not None:
            node.value = value
            self._unlink(node)
        else:
            node = Node(key, value)
            self.nodes[key] = node
        self._append(node)
        if len(self.nodes) > self.capacity:
            lru = self.head.next
            self._unlink(lru)
            del self.nodes[lru.key]
