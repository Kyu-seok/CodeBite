package com.codebite.user;

import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@DataJpaTest
@ActiveProfiles("test")
class UserRepositoryTest {

    @Autowired
    private UserRepository userRepository;

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
