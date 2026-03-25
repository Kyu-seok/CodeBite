import client from "./client";
import type { TagDto } from "../types/problem";

export function getTags() {
  return client.get<TagDto[]>("/tags");
}
