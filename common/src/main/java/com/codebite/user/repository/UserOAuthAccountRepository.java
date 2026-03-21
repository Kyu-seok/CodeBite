package com.codebite.user.repository;

import com.codebite.user.entity.OAuthProvider;
import com.codebite.user.entity.UserOAuthAccount;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserOAuthAccountRepository extends JpaRepository<UserOAuthAccount, Long> {

    Optional<UserOAuthAccount> findByProviderAndProviderId(OAuthProvider provider, String providerId);
}
