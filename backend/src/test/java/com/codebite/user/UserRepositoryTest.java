package com.codebite.user;

import com.codebite.judge.grader.CaseVerdict;
import com.codebite.judge.grader.Verdict;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserOverview;
import com.codebite.user.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.test.context.ActiveProfiles;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@DataJpaTest
@ActiveProfiles("test")
class UserRepositoryTest {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TestEntityManager entityManager;

    private User createUser(String username, String email) {
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPasswordHash("hashed");
        user.setRole(Role.USER);
        return userRepository.save(user);
    }

    @Test
    void save_andFindById() {
        User saved = createUser("alice", "alice@test.com");
        assertNotNull(saved.getId());

        Optional<User> found = userRepository.findById(saved.getId());
        assertTrue(found.isPresent());
        assertEquals("alice", found.get().getUsername());
    }

    @Test
    void findByUsername_exists() {
        createUser("bob", "bob@test.com");
        Optional<User> found = userRepository.findByUsername("bob");
        assertTrue(found.isPresent());
    }

    @Test
    void findByUsername_notExists() {
        Optional<User> found = userRepository.findByUsername("nobody");
        assertFalse(found.isPresent());
    }

    @Test
    void findByEmail_exists() {
        createUser("charlie", "charlie@test.com");
        Optional<User> found = userRepository.findByEmail("charlie@test.com");
        assertTrue(found.isPresent());
    }

    @Test
    void existsByUsername_returnsCorrectly() {
        createUser("dave", "dave@test.com");
        assertTrue(userRepository.existsByUsername("dave"));
        assertFalse(userRepository.existsByUsername("unknown"));
    }

    @Test
    void existsByEmail_returnsCorrectly() {
        createUser("eve", "eve@test.com");
        assertTrue(userRepository.existsByEmail("eve@test.com"));
        assertFalse(userRepository.existsByEmail("unknown@test.com"));
    }

    @Test
    void findAllOverviews_countsSolvedProblemsOnce_nonAdminOnly_andLastSubmission() {
        User solver = createUser("solver", "solver@test.com");
        User idle = createUser("idle", "idle@test.com");
        User admin = createUser("admin", "admin@test.com");
        admin.setRole(Role.ADMIN);
        admin = userRepository.save(admin);
        Problem problem = persistProblem("overview-problem");
        submit(solver, problem, SubmissionStatus.ACCEPTED);
        Submission last = submit(solver, problem, SubmissionStatus.ACCEPTED);
        submit(admin, problem, SubmissionStatus.ACCEPTED);
        entityManager.flush();
        entityManager.clear();

        Page<UserOverview> page = userRepository.findAllOverviews(
                PageRequest.of(0, 50, Sort.by(Sort.Direction.DESC, "createdAt")));

        assertEquals(3, page.getTotalElements());
        assertEquals(List.of("admin", "idle", "solver"), page.map(UserOverview::username).getContent(),
                "sorted by createdAt desc, the page's own sort");
        UserOverview solverRow = page.getContent().get(2);
        assertEquals(1, solverRow.solvedCount(), "two Accepted on one problem is one Solved");
        assertEquals(last.getCreatedAt(), solverRow.lastSubmittedAt());
        assertEquals(0, page.getContent().get(1).solvedCount());
        assertNull(page.getContent().get(1).lastSubmittedAt(), "never submitted");
        assertEquals(0, page.getContent().get(0).solvedCount(), "an admin's validation run is not a solve");
    }

    private Problem persistProblem(String slug) {
        Problem problem = new Problem();
        problem.setTitle(slug);
        problem.setSlug(slug);
        problem.setDescription("d");
        problem.setDifficulty(Difficulty.EASY);
        problem.setPublished(true);
        return entityManager.persist(problem);
    }

    private Submission submit(User owner, Problem problem, SubmissionStatus status) {
        TestCase testCase = new TestCase();
        testCase.setProblem(problem);
        testCase.setInput("1");
        testCase.setExpectedOutput("1");
        testCase.setOrderIndex(1);
        testCase = entityManager.persist(testCase);
        Submission submission = Submission.pending(owner, problem, "python", "x");
        submission.grade(Verdict.of(List.of(new CaseVerdict(status, true, "", null, null, 1, 1))),
                List.of(testCase));
        return entityManager.persist(submission);
    }

    @Test
    void uniqueConstraint_username() {
        createUser("frank", "frank1@test.com");
        User duplicate = new User();
        duplicate.setUsername("frank");
        duplicate.setEmail("frank2@test.com");
        duplicate.setPasswordHash("hashed");
        assertThrows(Exception.class, () -> {
            userRepository.saveAndFlush(duplicate);
        });
    }

    @Test
    void uniqueConstraint_email() {
        createUser("grace", "shared@test.com");
        User duplicate = new User();
        duplicate.setUsername("grace2");
        duplicate.setEmail("shared@test.com");
        duplicate.setPasswordHash("hashed");
        assertThrows(Exception.class, () -> {
            userRepository.saveAndFlush(duplicate);
        });
    }
}
