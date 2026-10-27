import heapq


class Solution:
    def findTightestBooking(self, intervals: list[list[int]], queries: list[int]) -> list[int]:
        bookings = sorted(intervals)
        answers = [-1] * len(queries)
        started: list[tuple[int, int]] = []  # (length, end) of every booking starting by now
        next_booking = 0
        # Answer probes in time order, adding bookings as they start and dropping those already over.
        for index in sorted(range(len(queries)), key=queries.__getitem__):
            minute = queries[index]
            while next_booking < len(bookings) and bookings[next_booking][0] <= minute:
                start, end = bookings[next_booking]
                heapq.heappush(started, (end - start + 1, end))
                next_booking += 1
            while started and started[0][1] < minute:
                heapq.heappop(started)
            if started:
                answers[index] = started[0][0]
        return answers
