package com.codebite.problem.service;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.problem.dto.ProblemDetail;
import com.codebite.problem.dto.ProblemListItem;
import com.codebite.problem.dto.ProblemStats;
import com.codebite.problem.entity.Curation;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.ProblemTranslation;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.DifficultyCount;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.ProblemTranslationRepository;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.progress.ProblemPopularity;
import com.codebite.progress.ProblemPopularity.Rate;
import com.codebite.progress.UserProgress;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.EnumMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * The published problems as a user sees them: the list with their Progress and each problem's
 * Acceptance Rate, the header counts, a random pick and the detail page, translated to the request
 * locale. Reads only; curation and publishing are {@link ProblemAdminService}'s.
 */
@Service
public class ProblemCatalogue {

    private final ProblemRepository problemRepository;
    private final ProblemTranslationRepository translationRepository;
    private final TestCaseRepository testCaseRepository;
    private final ProblemPopularity problemPopularity;
    private final UserProgress userProgress;
    private final ProblemDtos dtos;

    public ProblemCatalogue(ProblemRepository problemRepository,
                            ProblemTranslationRepository translationRepository,
                            TestCaseRepository testCaseRepository,
                            ProblemPopularity problemPopularity,
                            UserProgress userProgress,
                            ProblemDtos dtos) {
        this.problemRepository = problemRepository;
        this.translationRepository = translationRepository;
        this.testCaseRepository = testCaseRepository;
        this.problemPopularity = problemPopularity;
        this.userProgress = userProgress;
        this.dtos = dtos;
    }

    @Transactional(readOnly = true)
    public Page<ProblemListItem> listPublishedProblems(Difficulty difficulty, String search, String tag, String curation, Long userId, Pageable pageable) {
        Specification<Problem> spec = Specification.where(ProblemSpecifications.isPublished());
        if (difficulty != null) {
            spec = spec.and(ProblemSpecifications.hasDifficulty(difficulty));
        }
        if (search != null && !search.isBlank()) {
            spec = spec.and(ProblemSpecifications.titleContains(search));
        }
        if (tag != null && !tag.isBlank()) {
            spec = spec.and(ProblemSpecifications.hasTag(tag));
        }
        Optional<Curation> chosen = Curation.ofRequest(curation);
        if (chosen.isPresent()) {
            spec = spec.and(ProblemSpecifications.inCuration(chosen.get()));
        }

        Page<Problem> page = problemRepository.findAll(spec, pageable);
        List<Long> pageIds = page.getContent().stream().map(Problem::getId).toList();
        Map<Long, UserProgress.Status> statusMap = userId != null
                ? userProgress.statusByProblem(userId, pageIds) : Map.of();
        Map<Long, Rate> acceptanceRates = problemPopularity.acceptanceRates(pageIds);
        Map<Long, ProblemTranslation> translationMap = fetchTranslationMap(pageIds);
        return page.map(p -> dtos.toListItem(p, statusMap, acceptanceRates, translationMap));
    }

    @Transactional(readOnly = true)
    public ProblemStats getStats(Long userId, String curation) {
        Optional<Curation> chosen = Curation.ofRequest(curation);
        Map<Difficulty, Integer> totals = new EnumMap<>(Difficulty.class);
        List<DifficultyCount> totalRows = chosen.isPresent()
                ? problemRepository.countPublishedByDifficultyIn(chosen.get())
                : problemRepository.countPublishedByDifficulty();
        for (DifficultyCount row : totalRows) {
            totals.put(row.difficulty(), (int) row.count());
        }

        Map<Difficulty, Integer> solved = userId != null
                ? userProgress.solvedByDifficulty(userId, chosen)
                : Map.of();

        return new ProblemStats(
                totals.getOrDefault(Difficulty.EASY, 0),
                totals.getOrDefault(Difficulty.MEDIUM, 0),
                totals.getOrDefault(Difficulty.HARD, 0),
                solved.getOrDefault(Difficulty.EASY, 0),
                solved.getOrDefault(Difficulty.MEDIUM, 0),
                solved.getOrDefault(Difficulty.HARD, 0)
        );
    }

    @Transactional(readOnly = true)
    public String getRandomProblemSlug(Difficulty difficulty, Long userId) {
        Pageable one = PageRequest.of(0, 1);
        List<String> slugs;

        Set<Long> solved = userId != null ? userProgress.solvedProblemIds(userId) : Set.of();
        if (!solved.isEmpty()) {
            // Prefer a problem the user has not Solved
            slugs = difficulty != null
                    ? problemRepository.findRandomPublishedSlugsByDifficultyExcluding(difficulty, solved, one)
                    : problemRepository.findRandomPublishedSlugsExcluding(solved, one);
            if (!slugs.isEmpty()) return slugs.get(0);
        }

        // Nothing Solved, or everything is: any random
        slugs = difficulty != null
                ? problemRepository.findRandomPublishedSlugsByDifficulty(difficulty, one)
                : problemRepository.findRandomPublishedSlugs(one);

        if (slugs.isEmpty()) {
            throw new ResourceNotFoundException("error.noproblems");
        }
        return slugs.get(0);
    }

    @Transactional(readOnly = true)
    public ProblemDetail getProblemBySlug(String slug) {
        Problem problem = problemRepository.findBySlugOrFormerSlug(slug)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFound", slug));
        if (!problem.isPublished()) {
            throw new ResourceNotFoundException("error.problem.notFound", slug);
        }
        List<TestCase> sampleCases = testCaseRepository
                .findByProblemIdAndSampleTrueOrderByOrderIndexAsc(problem.getId());
        ProblemTranslation translation = fetchTranslation(problem.getId());
        return dtos.toDetail(problem, sampleCases, translation);
    }

    private String currentLocale() {
        return LocaleContextHolder.getLocale().getLanguage();
    }

    private ProblemTranslation fetchTranslation(Long problemId) {
        String locale = currentLocale();
        if ("en".equals(locale)) return null;
        return translationRepository.findByProblemIdAndLocale(problemId, locale).orElse(null);
    }

    private Map<Long, ProblemTranslation> fetchTranslationMap(List<Long> problemIds) {
        String locale = currentLocale();
        if ("en".equals(locale) || problemIds.isEmpty()) return Map.of();
        return translationRepository.findByProblemIdInAndLocale(problemIds, locale)
                .stream().collect(Collectors.toMap(t -> t.getProblem().getId(), t -> t));
    }
}
