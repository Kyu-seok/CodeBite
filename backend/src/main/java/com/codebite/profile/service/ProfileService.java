package com.codebite.profile.service;

import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.profile.dto.ActivityDay;
import com.codebite.profile.dto.ProfileStats;
import com.codebite.profile.dto.RecentSubmission;
import com.codebite.profile.dto.TagProficiency;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ProfileService {

    private final SubmissionRepository submissionRepository;
    private final ProblemRepository problemRepository;
    private final UserRepository userRepository;

    public ProfileService(SubmissionRepository submissionRepository,
                          ProblemRepository problemRepository,
                          UserRepository userRepository) {
        this.submissionRepository = submissionRepository;
        this.problemRepository = problemRepository;
        this.userRepository = userRepository;
    }

    @Transactional(readOnly = true)
    public ProfileStats getStats(Long userId) {
        // Difficulty totals
        Map<String, Integer> totals = new HashMap<>();
        for (Object[] row : problemRepository.countPublishedByDifficulty()) {
            totals.put(((Difficulty) row[0]).name(), ((Long) row[1]).intValue());
        }

        // Solved by difficulty
        Map<String, Integer> solved = new HashMap<>();
        for (Object[] row : submissionRepository.countSolvedByDifficultyAndUserId(userId)) {
            solved.put(((Difficulty) row[0]).name(), ((Long) row[1]).intValue());
        }

        int totalEasy = totals.getOrDefault("EASY", 0);
        int totalMedium = totals.getOrDefault("MEDIUM", 0);
        int totalHard = totals.getOrDefault("HARD", 0);
        int solvedEasy = solved.getOrDefault("EASY", 0);
        int solvedMedium = solved.getOrDefault("MEDIUM", 0);
        int solvedHard = solved.getOrDefault("HARD", 0);
        int totalSolved = solvedEasy + solvedMedium + solvedHard;
        int totalProblems = totalEasy + totalMedium + totalHard;

        // Activity for streaks
        Instant oneYearAgo = Instant.now().minus(365, ChronoUnit.DAYS);
        List<Object[]> activityRows = submissionRepository.countDailyActivity(userId, oneYearAgo);
        List<LocalDate> activeDates = new ArrayList<>();
        for (Object[] row : activityRows) {
            activeDates.add((LocalDate) row[0]);
        }

        int[] streaks = computeStreaks(activeDates);

        // Member since
        Instant memberSince = userRepository.findById(userId)
                .map(User::getCreatedAt)
                .orElse(Instant.now());

        return new ProfileStats(
                totalSolved, totalProblems,
                solvedEasy, solvedMedium, solvedHard,
                totalEasy, totalMedium, totalHard,
                streaks[0], streaks[1], activeDates.size(),
                memberSince
        );
    }

    @Transactional(readOnly = true)
    public List<ActivityDay> getActivity(Long userId, int months) {
        Instant since = Instant.now().minus(months * 30L, ChronoUnit.DAYS);
        List<Object[]> rows = submissionRepository.countDailyActivity(userId, since);
        List<ActivityDay> result = new ArrayList<>();
        for (Object[] row : rows) {
            result.add(new ActivityDay((LocalDate) row[0], ((Long) row[1]).intValue()));
        }
        return result;
    }

    @Transactional(readOnly = true)
    public List<TagProficiency> getTagProficiency(Long userId) {
        // Total problems per tag
        Map<String, int[]> tagMap = new HashMap<>(); // slug -> [solved, total]
        Map<String, String> nameMap = new HashMap<>(); // slug -> name

        for (Object[] row : problemRepository.countPublishedByTag()) {
            String name = (String) row[0];
            String slug = (String) row[1];
            int total = ((Long) row[2]).intValue();
            tagMap.put(slug, new int[]{0, total});
            nameMap.put(slug, name);
        }

        // Solved per tag
        for (Object[] row : submissionRepository.countSolvedByTag(userId)) {
            String slug = (String) row[1];
            int solvedCount = ((Long) row[2]).intValue();
            int[] counts = tagMap.get(slug);
            if (counts != null) {
                counts[0] = solvedCount;
            }
        }

        List<TagProficiency> result = new ArrayList<>();
        for (Map.Entry<String, int[]> entry : tagMap.entrySet()) {
            String slug = entry.getKey();
            int[] counts = entry.getValue();
            result.add(new TagProficiency(nameMap.get(slug), slug, counts[0], counts[1]));
        }
        result.sort((a, b) -> a.tagName().compareTo(b.tagName()));
        return result;
    }

    @Transactional(readOnly = true)
    public Page<RecentSubmission> getRecentSubmissions(Long userId, Pageable pageable) {
        return submissionRepository.findRecentByUserId(userId, pageable)
                .map(this::toRecentSubmission);
    }

    private RecentSubmission toRecentSubmission(Submission s) {
        return new RecentSubmission(
                s.getId(),
                s.getProblem().getTitle(),
                s.getProblem().getSlug(),
                s.getProblem().getDifficulty().name(),
                s.getStatus().name(),
                s.getLanguage(),
                s.getRuntimeMs(),
                s.getMemoryKb(),
                s.getCreatedAt()
        );
    }

    /**
     * Computes [currentStreak, longestStreak] from a sorted list of active dates.
     */
    private int[] computeStreaks(List<LocalDate> activeDates) {
        if (activeDates.isEmpty()) return new int[]{0, 0};

        LocalDate today = LocalDate.now(ZoneOffset.UTC);
        int longestStreak = 1;
        int tempStreak = 1;

        for (int i = 1; i < activeDates.size(); i++) {
            if (activeDates.get(i).equals(activeDates.get(i - 1).plusDays(1))) {
                tempStreak++;
            } else {
                longestStreak = Math.max(longestStreak, tempStreak);
                tempStreak = 1;
            }
        }
        longestStreak = Math.max(longestStreak, tempStreak);

        // Current streak: count backwards from today
        int currentStreak = 0;
        LocalDate lastActive = activeDates.get(activeDates.size() - 1);
        if (lastActive.equals(today) || lastActive.equals(today.minusDays(1))) {
            currentStreak = 1;
            for (int i = activeDates.size() - 2; i >= 0; i--) {
                if (activeDates.get(i).equals(activeDates.get(i + 1).minusDays(1))) {
                    currentStreak++;
                } else {
                    break;
                }
            }
        }

        return new int[]{currentStreak, longestStreak};
    }
}
