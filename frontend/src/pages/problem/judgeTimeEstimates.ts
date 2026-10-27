/**
 * How long a Run or Submit usually takes to judge, per language, in whole seconds.
 *
 * A hardcoded stand-in: Submit figures are the measured submit-to-result times (PRODUCT.md,
 * README); Run figures are estimates for the synchronous sample-only path, which skips the
 * Kafka hop and judges fewer cases. Java stays slowest because every case pays for
 * compilation and JVM startup. Replace this table with estimates derived from real
 * processing durations; callers only depend on `estimatedJudgeSeconds`.
 */
export type JudgeMode = 'run' | 'submit';

const ESTIMATED_JUDGE_SECONDS: Record<JudgeMode, Record<string, number>> = {
  run: {
    python: 1,
    javascript: 1,
    c: 2,
    cpp: 3,
    java: 5,
  },
  submit: {
    python: 2,
    javascript: 2,
    c: 3,
    cpp: 4,
    java: 8,
  },
};

/** Undefined for a language with no estimate, so the UI shows only the elapsed time. */
export function estimatedJudgeSeconds(language: string, mode: JudgeMode): number | undefined {
  return ESTIMATED_JUDGE_SECONDS[mode][language];
}
