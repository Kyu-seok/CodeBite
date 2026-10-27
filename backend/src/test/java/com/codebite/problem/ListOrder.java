package com.codebite.problem;

import java.util.List;

/**
 * The order drivers print a list of lists in once they sort it: row by row, as Python's
 * list.sort, C++'s vector operator< and the Java/JS comparators do.
 */
final class ListOrder {

    private ListOrder() {}

    /** True when each list comes strictly after the one before it: none out of order, none repeated. */
    static <T extends Comparable<T>> boolean isStrictlyAscending(List<List<T>> lists) {
        for (int i = 1; i < lists.size(); i++) {
            if (compare(lists.get(i - 1), lists.get(i)) >= 0) return false;
        }
        return true;
    }

    private static <T extends Comparable<T>> int compare(List<T> a, List<T> b) {
        for (int i = 0; i < Math.min(a.size(), b.size()); i++) {
            int cmp = a.get(i).compareTo(b.get(i));
            if (cmp != 0) return cmp;
        }
        return Integer.compare(a.size(), b.size());
    }
}
