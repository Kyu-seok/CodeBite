#!/usr/bin/env python3
"""Compares docs/PROBLEMS_MAPPING.md with the database's problems.

The mapping is gitignored, so CI can't check it, and problem-generator takes problem_number from
it. Prints one MAPPING line per row that differs and exits 1 when any does.

  check-problems-mapping.py <mapping file>    # stdin: number, title and slug per line, tab-separated
"""
import sys


def rows_of(text):
    """The mapping's rows as {number: (title, slug)}; every other line is prose or a table header."""
    rows = {}
    for line in text.splitlines():
        cells = [cell.strip() for cell in line.split("|")]
        if len(cells) >= 6 and cells[1].isdigit():
            rows[int(cells[1])] = (cells[2], cells[3])
    return rows


def main():
    with open(sys.argv[1], encoding="utf-8") as mapping:
        rows = rows_of(mapping.read())
    problems = {}
    for line in sys.stdin:
        number, title, slug = line.rstrip("\n").split("\t")
        problems[int(number)] = (title, slug)
    differences = []
    for number in sorted(rows.keys() | problems.keys()):
        row, problem = rows.get(number), problems.get(number)
        if row is None:
            differences.append(f"#{number} has no row; the database has {problem[0]} ({problem[1]})")
        elif problem is None:
            differences.append(f"#{number} is {row[0]} ({row[1]}); the database has no such number")
        elif row != problem:
            differences.append(f"#{number} is {row[0]} ({row[1]}); the database has {problem[0]} ({problem[1]})")
    for difference in differences:
        print(f"  MAPPING  {difference}")
    return 1 if differences else 0


if __name__ == "__main__":
    sys.exit(main())
