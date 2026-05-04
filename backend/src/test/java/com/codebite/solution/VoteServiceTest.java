package com.codebite.solution;

import com.codebite.solution.dto.VoteResponse;
import com.codebite.solution.entity.Solution;
import com.codebite.solution.entity.SolutionVote;
import com.codebite.solution.entity.VoteDirection;
import com.codebite.solution.repository.SolutionRepository;
import com.codebite.solution.repository.SolutionVoteRepository;
import com.codebite.solution.service.VoteService;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class VoteServiceTest {

    @Mock private SolutionRepository solutionRepository;
    @Mock private SolutionVoteRepository voteRepository;
    @Mock private UserRepository userRepository;

    private VoteService voteService;
    private Solution solution;
    private User user;

    @BeforeEach
    void setUp() {
        voteService = new VoteService(solutionRepository, voteRepository, userRepository);
        solution = new Solution();
        solution.setId(1L);
        solution.setUpvotesCount(0);
        solution.setDownvotesCount(0);
        user = new User();
        user.setUsername("alice");
    }

    @Test
    void firstVote_createsVote_andIncrementsCount() {
        when(solutionRepository.findByIdForUpdate(1L)).thenReturn(Optional.of(solution));
        when(voteRepository.findBySolutionIdAndUserId(1L, 100L)).thenReturn(Optional.empty());
        when(userRepository.findById(100L)).thenReturn(Optional.of(user));

        VoteResponse res = voteService.vote(1L, 100L, VoteDirection.UP);

        assertEquals(VoteDirection.UP, res.viewerVote());
        assertEquals(1, res.upvotesCount());
        assertEquals(0, res.downvotesCount());
        verify(voteRepository).save(any(SolutionVote.class));
    }

    @Test
    void sameDirectionVote_togglesOff() {
        SolutionVote existing = new SolutionVote();
        existing.setSolution(solution);
        existing.setUser(user);
        existing.setDirection(VoteDirection.UP);
        solution.setUpvotesCount(1);

        when(solutionRepository.findByIdForUpdate(1L)).thenReturn(Optional.of(solution));
        when(voteRepository.findBySolutionIdAndUserId(1L, 100L)).thenReturn(Optional.of(existing));

        VoteResponse res = voteService.vote(1L, 100L, VoteDirection.UP);

        assertNull(res.viewerVote());
        assertEquals(0, res.upvotesCount());
        verify(voteRepository).delete(existing);
        verify(userRepository, never()).findById(100L);
    }

    @Test
    void oppositeDirectionVote_flips_andAdjustsBothCounts() {
        SolutionVote existing = new SolutionVote();
        existing.setSolution(solution);
        existing.setUser(user);
        existing.setDirection(VoteDirection.UP);
        solution.setUpvotesCount(1);
        solution.setDownvotesCount(0);

        when(solutionRepository.findByIdForUpdate(1L)).thenReturn(Optional.of(solution));
        when(voteRepository.findBySolutionIdAndUserId(1L, 100L)).thenReturn(Optional.of(existing));

        VoteResponse res = voteService.vote(1L, 100L, VoteDirection.DOWN);

        assertEquals(VoteDirection.DOWN, res.viewerVote());
        assertEquals(0, res.upvotesCount());
        assertEquals(1, res.downvotesCount());
        assertEquals(VoteDirection.DOWN, existing.getDirection());
        verify(voteRepository, never()).delete(any());
    }

    @Test
    void clear_removesExistingVote() {
        SolutionVote existing = new SolutionVote();
        existing.setSolution(solution);
        existing.setUser(user);
        existing.setDirection(VoteDirection.DOWN);
        solution.setDownvotesCount(1);

        when(solutionRepository.findByIdForUpdate(1L)).thenReturn(Optional.of(solution));
        when(voteRepository.findBySolutionIdAndUserId(1L, 100L)).thenReturn(Optional.of(existing));

        VoteResponse res = voteService.clear(1L, 100L);

        assertNull(res.viewerVote());
        assertEquals(0, res.downvotesCount());
        verify(voteRepository).delete(existing);
    }

    @Test
    void clear_noopIfNoExistingVote() {
        when(solutionRepository.findByIdForUpdate(1L)).thenReturn(Optional.of(solution));
        when(voteRepository.findBySolutionIdAndUserId(1L, 100L)).thenReturn(Optional.empty());

        VoteResponse res = voteService.clear(1L, 100L);

        assertNull(res.viewerVote());
        assertEquals(0, res.upvotesCount());
        assertEquals(0, res.downvotesCount());
        verify(voteRepository, never()).delete(any());
    }
}
