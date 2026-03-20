import client from "./client";
import type { AuthResponse, OAuthUrlResponse, User } from "../types/auth";

export function getOAuthUrl(provider: string) {
  return client.get<OAuthUrlResponse>(`/auth/oauth/${provider}`);
}

export function oauthCallback(provider: string, code: string, state: string) {
  return client.post<AuthResponse>(`/auth/oauth/${provider}/callback`, { code, state });
}

export function getMe() {
  return client.get<User>("/auth/me");
}

export function logout() {
  return client.post("/auth/logout");
}
