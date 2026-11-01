/// <reference types="vitest/config" />
import path from "path"
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  test: {
    // Run every test in the audience's zone, not CI's UTC, so a date formatted in the browser's
    // zone where a UTC day is meant (ADR 0001, ADR 0009) fails here instead of only in Korea.
    env: { TZ: "Asia/Seoul" },
  },
})
