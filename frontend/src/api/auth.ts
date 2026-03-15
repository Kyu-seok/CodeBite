import client from "./client";
import type { AuthResponse, LoginRequest, RegisterRequest, User } from "../types/auth";

export function login(data: LoginRequest) {
  return client.post<AuthResponse>("/auth/login", data);
}

export function register(data: RegisterRequest) {
  return client.post<AuthResponse>("/auth/register", data);
}

export function getMe() {
  return client.get<User>("/auth/me");
}
