class Solution:
    def unifyContactIdentities(self, accounts: list[list[str]]) -> list[list[str]]:
        parent: dict[str, str] = {}
        owner: dict[str, str] = {}

        def find(email: str) -> str:
            while parent[email] != email:
                parent[email] = parent[parent[email]]
                email = parent[email]
            return email

        for name, first, *rest in accounts:
            for email in (first, *rest):
                parent.setdefault(email, email)
                owner[email] = name
                parent[find(email)] = find(first)

        groups: dict[str, list[str]] = {}
        for email in parent:
            groups.setdefault(find(email), []).append(email)
        return [[owner[root], *sorted(emails)] for root, emails in groups.items()]
