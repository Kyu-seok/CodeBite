package com.codebite.recommendation.service;

import com.codebite.problem.entity.Problem;
import com.codebite.recommendation.dto.RoadmapNextItem;
import com.codebite.recommendation.dto.RoadmapNextProblem;
import com.codebite.recommendation.dto.WeakCategoryItem;
import com.codebite.review.entity.Confidence;
import com.codebite.roadmap.entity.RoadmapCategory;
import com.codebite.roadmap.repository.RoadmapCategoryRepository;
import com.codebite.submission.repository.SubmissionRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service
public class RecommendationService {

    private final SubmissionRepository submissionRepository;
    private final RoadmapCategoryRepository roadmapRepository;

    public RecommendationService(SubmissionRepository submissionRepository,
                                 RoadmapCategoryRepository roadmapRepository) {
        this.submissionRepository = submissionRepository;
        this.roadmapRepository = roadmapRepository;
    }

    /**
     * Tags ranked ascending by average rating (lowest = weakest).
     * Maps confidence to numeric: AGAIN=1, HARD=2, GOOD=3, EASY=4.
     */
    @Transactional(readOnly = true)
    public List<WeakCategoryItem> getWeakTags(Long userId, int limit) {
        record TagKey(String slug, String name) {}
        Map<TagKey, long[]> byTag = new LinkedHashMap<>();
        for (Object[] row : submissionRepository.countConfidenceByTag(userId)) {
            String slug = (String) row[0];
            String name = (String) row[1];
            Confidence conf = (Confidence) row[2];
            long count = (Long) row[3];
            long[] counts = byTag.computeIfAbsent(new TagKey(slug, name), k -> new long[4]);
            counts[confidenceIndex(conf)] += count;
        }

        return byTag.entrySet().stream()
                .map(e -> {
                    long[] c = e.getValue();
                    long total = c[0] + c[1] + c[2] + c[3];
                    double avg = total == 0 ? 0
                            : (1.0 * c[0] + 2.0 * c[1] + 3.0 * c[2] + 4.0 * c[3]) / total;
                    return new WeakCategoryItem(
                            e.getKey().slug(), e.getKey().name(), avg, total);
                })
                .sorted((a, b) -> Double.compare(a.avgConfidence(), b.avgConfidence()))
                .limit(Math.max(1, limit))
                .toList();
    }

    /**
     * Roadmap categories whose prerequisites are all "fully solved" by the user
     * but which themselves still have unsolved published problems.
     */
    @Transactional(readOnly = true)
    public List<RoadmapNextItem> getRoadmapNext(Long userId) {
        List<RoadmapCategory> categories = roadmapRepository.findAllByOrderByDisplayOrderAsc();
        Set<Long> solvedProblemIds = loadSolvedProblemIds(userId);

        // Determine which categories are fully solved (all published problems solved).
        Map<Long, Boolean> isCategorySolved = new HashMap<>();
        for (RoadmapCategory cat : categories) {
            boolean allSolved = cat.getProblems().stream()
                    .filter(Problem::isPublished)
                    .allMatch(p -> solvedProblemIds.contains(p.getId()));
            // Treat a category with zero published problems as not-solved (nothing to suggest, skip below).
            boolean hasPublished = cat.getProblems().stream().anyMatch(Problem::isPublished);
            isCategorySolved.put(cat.getId(), hasPublished && allSolved);
        }

        return categories.stream()
                .filter(cat -> {
                    boolean prereqsCleared = cat.getPrerequisites().stream()
                            .allMatch(p -> isCategorySolved.getOrDefault(p.getId(), false));
                    boolean selfNotDone = !isCategorySolved.get(cat.getId());
                    boolean hasUnsolvedPublished = cat.getProblems().stream()
                            .filter(Problem::isPublished)
                            .anyMatch(p -> !solvedProblemIds.contains(p.getId()));
                    return prereqsCleared && selfNotDone && hasUnsolvedPublished;
                })
                .map(cat -> new RoadmapNextItem(
                        cat.getSlug(),
                        cat.getName(),
                        cat.getDescription(),
                        cat.getProblems().stream()
                                .filter(Problem::isPublished)
                                .filter(p -> !solvedProblemIds.contains(p.getId()))
                                .limit(3)
                                .map(p -> new RoadmapNextProblem(
                                        p.getSlug(), p.getTitle(), p.getDifficulty()))
                                .toList()
                ))
                .toList();
    }

    private Set<Long> loadSolvedProblemIds(Long userId) {
        Set<Long> solved = new HashSet<>();
        for (Object[] row : submissionRepository.findProblemStatusesByUserId(userId)) {
            if ("SOLVED".equals(row[1])) {
                solved.add((Long) row[0]);
            }
        }
        return solved;
    }

    private static int confidenceIndex(Confidence c) {
        return switch (c) {
            case AGAIN -> 0;
            case HARD -> 1;
            case GOOD -> 2;
            case EASY -> 3;
        };
    }
}
