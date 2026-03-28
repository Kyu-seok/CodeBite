import client from "./client"
import type { RoadmapResponse } from "../types/roadmap"

export function getRoadmap() {
  return client.get<RoadmapResponse>("/roadmap")
}
