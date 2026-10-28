package com.codebite.judge.grader;

/**
 * One test case to run a {@link Program} against.
 *
 * <p>A null or blank {@code expectedOutput} means the case is run but its output is not compared
 * (an Unjudged Case, see GLOSSARY.md); it is normalised to null.
 */
public record TestInput(String stdin, String expectedOutput) {

    public TestInput {
        expectedOutput = expectedOutput == null || expectedOutput.isBlank() ? null : expectedOutput;
    }

    public boolean judged() {
        return expectedOutput != null;
    }
}
