package com.codebite.problem.service;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.problem.dto.CreateProblemRequest;
import com.codebite.problem.dto.CreateTestCaseRequest;
import com.codebite.problem.dto.ProblemDetail;
import com.codebite.problem.dto.ProblemListItem;
import com.codebite.problem.dto.ProblemStats;
import com.codebite.problem.dto.TestCaseDto;
import com.codebite.problem.dto.UpdateProblemRequest;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.ProblemTranslation;
import com.codebite.problem.entity.Tag;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.ProblemTranslationRepository;
import com.codebite.problem.repository.TagRepository;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.submission.repository.SubmissionRepository;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class ProblemService {

    private final ProblemRepository problemRepository;
    private final ProblemTranslationRepository translationRepository;
    private final TestCaseRepository testCaseRepository;
    private final TagRepository tagRepository;
    private final StarterCodeLoader starterCodeLoader;
    private final SubmissionRepository submissionRepository;

    public ProblemService(ProblemRepository problemRepository,
                          ProblemTranslationRepository translationRepository,
                          TestCaseRepository testCaseRepository,
                          TagRepository tagRepository, StarterCodeLoader starterCodeLoader,
                          SubmissionRepository submissionRepository) {
        this.problemRepository = problemRepository;
        this.translationRepository = translationRepository;
        this.testCaseRepository = testCaseRepository;
        this.tagRepository = tagRepository;
        this.starterCodeLoader = starterCodeLoader;
        this.submissionRepository = submissionRepository;
    }

    @Transactional(readOnly = true)
    public Page<ProblemListItem> listPublishedProblems(Difficulty difficulty, String search, String tag, Long userId, Pageable pageable) {
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

        Map<Long, String> statusMap = userId != null ? buildStatusMap(userId) : Map.of();
        Map<Long, Double> acceptanceMap = buildAcceptanceMap();

        Page<Problem> page = problemRepository.findAll(spec, pageable);
        Map<Long, ProblemTranslation> translationMap = fetchTranslationMap(
                page.getContent().stream().map(Problem::getId).toList());
        return page.map(p -> toListItem(p, statusMap, acceptanceMap, translationMap));
    }

    private Map<Long, String> buildStatusMap(Long userId) {
        Map<Long, String> map = new HashMap<>();
        for (Object[] row : submissionRepository.findProblemStatusesByUserId(userId)) {
            map.put((Long) row[0], (String) row[1]);
        }
        return map;
    }

    private Map<Long, Double> buildAcceptanceMap() {
        Map<Long, Double> map = new HashMap<>();
        for (Object[] row : submissionRepository.findAcceptanceRates()) {
            Long problemId = (Long) row[0];
            long total = (Long) row[1];
            long accepted = (Long) row[2];
            map.put(problemId, total > 0 ? Math.round(accepted * 1000.0 / total) / 10.0 : 0.0);
        }
        return map;
    }

    @Transactional(readOnly = true)
    public ProblemStats getStats(Long userId) {
        Map<String, Integer> totals = new HashMap<>();
        for (Object[] row : problemRepository.countPublishedByDifficulty()) {
            totals.put(((Difficulty) row[0]).name(), ((Long) row[1]).intValue());
        }

        Map<String, Integer> solved = new HashMap<>();
        if (userId != null) {
            for (Object[] row : submissionRepository.countSolvedByDifficultyAndUserId(userId)) {
                solved.put(((Difficulty) row[0]).name(), ((Long) row[1]).intValue());
            }
        }

        return new ProblemStats(
                totals.getOrDefault("EASY", 0),
                totals.getOrDefault("MEDIUM", 0),
                totals.getOrDefault("HARD", 0),
                solved.getOrDefault("EASY", 0),
                solved.getOrDefault("MEDIUM", 0),
                solved.getOrDefault("HARD", 0)
        );
    }

    @Transactional(readOnly = true)
    public String getRandomProblemSlug(Difficulty difficulty, Long userId) {
        Pageable one = PageRequest.of(0, 1);
        List<String> slugs;

        if (userId != null) {
            // Try unsolved first
            slugs = difficulty != null
                    ? problemRepository.findRandomUnsolvedSlugsByDifficulty(difficulty, userId, one)
                    : problemRepository.findRandomUnsolvedSlugs(userId, one);
            if (!slugs.isEmpty()) return slugs.get(0);
        }

        // Fall back to any random
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
        Problem problem = problemRepository.findBySlug(slug)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFound", slug));
        if (!problem.isPublished()) {
            throw new ResourceNotFoundException("error.problem.notFound", slug);
        }
        List<TestCase> sampleCases = testCaseRepository
                .findByProblemIdAndSampleTrueOrderByOrderIndexAsc(problem.getId());
        ProblemTranslation translation = fetchTranslation(problem.getId());
        return toDetail(problem, sampleCases, translation);
    }

    @Transactional
    public ProblemDetail createProblem(CreateProblemRequest request) {
        Problem problem = new Problem();
        problem.setTitle(request.title());
        problem.setSlug(slugify(request.title()));
        problem.setDescription(request.description());
        problem.setDifficulty(request.difficulty());
        problem.setConstraints(request.constraints());
        problem.setPublished(request.published() != null && request.published());

        problem = problemRepository.save(problem);
        return toDetail(problem, List.of(), null);
    }

    @Transactional
    public ProblemDetail updateProblem(Long id, UpdateProblemRequest request) {
        Problem problem = problemRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFoundById",id));

        if (request.title() != null) {
            problem.setTitle(request.title());
            problem.setSlug(slugify(request.title()));
        }
        if (request.description() != null) {
            problem.setDescription(request.description());
        }
        if (request.difficulty() != null) {
            problem.setDifficulty(request.difficulty());
        }
        if (request.constraints() != null) {
            problem.setConstraints(request.constraints());
        }
        if (request.published() != null) {
            problem.setPublished(request.published());
        }

        problem = problemRepository.save(problem);
        List<TestCase> sampleCases = testCaseRepository
                .findByProblemIdAndSampleTrueOrderByOrderIndexAsc(problem.getId());
        return toDetail(problem, sampleCases, null);
    }

    @Transactional
    public TestCaseDto addTestCase(Long problemId, CreateTestCaseRequest request) {
        Problem problem = problemRepository.findById(problemId)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFoundById",problemId));

        TestCase testCase = new TestCase();
        testCase.setProblem(problem);
        testCase.setInput(request.input());
        testCase.setExpectedOutput(request.expectedOutput());
        testCase.setSample(request.sample() != null && request.sample());
        testCase.setOrderIndex(request.orderIndex() != null ? request.orderIndex() : 0);

        testCase = testCaseRepository.save(testCase);
        return toTestCaseDto(testCase);
    }

    // ── Admin methods ──

    @Transactional(readOnly = true)
    public Page<ProblemListItem> listAllProblems(Difficulty difficulty, String search, Boolean published, Pageable pageable) {
        Specification<Problem> spec = Specification.where(null);
        if (published != null) {
            if (published) {
                spec = spec.and(ProblemSpecifications.isPublished());
            } else {
                spec = spec.and((root, query, cb) -> cb.isFalse(root.get("published")));
            }
        }
        if (difficulty != null) {
            spec = spec.and(ProblemSpecifications.hasDifficulty(difficulty));
        }
        if (search != null && !search.isBlank()) {
            spec = spec.and(ProblemSpecifications.titleContains(search));
        }

        Map<Long, Double> acceptanceMap = buildAcceptanceMap();
        return problemRepository.findAll(spec, pageable).map(p -> toListItem(p, Map.of(), acceptanceMap, Map.of()));
    }

    @Transactional(readOnly = true)
    public ProblemDetail getAdminProblemById(Long id) {
        Problem problem = problemRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFoundById",id));
        List<TestCase> sampleCases = testCaseRepository
                .findByProblemIdAndSampleTrueOrderByOrderIndexAsc(problem.getId());
        return toDetail(problem, sampleCases, null);
    }

    @Transactional
    public void deleteProblem(Long id) {
        Problem problem = problemRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFoundById",id));
        problemRepository.delete(problem);
    }

    @Transactional(readOnly = true)
    public List<TestCaseDto> getTestCases(Long problemId) {
        if (!problemRepository.existsById(problemId)) {
            throw new ResourceNotFoundException("error.problem.notFoundById",problemId);
        }
        return testCaseRepository.findByProblemIdOrderByOrderIndexAsc(problemId)
                .stream().map(this::toTestCaseDto).toList();
    }

    @Transactional
    public TestCaseDto updateTestCase(Long problemId, Long testCaseId, CreateTestCaseRequest request) {
        TestCase testCase = testCaseRepository.findById(testCaseId)
                .orElseThrow(() -> new ResourceNotFoundException("error.testcase.notFound",testCaseId));
        if (!testCase.getProblem().getId().equals(problemId)) {
            throw new ResourceNotFoundException("error.testcase.notFound",testCaseId);
        }
        testCase.setInput(request.input());
        testCase.setExpectedOutput(request.expectedOutput());
        if (request.sample() != null) testCase.setSample(request.sample());
        if (request.orderIndex() != null) testCase.setOrderIndex(request.orderIndex());
        return toTestCaseDto(testCaseRepository.save(testCase));
    }

    @Transactional
    public void deleteTestCase(Long problemId, Long testCaseId) {
        TestCase testCase = testCaseRepository.findById(testCaseId)
                .orElseThrow(() -> new ResourceNotFoundException("error.testcase.notFound",testCaseId));
        if (!testCase.getProblem().getId().equals(problemId)) {
            throw new ResourceNotFoundException("error.testcase.notFound",testCaseId);
        }
        testCaseRepository.delete(testCase);
    }

    @Transactional(readOnly = true)
    public List<String> getProblemTags(Long problemId) {
        Problem problem = problemRepository.findById(problemId)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFoundById",problemId));
        return problem.getTags().stream().map(Tag::getName).sorted().toList();
    }

    @Transactional
    public List<String> updateProblemTags(Long problemId, List<Long> tagIds) {
        Problem problem = problemRepository.findById(problemId)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFoundById",problemId));
        Set<Tag> tags = new HashSet<>(tagRepository.findAllById(tagIds));
        problem.setTags(tags);
        problemRepository.save(problem);
        return problem.getTags().stream().map(Tag::getName).sorted().toList();
    }

    private String slugify(String title) {
        String base = title.toLowerCase()
                .replaceAll("[^a-z0-9\\s-]", "")
                .replaceAll("\\s+", "-")
                .replaceAll("-+", "-")
                .replaceAll("^-|-$", "");

        String slug = base;
        int suffix = 2;
        while (problemRepository.existsBySlug(slug)) {
            slug = base + "-" + suffix;
            suffix++;
        }
        return slug;
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

    private ProblemListItem toListItem(Problem problem, Map<Long, String> statusMap,
                                       Map<Long, Double> acceptanceMap,
                                       Map<Long, ProblemTranslation> translationMap) {
        String title = problem.getTitle();
        ProblemTranslation t = translationMap.get(problem.getId());
        if (t != null) title = t.getTitle();

        List<String> tagNames = problem.getTags().stream()
                .map(com.codebite.problem.entity.Tag::getName)
                .sorted()
                .toList();
        return new ProblemListItem(
                problem.getId(),
                title,
                problem.getSlug(),
                problem.getDifficulty(),
                tagNames,
                statusMap.getOrDefault(problem.getId(), null),
                acceptanceMap.getOrDefault(problem.getId(), null)
        );
    }

    private ProblemDetail toDetail(Problem problem, List<TestCase> sampleCases, ProblemTranslation translation) {
        String title = problem.getTitle();
        String description = problem.getDescription();
        String constraints = problem.getConstraints();

        if (translation != null) {
            title = translation.getTitle();
            description = translation.getDescription();
            if (translation.getConstraints() != null) {
                constraints = translation.getConstraints();
            }
        }

        return new ProblemDetail(
                problem.getId(),
                title,
                problem.getSlug(),
                description,
                problem.getDifficulty(),
                starterCodeLoader.getStarterCode(problem.getSlug()),
                constraints,
                problem.isPublished(),
                sampleCases.stream().map(this::toTestCaseDto).toList(),
                problem.getCreatedAt(),
                problem.getUpdatedAt()
        );
    }

    private TestCaseDto toTestCaseDto(TestCase tc) {
        return new TestCaseDto(
                tc.getId(),
                tc.getInput(),
                tc.getExpectedOutput(),
                tc.isSample(),
                tc.getOrderIndex()
        );
    }
}
