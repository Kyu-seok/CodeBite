package com.codebite.problem.guarantee;

import java.util.List;
import java.util.Set;

/**
 * A problem's Guarantee (GLOSSARY.md): what its statement promises about every case, written from
 * the statement alone; {@code .claude/skills/correct-test-cases/SKILL.md} says why and how.
 *
 * <p>{@link ProblemGuaranteesTest} runs each one over every case of its problem. The Grader compares
 * output exactly, so a case is sound only when {@link #correctOutputs} is exactly its expected
 * output, for every problem: where a statement accepts several answers ("in any order"), its
 * Driver prints them in one fixed form, and this returns that form.
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
