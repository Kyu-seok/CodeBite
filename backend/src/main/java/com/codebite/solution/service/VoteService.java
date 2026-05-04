package com.codebite.solution.service;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.solution.dto.VoteResponse;
import com.codebite.solution.entity.Solution;
import com.codebite.solution.entity.SolutionVote;
import com.codebite.solution.entity.VoteDirection;
import com.codebite.solution.repository.SolutionRepository;
import com.codebite.solution.repository.SolutionVoteRepository;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
public class VoteService {

    private final SolutionRepository solutionRepository;
    private final SolutionVoteRepository voteRepository;
    private final UserRepository userRepository;

    public VoteService(SolutionRepository solutionRepository,
                       SolutionVoteRepository voteRepository,
                       UserRepository userRepository) {
        this.solutionRepository = solutionRepository;
        this.voteRepository = voteRepository;
        this.userRepository = userRepository;
    }

    /**
     * Sets the viewer's vote to the requested direction. Toggling the same direction clears it.
     */
    @Transactional
    public VoteResponse vote(Long solutionId, Long userId, VoteDirection requested) {
        Solution s = solutionRepository.findByIdForUpdate(solutionId)
                .orElseThrow(() -> new ResourceNotFoundException("error.solution.notFound", solutionId));

        Optional<SolutionVote> existing = voteRepository.findBySolutionIdAndUserId(solutionId, userId);

        if (existing.isEmpty()) {
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new ResourceNotFoundException("error.user.notFound", userId));
            SolutionVote v = new SolutionVote();
            v.setSolution(s);
            v.setUser(user);
            v.setDirection(requested);
            voteRepository.save(v);
            adjust(s, requested, +1);
            return new VoteResponse(requested, s.getUpvotesCount(), s.getDownvotesCount());
        }

        SolutionVote vote = existing.get();
        if (vote.getDirection() == requested) {
            // Toggle off
            voteRepository.delete(vote);
            adjust(s, requested, -1);
            return new VoteResponse(null, s.getUpvotesCount(), s.getDownvotesCount());
        }

        // Flip
        adjust(s, vote.getDirection(), -1);
        adjust(s, requested, +1);
        vote.setDirection(requested);
        return new VoteResponse(requested, s.getUpvotesCount(), s.getDownvotesCount());
    }

    @Transactional
    public VoteResponse clear(Long solutionId, Long userId) {
        Solution s = solutionRepository.findByIdForUpdate(solutionId)
                .orElseThrow(() -> new ResourceNotFoundException("error.solution.notFound", solutionId));
        Optional<SolutionVote> existing = voteRepository.findBySolutionIdAndUserId(solutionId, userId);
        if (existing.isPresent()) {
            SolutionVote vote = existing.get();
            adjust(s, vote.getDirection(), -1);
            voteRepository.delete(vote);
        }
        return new VoteResponse(null, s.getUpvotesCount(), s.getDownvotesCount());
    }

    private static void adjust(Solution s, VoteDirection direction, int delta) {
        if (direction == VoteDirection.UP) {
            s.setUpvotesCount(Math.max(0, s.getUpvotesCount() + delta));
        } else {
            s.setDownvotesCount(Math.max(0, s.getDownvotesCount() + delta));
        }
    }
}
