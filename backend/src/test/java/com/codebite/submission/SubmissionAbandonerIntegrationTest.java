package com.codebite.submission;

import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionResultEvent;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.submission.service.SubmissionAbandoner;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.event.ApplicationEvents;
import org.springframework.test.context.event.RecordApplicationEvents;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * The sweep's abandon path against the real persistence setup: the row loaded by the repository
 * query (user and problem as lazy proxies) is moved to INTERNAL_ERROR, persisted, and its result
 * event published with the ids read off those proxies without a query.
 */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
@RecordApplicationEvents
class SubmissionAbandonerIntegrationTest {

    @Autowired private SubmissionAbandoner abandoner;
    @Autowired private SubmissionRepository submissionRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private ProblemRepository problemRepository;
    @Autowired private EntityManager entityManager;
    @Autowired private ApplicationEvents events;

    @Test
    void abandonsAPendingRowLoadedFromTheDatabaseAndPublishesItsResultEvent() {
        User user = new User();
        user.setUsername("stuck");
        user.setEmail("stuck@test.com");
        user.setRole(Role.USER);
        user = userRepository.save(user);

        Problem problem = new Problem();
        problem.setTitle("Two Sum");
        problem.setSlug("two-sum-abandon");
        problem.setDescription("d");
        problem.setDifficulty(Difficulty.EASY);
        problem.setPublished(true);
        problem = problemRepository.save(problem);

        Submission submission = submissionRepository.saveAndFlush(
                Submission.pending(user, problem, "python", "print(1)"));
        entityManager.clear();

        int abandoned = abandoner.abandonExpired(Instant.now().plusSeconds(3600));

        assertTrue(abandoned >= 1);
        entityManager.flush();
        entityManager.clear();
        Submission reloaded = submissionRepository.findById(submission.getId()).orElseThrow();
        assertEquals(SubmissionStatus.INTERNAL_ERROR, reloaded.getStatus());
        assertTrue(reloaded.getResults().isEmpty());

        SubmissionResultEvent event = events.stream(SubmissionResultEvent.class)
                .filter(e -> e.submissionId().equals(submission.getId()))
                .findFirst().orElseThrow();
        assertEquals(new SubmissionResultEvent(submission.getId(), user.getId(), problem.getId(),
                SubmissionStatus.INTERNAL_ERROR, null, null, "python", false), event);
    }
}
