import { useCallback, useEffect, useRef, useState } from "react"
import { useLocation, useNavigate } from "react-router-dom"
import { reportTutorialMilestone } from "@/api/tutorial"
import {
  advanceTutorial,
  browserStorage,
  milestoneToReport,
  readTutorial,
  TUTORIAL_PROBLEM_SLUG,
  type TutorialEvent,
  type TutorialState,
} from "@/onboarding"

/** Set on the navigation that starts the Tutorial, so the workspace offers to reset the code. */
export interface TutorialNavigationState {
  tutorialReplayed?: boolean
}

/**
 * Moves the Tutorial (from `current`, or what storage holds) and reports the step it reached, if
 * any, to the step counters. Every move goes through here.
 */
function moveTutorial(event: TutorialEvent, current: TutorialState = readTutorial(browserStorage)): TutorialState {
  const next = advanceTutorial(browserStorage, event, current)
  const milestone = milestoneToReport(browserStorage, current, event, next)
  if (milestone != null) reportTutorialMilestone(milestone)
  return next
}

/**
 * The one way into the Tutorial: the "How CodeBite works" link, and later the landing call to
 * action and the /problems banner. It restarts the Tutorial at step 1 and opens the Tutorial Problem.
 */
export function useStartTutorial(): () => void {
  const navigate = useNavigate()
  return useCallback(() => {
    moveTutorial({ type: "replayed" })
    const state: TutorialNavigationState = { tutorialReplayed: true }
    navigate(`/problems/${TUTORIAL_PROBLEM_SLUG}`, { state })
  }, [navigate])
}

/**
 * The Tutorial as the workspace sees it, re-read from storage on every navigation (the start link
 * may be followed while the page is already open). `dispatch` is the single place the Tutorial
 * moves, so whatever must happen on a transition goes there.
 */
export function useTutorial(): { tutorial: TutorialState; dispatch: (event: TutorialEvent) => TutorialState } {
  const location = useLocation()
  const [tutorial, setTutorial] = useState(() => readTutorial(browserStorage))
  const [readAt, setReadAt] = useState(location.key)
  if (readAt !== location.key) {
    setReadAt(location.key)
    setTutorial(readTutorial(browserStorage))
  }
  // A ref, so events from callbacks created before the last render (a submission watch) still
  // advance from the current step.
  const current = useRef(tutorial)
  useEffect(() => {
    current.current = tutorial
  }, [tutorial])

  const dispatch = useCallback((event: TutorialEvent) => {
    const next = moveTutorial(event, current.current)
    current.current = next
    setTutorial(next)
    return next
  }, [])

  return { tutorial, dispatch }
}
