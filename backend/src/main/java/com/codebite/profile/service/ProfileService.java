package com.codebite.profile.service;

import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.repository.DifficultyCount;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.TagCount;
import com.codebite.progress.UserProgress;
import com.codebite.progress.UserProgress.TagProgress;
import com.codebite.profile.dto.ActivityDay;
import com.codebite.profile.dto.ProfileStats;
import com.codebite.profile.dto.RecentSubmission;
import com.codebite.profile.dto.TagProficiency;
import com.codebite.streak.dto.StreakSummary;
import com.codebite.streak.service.StreakService;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class ProfileService {

    private final SubmissionRepository submissionRepository;
    private final ProblemRepository problemRepository;
    private final UserRepository userRepository;
    private final StreakService streakService;
    private final UserProgress userProgress;

    public ProfileService(SubmissionRepository submissionRepository,
                          ProblemRepository problemRepository,
                          UserRepository userRepository,
                          StreakService streakService,
                          UserProgress userProgress) {
        this.submissionRepository = submissionRepository;
        this.problemRepository = problemRepository;
        this.userRepository = userRepository;
        this.streakService = streakService;
        this.userProgress = userProgress;
    }

    @Transactional(readOnly = true)
    public ProfileStats getStats(Long userId) {
        Map<Difficulty, Integer> totals = new EnumMap<>(Difficulty.class);
        for (DifficultyCount row : problemRepository.countPublishedByDifficulty()) {
            totals.put(row.difficulty(), (int) row.count());
        }
        Map<Difficulty, Integer> solved = userProgress.solvedByDifficulty(userId, Optional.empty());

        int totalEasy = totals.getOrDefault(Difficulty.EASY, 0);
        int totalMedium = totals.getOrDefault(Difficulty.MEDIUM, 0);
        int totalHard = totals.getOrDefault(Difficulty.HARD, 0);
        int solvedEasy = solved.getOrDefault(Difficulty.EASY, 0);
        int solvedMedium = solved.getOrDefault(Difficulty.MEDIUM, 0);
        int solvedHard = solved.getOrDefault(Difficulty.HARD, 0);
        int totalSolved = solvedEasy + solvedMedium + solvedHard;
        int totalProblems = totalEasy + totalMedium + totalHard;

        // Active days for the past year
        Instant oneYearAgo = Instant.now().minus(365, ChronoUnit.DAYS);
        int activeDays = userProgress.activity(userId, oneYearAgo).size();

        StreakSummary streak = streakService.getSummary(userId);

        // Member since
        Instant memberSince = userRepository.findById(userId)
                .map(User::getCreatedAt)
                .orElse(Instant.now());

        return new ProfileStats(
                totalSolved, totalProblems,
                solvedEasy, solvedMedium, solvedHard,
                totalEasy, totalMedium, totalHard,
                streak.currentStreak(), streak.bestStreak(), activeDays,
                memberSince
        );
    }

    @Transactional(readOnly = true)
    public List<ActivityDay> getActivity(Long userId, int months) {
        Instant since = Instant.now().minus(months * 30L, ChronoUnit.DAYS);
        return userProgress.activity(userId, since).stream()
                .map(day -> new ActivityDay(day.day(), day.submissions()))
                .toList();
    }

    @Transactional(readOnly = true)
    public List<TagProficiency> getTagProficiency(Long userId) {
        Map<String, Integer> solvedBySlug = new HashMap<>();
        for (TagProgress tag : userProgress.solvedByTag(userId)) {
            solvedBySlug.put(tag.slug(), tag.solved().intValue());
        }

        // One entry per tag with a published problem, Solved or not.
        List<TagProficiency> result = new ArrayList<>();
        for (TagCount tag : problemRepository.countPublishedByTag()) {
            result.add(new TagProficiency(tag.name(), tag.slug(),
                    solvedBySlug.getOrDefault(tag.slug(), 0), (int) tag.count()));
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
}
