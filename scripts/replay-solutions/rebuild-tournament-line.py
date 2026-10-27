class Solution:
    def orderTicketHolders(self, people: list[list[int]]) -> list[list[int]]:
        # Seat the tallest first; each shorter player then slides in at index k,
        # since only the taller players already seated count toward k.
        line: list[list[int]] = []
        for player in sorted(people, key=lambda p: (-p[0], p[1])):
            line.insert(player[1], player)
        return line
