package com.codebite.solution;

import com.codebite.solution.dto.CreateCommentRequest;
import com.codebite.solution.entity.Solution;
import com.codebite.solution.entity.SolutionComment;
import com.codebite.solution.repository.SolutionCommentRepository;
import com.codebite.solution.repository.SolutionRepository;
import com.codebite.solution.service.CommentService;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.access.AccessDeniedException;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CommentServiceTest {

    @Mock private SolutionCommentRepository commentRepository;
    @Mock private SolutionRepository solutionRepository;
    @Mock private UserRepository userRepository;

    private CommentService commentService;
    private Solution solution;
    private User author;

    @BeforeEach
    void setUp() {
        commentService = new CommentService(commentRepository, solutionRepository, userRepository);
        solution = new Solution();
        solution.setId(1L);
        solution.setCommentsCount(0);
        author = new User();
        author.setId(100L);
        author.setUsername("alice");
    }

    @Test
    void create_topLevelComment_savesAndIncrementsCount() {
        when(solutionRepository.findByIdForUpdate(1L)).thenReturn(Optional.of(solution));
        when(userRepository.findById(100L)).thenReturn(Optional.of(author));
        when(commentRepository.save(any(SolutionComment.class))).thenAnswer(inv -> {
            SolutionComment c = inv.getArgument(0);
            c.setId(50L);
            return c;
        });

        commentService.create(1L, new CreateCommentRequest("hi", null), 100L);

        assertEquals(1, solution.getCommentsCount());
    }

    @Test
    void create_replyToTopLevel_isAllowed() {
        SolutionComment parent = new SolutionComment();
        parent.setId(10L);
        parent.setSolution(solution);
        parent.setAuthor(author);
        parent.setParentComment(null);

        when(solutionRepository.findByIdForUpdate(1L)).thenReturn(Optional.of(solution));
        when(userRepository.findById(100L)).thenReturn(Optional.of(author));
        when(commentRepository.findById(10L)).thenReturn(Optional.of(parent));
        when(commentRepository.save(any(SolutionComment.class))).thenAnswer(inv -> {
            SolutionComment c = inv.getArgument(0);
            c.setId(51L);
            return c;
        });

        commentService.create(1L, new CreateCommentRequest("nice", 10L), 100L);

        assertEquals(1, solution.getCommentsCount());
    }

    @Test
    void create_replyToReply_isRejected() {
        SolutionComment grandparent = new SolutionComment();
        grandparent.setId(10L);
        grandparent.setSolution(solution);
        grandparent.setAuthor(author);

        SolutionComment parent = new SolutionComment();
        parent.setId(11L);
        parent.setSolution(solution);
        parent.setAuthor(author);
        parent.setParentComment(grandparent);  // depth 1

        when(solutionRepository.findByIdForUpdate(1L)).thenReturn(Optional.of(solution));
        when(userRepository.findById(100L)).thenReturn(Optional.of(author));
        when(commentRepository.findById(11L)).thenReturn(Optional.of(parent));

        assertThrows(IllegalArgumentException.class,
                () -> commentService.create(1L, new CreateCommentRequest("too deep", 11L), 100L));
    }

    @Test
    void delete_byNonOwnerNonAdmin_throwsAccessDenied() {
        SolutionComment c = new SolutionComment();
        c.setId(50L);
        c.setSolution(solution);
        c.setAuthor(author); // owner is user 100
        c.setParentComment(null);

        when(commentRepository.findById(50L)).thenReturn(Optional.of(c));

        assertThrows(AccessDeniedException.class,
                () -> commentService.delete(50L, 999L, false));
    }

    @Test
    void delete_byAdmin_succeeds() {
        SolutionComment c = new SolutionComment();
        c.setId(50L);
        c.setSolution(solution);
        c.setAuthor(author);
        c.setParentComment(null);
        solution.setCommentsCount(1);

        when(commentRepository.findById(50L)).thenReturn(Optional.of(c));
        when(solutionRepository.findByIdForUpdate(1L)).thenReturn(Optional.of(solution));
        when(commentRepository.findByParentCommentIdInOrderByCreatedAtAsc(java.util.List.of(50L)))
                .thenReturn(java.util.List.of());

        commentService.delete(50L, 999L, true);

        assertEquals(0, solution.getCommentsCount());
    }
}
