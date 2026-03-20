# Auth System

## Overview

CodeBite uses **stateless JWT authentication** with **OAuth2 login** via Google and GitHub. There is no password-based auth — all users sign in through an OAuth provider.

Supporting infrastructure:
- **Redis** — JWT token blacklisting (logout) and user profile caching
- **PostgreSQL** — persistent storage for users and OAuth account links

Both Redis-dependent services (TokenBlacklistService, UserCacheService) gracefully degrade when Redis is unavailable, so the app remains functional without it.

## Architecture

```
                         ┌──────────────┐
                         │ Google/GitHub │
                         │  OAuth APIs   │
                         └──────┬───────┘
                                │
┌─────────┐   HTTP    ┌────────┴────────┐    JDBC     ┌────────────┐
│ Browser  ├─────────►│  Spring Boot    ├────────────►│ PostgreSQL │
│ (React)  │◄─────────┤  Backend        │             │ users,     │
└─────────┘   JSON    │                 │    Redis    │ oauth_accts│
                      │  - AuthController├───────────►└────────────┘
                      │  - JwtFilter     │  ┌───────────────┐
                      │  - SecurityConfig│  │ Redis         │
                      └──────────────────┘  │ blacklist:*   │
                                            │ user:*:profile│
                                            └───────────────┘
```

## OAuth Login Flow

1. User clicks **"Continue with Google"** or **"Continue with GitHub"** on `LoginPage`.
2. Frontend calls `GET /api/auth/oauth/{provider}`.
3. Backend `AuthService` generates a **state token** — a signed JWT containing the provider name, a random nonce, and a 5-minute expiry (`app.oauth.state-expiration-ms: 300000`). This prevents CSRF attacks on the callback.
4. Backend builds the provider's authorization URL (with `client_id`, `redirect_uri`, `state`, and scopes) and returns it.
5. Frontend redirects the browser to the provider's consent screen (`window.location.href = url`).
6. After consent, the provider redirects back to `/auth/callback/{provider}?code=...&state=...`.
7. `OAuthCallbackPage` extracts `code` and `state` from the URL, then calls `POST /api/auth/oauth/{provider}/callback` with `{ code, state }`.
8. Backend validates the state JWT (signature + expiry + provider match), exchanges the authorization code for an access token, and fetches user info from the provider API.
9. Backend **finds or creates** the user:
   - First lookup: OAuth account table (provider + provider user ID)
   - Fallback: match by email
   - Last resort: create a new user
10. Backend generates a JWT (24h expiry), caches the user profile in Redis, and returns `{ token, user }`.
11. Frontend stores the JWT in `localStorage`, sets the user in `AuthContext`, and navigates to `/problems`.

## JWT Structure & Validation

### Token Claims

| Claim | Description |
|-------|-------------|
| `jti` | Random UUID — used as the blacklist key on logout |
| `sub` | User ID (numeric) |
| `username` | Display name |
| `role` | `USER` or `ADMIN` |
| `iat` | Issued-at timestamp |
| `exp` | Expiration (24h after issuance, configurable via `app.jwt.expiration-ms`) |

Signed with **HMAC-SHA256** using `app.jwt.secret` (must be at least 256 bits / 32 bytes).

### Request Authentication (`JwtAuthenticationFilter`)

On every request, the filter:

1. Extracts the `Bearer` token from the `Authorization` header.
2. Validates the JWT signature and expiration via jjwt.
3. Parses claims into a `JwtUserPrincipal(id, username, role, tokenId)`.
4. Checks the token blacklist in Redis (if `TokenBlacklistService` is available). If blacklisted, the request proceeds **unauthenticated**.
5. Sets the `SecurityContext` with a `UsernamePasswordAuthenticationToken` carrying `ROLE_USER` or `ROLE_ADMIN`.

### Frontend Token Handling

- **Storage**: `localStorage` key `"token"`
- **Injection**: Axios request interceptor adds `Authorization: Bearer <token>` to every request (`api/client.ts`)
- **401 handling**: Axios response interceptor removes the token and redirects to `/login` on any 401

## Logout & Token Blacklisting

### Flow

1. Frontend calls `POST /api/auth/logout` (fire-and-forget via `authApi.logout().catch(() => {})`).
2. Frontend immediately clears `localStorage` and sets `user` to `null`.
3. Backend `AuthController.logout()`:
   - Extracts the JWT from the `Authorization` header
   - Reads the token ID (`jti`) and expiration
   - Stores `blacklist:{tokenId}` → `"1"` in Redis with TTL = remaining token lifetime
4. Subsequent requests with that token are rejected by `JwtAuthenticationFilter`.

### Redis Key Format

```
blacklist:{tokenId}    →  "1"   (TTL = token expiration - now)
```

Keys auto-expire when the original token would have expired, so no cleanup is needed.

### Graceful Degradation

