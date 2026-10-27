import { useCallback, useEffect, useState } from "react";
import { getTags } from "../api/tags";
import type { TagDto } from "../types/problem";

export function useTags() {
  const [tags, setTags] = useState<TagDto[]>([]);
  const [failed, setFailed] = useState(false);
  const [attempt, setAttempt] = useState(0);

  useEffect(() => {
    let current = true;
    getTags()
      .then((res) => current && setTags(res.data))
      .catch(() => current && setFailed(true));
    return () => {
      current = false;
    };
  }, [attempt]);

  const retry = useCallback(() => {
    setFailed(false);
    setAttempt((n) => n + 1);
  }, []);

  return { tags, failed, retry };
}
