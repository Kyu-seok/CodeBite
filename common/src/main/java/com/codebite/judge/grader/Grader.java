package com.codebite.judge.grader;

import com.codebite.judge.dto.JudgeResponse;
import com.codebite.judge.service.JudgeService;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * Grades a {@link Program} against test cases and returns a {@link Verdict} (docs/adr/0005).
 * The one place that knows how Judge0 statuses become submission statuses and how the cases
 * fold into an overall status; Submit and Run both grade through it.
 *
 * <p>A {@link com.codebite.common.exception.JudgeExecutionException} from Judge0 propagates
 * from both methods: Submit relies on it to roll back and retry.
 */
@Service
public class Grader {

    private final JudgeService judgeService;

    public Grader(JudgeService judgeService) {
        this.judgeService = judgeService;
    }

    /** One Judge0 batch; every case runs; the verdict has one entry per input, in order. */
    public Verdict grade(Program program, List<TestInput> cases) {
        List<String> stdins = cases.stream().map(TestInput::stdin).toList();
        List<JudgeResponse> responses = judgeService.executeBatch(
                program.sourceCode(), program.languageId(), stdins);

        List<CaseVerdict> verdicts = new ArrayList<>(cases.size());
        for (int i = 0; i < cases.size(); i++) {
            verdicts.add(CaseVerdict.of(responses.get(i), cases.get(i).expectedOutput()));
        }
        return Verdict.of(verdicts);
    }

    /**
     * Runs the cases one at a time and stops after the first that fails, so the verdict's cases
     * are a prefix of the input. An Unjudged Case that finished never stops the run.
     */
    public Verdict gradeUntilFailure(Program program, List<TestInput> cases) {
        List<CaseVerdict> verdicts = new ArrayList<>();
        for (TestInput input : cases) {
            JudgeResponse response = judgeService.execute(
                    program.sourceCode(), program.languageId(), input.stdin());
            CaseVerdict verdict = CaseVerdict.of(response, input.expectedOutput());
            verdicts.add(verdict);
            if (verdict.fails()) {
                break;
            }
        }
        return Verdict.of(verdicts);
    }
}
