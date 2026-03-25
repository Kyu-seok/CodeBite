import { useEffect, useState } from "react";
import { getTags } from "../api/tags";
import type { TagDto } from "../types/problem";

export function useTags() {
  const [tags, setTags] = useState<TagDto[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    getTags()
      .then((res) => setTags(res.data))
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

  return { tags, loading };
}
