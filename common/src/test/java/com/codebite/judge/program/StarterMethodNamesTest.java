package com.codebite.judge.program;

import com.codebite.judge.Language;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * A problem's four Starter Codes name the same public methods, spelled the same (camelCase in
 * every Language): a Python {@code add_two_numbers} beside Java's {@code addScoreLists} passes
 * {@link DriverStarterMethodTest}, since each Driver calls its own Starter Code's name, and slipped
 * through a restatement run until review caught it (#244).
 *
 * <p>A public method is one a user writes: Python {@code def}s not starting with {@code _}, Java
 * {@code public} methods, JavaScript class methods other than {@code constructor}, and C++ methods
 * with a body other than a constructor. Comments are skipped, since Java and C++ Starter Codes
 * describe {@code ListNode} and {@code TreeNode} in one.
 */
class StarterMethodNamesTest {

    private static final ProblemAssets ASSETS = new ProblemAssets();

    private static final Set<String> NOT_METHODS = Set.of("if", "for", "while", "switch", "return", "catch");

    @Test
    void everyProblemsStarterCodesNameTheSameMethods() {
        Set<String> slugs = new TreeSet<>();
        for (Language language : Language.values()) slugs.addAll(ASSETS.slugsWithDriver(language));
        assertFalse(slugs.isEmpty(), "No problems found");

        List<String> mismatches = new ArrayList<>();
        for (String slug : slugs) {
            mismatch(ASSETS.starters(slug)).ifPresent(m -> mismatches.add(slug + " " + m));
        }
        assertTrue(mismatches.isEmpty(),
                mismatches.size() + " problems' Starter Codes name different methods:\n"
                        + String.join("\n", mismatches));
    }

    @Test
    void aStarterOutOfStepIsCaught() {
        // Python spells the method in snake_case.
        assertMismatch(starters(
                "class Solution:\n    def add_score_lists(self, a, b):\n        pass\n",
                "class Solution {\n    public ListNode addScoreLists(ListNode a, ListNode b) {\n    }\n}\n",
                "class Solution {\n    addScoreLists(a, b) {\n    }\n}\n",
                "class Solution {\npublic:\n    ListNode* addScoreLists(ListNode* a, ListNode* b) {\n    }\n};\n"));
        // One method of a design problem keeps another name in JavaScript.
        assertMismatch(design("insert", "search", "startsWith", "startsWith",
                "class PrefixIndex {\n    constructor() {\n    }\n    insert(word) {\n    }\n"
                        + "    search(word) {\n    }\n    starts_with(prefix) {\n    }\n}\n"));
        // C++ adds a method the others lack.
        Map<Language, String> extra = starters(
                "class Solution:\n    def countPaths(self, n):\n        pass\n",
                "class Solution {\n    public int countPaths(int n) {\n    }\n}\n",
                "class Solution {\n    countPaths(n) {\n    }\n}\n",
                "class Solution {\npublic:\n    int countPaths(int n) {\n    }\n    int helper(int n) {\n    }\n};\n");
        assertMismatch(extra);
        // A Starter Code with no method at all is out of step, not vacuously equal.
        Map<Language, String> empty = starters(
                "class Solution:\n    pass\n",
                "class Solution {\n}\n",
                "class Solution {\n}\n",
                "class Solution {\n};\n");
        assertMismatch(empty);
        // Each exception, with a method just outside it that still counts:
        // a Python name with an underscore inside, not leading, is public,
        assertMismatch(starters(
                "class Solution:\n    def _helper(self):\n        pass\n    def solve(self):\n        pass\n"
                        + "    def helper_(self):\n        pass\n",
                "class Solution {\n    public int solve() {\n    }\n}\n",
                "class Solution {\n    solve() {\n    }\n}\n",
                "class Solution {\npublic:\n    int solve() {\n    }\n};\n"));
        // a Java method after a comment on its line counts,
        assertMismatch(starters(
                "class Solution:\n    def solve(self):\n        pass\n",
                "class Solution {\n    public int solve() {\n    }\n    /* hint */ public int extra() {\n    }\n}\n",
                "class Solution {\n    solve() {\n    }\n}\n",
                "class Solution {\npublic:\n    int solve() {\n    }\n};\n"));
        // and a C++ method named like its class but in other case is no constructor.
        assertMismatch(starters(
                "class Solution:\n    def solve(self):\n        pass\n",
                "class Solution {\n    public int solve() {\n    }\n}\n",
                "class Solution {\n    solve() {\n    }\n}\n",
                "class Solution {\npublic:\n    Solution() {}\n    int solve() {\n    }\n    int solution() {\n    }\n};\n"));
    }

    @Test
    void startersThatAgreePass() {
        assertEquals(Optional.empty(), mismatch(starters(
                "from typing import Optional\n\nclass ListNode:\n    def __init__(self, val=0, next=None):\n"
                        + "        self.val = val\n\nclass Solution:\n"
                        + "    # def old_name(self): kept out by the comment\n"
                        + "    def _helper(self):\n        pass\n"
                        + "    def addScoreLists(self, a: Optional[ListNode], b) -> Optional[ListNode]:\n        pass\n",
                "/**\n * class ListNode {\n *     ListNode(int val) { this.val = val; }\n * }\n */\n"
                        + "class Solution {\n    public ListNode addScoreLists(ListNode a, ListNode b) {\n"
                        + "        if (a == null) {\n        }\n    }\n}\n",
                "class ListNode {\n    constructor(val = 0, next = null) {\n        this.val = val;\n    }\n}\n\n"
                        + "class Solution {\n    addScoreLists(a, b) {\n        for (const x of a) {\n        }\n    }\n}\n",
                "/**\n * struct ListNode {\n *     ListNode(int x) : val(x), next(nullptr) {}\n * };\n */\n"
                        + "class Solution {\npublic:\n    Solution() {}\n"
                        + "    vector<vector<int>> addScoreLists(ListNode* a, const vector<int>& b) {\n"
                        + "        while (a) {\n        }\n    }\n};\n")));
        assertEquals(Optional.empty(), mismatch(design("insert", "search", "startsWith", "startsWith",
                "class PrefixIndex {\n    constructor() {\n    }\n    insert(word) {\n    }\n"
                        + "    search(word) {\n    }\n    startsWith(prefix) {\n    }\n}\n")));
    }

    /** What is out of step among {@code starters}, or empty when every Language names the same methods. */
    static Optional<String> mismatch(Map<Language, String> starters) {
        Map<Language, Set<String>> methods = new EnumMap<>(Language.class);
        for (Language language : Language.values()) {
            String starter = starters.get(language);
            methods.put(language, starter == null ? Set.of() : publicMethods(language, starter));
        }
        boolean agree = methods.values().stream().distinct().count() == 1
                && !methods.get(Language.JAVA).isEmpty();
        return agree ? Optional.empty() : Optional.of(methods.toString());
    }

    static Set<String> publicMethods(Language language, String starter) {
        Set<String> names = new TreeSet<>();
        switch (language) {
            case PYTHON -> {
                Matcher m = Pattern.compile("(?m)^[ \\t]+def\\s+(\\w+)\\s*\\(")
                        .matcher(starter.replaceAll("#[^\\n]*", ""));
                while (m.find()) if (!m.group(1).startsWith("_")) names.add(m.group(1));
            }
            case JAVA -> {
                Matcher m = Pattern.compile("\\bpublic\\s+(?:static\\s+)?[\\w<>\\[\\],? ]*?[\\w>\\]]\\s+(\\w+)\\s*\\(")
                        .matcher(withoutComments(starter));
                while (m.find()) names.add(m.group(1));
            }
            case JAVASCRIPT -> {
                Matcher m = Pattern.compile("(?m)^[ \\t]+(\\w+)\\s*\\([^)]*\\)\\s*\\{")
                        .matcher(withoutComments(starter));
                while (m.find()) names.add(m.group(1));
                names.remove("constructor");
            }
            case CPP -> {
                String code = withoutComments(starter);
                Matcher m = Pattern.compile(
                        "(?m)^[ \\t]+[\\w:<>,*& ]*?[\\w>*&]\\s*[*&]?\\s*\\b(\\w+)\\s*\\([^;{]*\\)\\s*(?:const\\s*)?\\{")
                        .matcher(code);
                while (m.find()) names.add(m.group(1));
                Matcher classes = Pattern.compile("\\b(?:class|struct)\\s+(\\w+)").matcher(code);
                while (classes.find()) names.remove(classes.group(1));
            }
        }
        names.removeAll(NOT_METHODS);
        return names;
    }

    private static String withoutComments(String source) {
        return source.replaceAll("(?s)/\\*.*?\\*/", "").replaceAll("//[^\\n]*", "");
    }

    private static void assertMismatch(Map<Language, String> starters) {
        assertTrue(mismatch(starters).isPresent(), "Not caught: " + starters);
    }

    private static Map<Language, String> starters(String python, String java, String javascript, String cpp) {
        Map<Language, String> starters = new EnumMap<>(Language.class);
        starters.put(Language.PYTHON, python);
        starters.put(Language.JAVA, java);
        starters.put(Language.JAVASCRIPT, javascript);
        starters.put(Language.CPP, cpp);
        return starters;
    }

    /** A {@code PrefixIndex} design problem with three methods, the JavaScript Starter Code given whole. */
    private static Map<Language, String> design(String insert, String search, String pyStartsWith,
                                                String startsWith, String javascript) {
        return starters(
                "class PrefixIndex:\n    def __init__(self):\n        pass\n"
                        + "    def " + insert + "(self, word):\n        pass\n"
                        + "    def " + search + "(self, word):\n        pass\n"
                        + "    def " + pyStartsWith + "(self, prefix):\n        pass\n",
                "class PrefixIndex {\n    public PrefixIndex() {\n    }\n"
                        + "    public void " + insert + "(String word) {\n    }\n"
                        + "    public boolean " + search + "(String word) {\n    }\n"
                        + "    public boolean " + startsWith + "(String prefix) {\n    }\n}\n",
                javascript,
                "class PrefixIndex {\npublic:\n    PrefixIndex() {\n    }\n"
                        + "    void " + insert + "(string word) {\n    }\n"
                        + "    bool " + search + "(string word) {\n    }\n"
                        + "    bool " + startsWith + "(string prefix) {\n    }\n};\n");
    }
}
