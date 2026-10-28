package com.codebite.judge.grader;

/**
 * One test case to run a {@link Program} against.
 *
 * <p>A null {@code expectedOutput} means the case is run but its output is not compared (an
 * Unjudged Case, see GLOSSARY.md). An empty or blank expected output is a real answer and is
 * compared: a stored test case whose correct output is nothing at all is still graded.
 */
public record TestInput(String stdin, String expectedOutput) {

    public boolean judged() {
        return expectedOutput != null;
    }
}