`TokenBlacklistService` is annotated with `@ConditionalOnBean(StringRedisTemplate.class)` and injected via `@Autowired(required = false)`. If Redis is unavailable:
- Logout still returns 204 (token just isn't blacklisted)
- Token validation skips the blacklist check

## Redis Caching

### User Profile Cache

`UserCacheService` caches serialized `UserProfile` JSON in Redis to avoid database queries on `GET /api/auth/me`.

| Detail | Value |
|--------|-------|
| Key format | `user:{userId}:profile` |
| TTL | 300 seconds (configurable: `app.cache.user-profile-ttl-seconds`) |
| Enabled when | `app.cache.enabled=true` |
| Conditional on | `@ConditionalOnProperty(name = "app.cache.enabled", havingValue = "true")` |

Cache is populated on:
- OAuth login (after user find-or-create)
- `GET /api/auth/me` cache miss

All Redis operations are wrapped in try/catch — failures log a warning and fall through to the database.

## Security Configuration

`SecurityConfig` sets up a fully stateless security chain:

- **Sessions**: `STATELESS` — no server-side session
- **CSRF**: Disabled (JWT-based auth, no cookies)
- **401 handler**: Returns `401 Unauthorized` for unauthenticated requests to protected endpoints

### Authorization Rules

| Pattern | Access |
|---------|--------|
| `GET /api/auth/oauth/*` | Public |
| `POST /api/auth/oauth/*/callback` | Public |
| `GET /api/health` | Public |
| `GET /api/problems`, `GET /api/problems/*` | Public |
| `POST /api/admin/**` | Authenticated (ADMIN role enforced at controller level) |
| Everything else | Authenticated |

## Auth API Endpoints

| Method | Path | Auth | Response |
|--------|------|------|----------|
| `GET` | `/api/auth/oauth/{provider}` | No | `200 { authorizationUrl }` |
| `POST` | `/api/auth/oauth/{provider}/callback` | No | `200 { token, user }` |
| `GET` | `/api/auth/me` | JWT | `200 { id, username, email, role, createdAt }` |
| `POST` | `/api/auth/logout` | JWT | `204 No Content` |

## Configuration Reference

| Property | Default | Description |
|----------|---------|-------------|
| `app.jwt.secret` | Dev fallback key | HMAC-SHA256 signing key (min 256 bits). **Must override in production.** |
| `app.jwt.expiration-ms` | `86400000` (24h) | JWT token lifetime |
| `app.cache.enabled` | `true` | Enable Redis user profile cache and RedisConfig |
| `app.cache.user-profile-ttl-seconds` | `300` | Profile cache TTL |
| `app.oauth.google.client-id` | — | Google OAuth client ID |
| `app.oauth.google.client-secret` | — | Google OAuth client secret |
| `app.oauth.github.client-id` | — | GitHub OAuth client ID |
| `app.oauth.github.client-secret` | — | GitHub OAuth client secret |
| `app.oauth.redirect-base-uri` | `http://localhost:5173/auth/callback` | Base URI for OAuth callbacks |
| `app.oauth.state-expiration-ms` | `300000` (5 min) | OAuth state token lifetime |
| `spring.data.redis.host` | `localhost` | Redis host |
| `spring.data.redis.port` | `6379` | Redis port |

## Key Source Files

### Backend (`backend/src/main/java/com/codebite/`)

| File | Purpose |
|------|---------|
| `auth/controller/AuthController.java` | OAuth URL, callback, `/me`, and logout endpoints |
| `auth/service/AuthService.java` | OAuth flow orchestration, user find-or-create, profile caching |
| `auth/service/TokenBlacklistService.java` | Redis-backed JWT blacklist for logout |
| `auth/service/UserCacheService.java` | Redis-backed user profile cache |
| `auth/jwt/JwtTokenProvider.java` | JWT generation, parsing, and validation |
| `auth/jwt/JwtAuthenticationFilter.java` | Per-request JWT extraction, validation, and blacklist check |
| `auth/jwt/JwtUserPrincipal.java` | Authenticated principal record (id, username, role, tokenId) |
| `auth/oauth/OAuthStateService.java` | State token (signed JWT) generation and validation |
| `auth/oauth/OAuthClientFactory.java` | Returns the correct OAuth provider client |
| `config/SecurityConfig.java` | Spring Security filter chain and authorization rules |
| `config/RedisConfig.java` | Redis template bean (conditional on `app.cache.enabled`) |

### Frontend (`frontend/src/`)

| File | Purpose |
|------|---------|
| `context/AuthContext.tsx` | Auth state management, `loginWithOAuth()`, `logout()` |
| `api/auth.ts` | Auth API calls (OAuth URL, callback, me, logout) |
| `api/client.ts` | Axios instance with JWT interceptor and 401 redirect |
| `pages/LoginPage.tsx` | Google/GitHub login buttons |
| `pages/OAuthCallbackPage.tsx` | Handles OAuth redirect, exchanges code for token |
