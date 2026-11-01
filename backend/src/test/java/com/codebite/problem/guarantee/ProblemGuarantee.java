package com.codebite.problem.guarantee;

import java.util.List;
import java.util.Set;

/**
 * What one problem's statement promises about a case, written from the statement alone and never
 * from a solution: a reference solution that picks one of two right answers passes a case that
 * has both, which is how a case with two answers gets in.
 *
 * <p>{@link ProblemGuaranteesTest} runs each one over every case of its problem. The Grader compares
 * output exactly, so a case is sound only when {@link #correctOutputs} is exactly its expected
 * output: a second correct output is a correct program judged Wrong Answer. A Test Case Correction
 * (GLOSSARY.md, {@code .claude/skills/correct-test-cases/SKILL.md}) starts by writing one.
 */
public interface ProblemGuarantee {

    /** The problem's Slug; a Restatement renames it here too. */
    String slug();

    /**
     * Each way the input breaks the statement (its constraints, "sorted", "exactly one ..."),
     * one message per break; empty when the input is one the statement allows.
     */
    List<String> inputViolations(CaseInput input);

    /**
     * Every output the statement accepts for this input, as the Driver prints it, found by brute
     * force or another exact method. Only called on an input with no violations.
     */
    Set<String> correctOutputs(CaseInput input);
}
