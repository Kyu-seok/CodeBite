# CodeBite Deployment Plan

Target: Self-hosted Linux mini PC, fully containerized with Docker Compose, automated via GitHub Actions CI/CD.

---

## Strategy: Deploy Early, Test Continuously

**Recommendation: Deploy early and iterate** rather than building everything locally first.

Why:
- Catches environment-specific issues (networking, file permissions, DNS, memory limits) early
- You can demo and test the real product from any device on your network
- Keeps deployment scripts and configs battle-tested as the codebase evolves
- Avoids a big-bang deployment where everything breaks at once and you don't know why

Approach:
1. Get a minimal deployment running first (PostgreSQL + backend + frontend)
2. Add Judge0 worker integration later
3. Add CI/CD once manual deploys are stable
4. Iterate — every feature gets deployed and tested on the mini PC

---

## Architecture Overview

```
Mini PC (Linux)
├── Docker Compose
│   ├── postgres       (PostgreSQL 15, persistent volume)
│   ├── backend        (Spring Boot JAR, Java 17)
│   ├── frontend       (Nginx serving Vite build)
│   └── judge0         (Judge0 CE — future)
├── Caddy / Nginx      (reverse proxy, optional HTTPS)
└── GitHub Actions      (self-hosted runner OR SSH deploy)
```

All services run as Docker containers. The frontend is built into static files and served by Nginx (not Vite dev server).

---

## Phase 1: Dockerize Each Service — COMPLETED

### 1.1 Backend Dockerfile

Create `backend/Dockerfile`:

```dockerfile
FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app
COPY gradle/ gradle/
COPY gradlew build.gradle settings.gradle ./
RUN ./gradlew dependencies --no-daemon || true
COPY src/ src/
RUN ./gradlew bootJar --no-daemon

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

Key points:
- Multi-stage build: build stage uses JDK, runtime stage uses JRE only (~half the image size)
- Dependencies are cached in a separate layer for faster rebuilds

### 1.2 Frontend Dockerfile

Create `frontend/Dockerfile`:

```dockerfile
FROM node:22-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
```

Create `frontend/nginx.conf`:

```nginx
server {
    listen 80;
    root /usr/share/nginx/html;
    index index.html;

    # SPA fallback — all routes serve index.html
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Proxy API requests to backend
    location /api/ {
        proxy_pass http://backend:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

This serves the built React app and proxies `/api/*` requests to the backend container — no CORS needed in production.

### 1.x Additional Changes Made During Phase 1

The following files were also created or modified during implementation:

- **`frontend/src/api/client.ts`** — `baseURL` changed from hardcoded `http://localhost:8080/api` to `import.meta.env.VITE_API_URL || "/api"` (relative path works with Nginx proxy in production)
- **`frontend/.env.development`** — created with `VITE_API_URL=http://localhost:8080/api` so local dev (`npm run dev`) still hits the backend directly
- **`backend/.dockerignore`** and **`frontend/.dockerignore`** — created to keep Docker build contexts small
- **`.gitignore` (root)** — created, excludes `infra/.env` and `.idea/`
- **Base images** — changed from `alpine` to `jammy` variants (`eclipse-temurin:17-*-jammy`, `node:22-slim`, `nginx:stable`) because Alpine lacks reliable ARM64 support
- **`backend/config/WebConfig.java`** and **`backend/application.yml`** — updated CORS settings for containerized environment

### 1.3 Production Docker Compose

Create `infra/docker-compose.prod.yml`:

```yaml
services:
  postgres:
    image: postgres:15
    container_name: codebite-postgres
    restart: unless-stopped
    environment:
      POSTGRES_DB: codebite
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - codebite-pgdata:/var/lib/postgresql/data
    networks:
      - codebite

  backend:
    build: ../backend
    container_name: codebite-backend
    restart: unless-stopped
    depends_on:
      - postgres
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/codebite
      SPRING_DATASOURCE_USERNAME: ${DB_USER}
      SPRING_DATASOURCE_PASSWORD: ${DB_PASSWORD}
      JWT_SECRET: ${JWT_SECRET}
      JUDGE0_URL: ${JUDGE0_URL:-http://judge0:2358}
    networks:
      - codebite

  frontend:
    build: ../frontend
    container_name: codebite-frontend
    restart: unless-stopped
    depends_on:
      - backend
    ports:
      - "80:80"
    networks:
      - codebite

volumes:
  codebite-pgdata:

networks:
  codebite:
```

Key points:
- No ports exposed for postgres or backend — only frontend (Nginx) is public-facing
- Nginx proxies `/api/*` to the backend internally via Docker networking
- Secrets are read from environment variables (`.env` file), not hardcoded
- `restart: unless-stopped` keeps services running after crashes or reboots

### 1.4 Environment File

Create `infra/.env.example` (commit this, but NOT the real `.env`):

```env
DB_USER=codebite
DB_PASSWORD=<generate-a-strong-password>
JWT_SECRET=<generate-a-256-bit-secret>
JUDGE0_URL=http://judge0:2358
```

Generate secrets:
```bash
# JWT secret
openssl rand -base64 32

# DB password
openssl rand -base64 16
```

---

## Phase 2: Manual Deployment to Mini PC

Before automating with CI/CD, get a manual deploy working.

### 2.1 Mini PC Setup

```bash
# Install Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Install Docker Compose (v2 comes with Docker now)
docker compose version

# Clone the repo
git clone https://github.com/<your-username>/CodeBite.git
cd CodeBite

# Create .env
cp infra/.env.example infra/.env
# Edit infra/.env with real secrets
```

### 2.2 Build and Run

```bash
cd CodeBite
docker compose -f infra/docker-compose.prod.yml up -d --build
```

### 2.3 Verify

```bash
# Check all containers are running
docker compose -f infra/docker-compose.prod.yml ps

# Check backend health
curl http://localhost/api/problems

# Check frontend
curl http://localhost
```

### 2.4 View Logs

```bash
docker compose -f infra/docker-compose.prod.yml logs -f backend
docker compose -f infra/docker-compose.prod.yml logs -f frontend
```

---

## Phase 3: GitHub Actions CI/CD

### 3.1 Pipeline Overview

```
Push to main
  → Run tests (backend + frontend lint/typecheck)
  → Build Docker images
  → Deploy to mini PC via SSH
```

### 3.2 CI: Test on Every Push

Create `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  push:
    branches: [master]
  pull_request:
    branches: [master]

jobs:
  backend-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          distribution: corretto
          java-version: 17
          cache: gradle
      - run: ./gradlew test
        working-directory: backend

  frontend-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: npm
          cache-dependency-path: frontend/package-lock.json
      - run: npm ci
        working-directory: frontend
      - run: npm run build
        working-directory: frontend
```

### 3.3 CD: Deploy on Push to Master

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches: [master]

jobs:
  deploy:
    runs-on: ubuntu-latest
    needs: []  # add backend-test, frontend-check from ci.yml if using reusable workflows
    steps:
      - name: Deploy via SSH
        uses: appleboy/ssh-action@v1
        with:
          host: ${{ secrets.DEPLOY_HOST }}
          username: ${{ secrets.DEPLOY_USER }}
          key: ${{ secrets.DEPLOY_SSH_KEY }}
          script: |
            cd ~/CodeBite
            git pull origin master
            docker compose -f infra/docker-compose.prod.yml up -d --build
            docker image prune -f
```

### 3.4 GitHub Secrets to Configure

In your GitHub repo → Settings → Secrets and variables → Actions:

| Secret | Value |
|--------|-------|
| `DEPLOY_HOST` | Mini PC's IP or hostname (e.g., `192.168.1.100`) |
| `DEPLOY_USER` | SSH username on the mini PC |
| `DEPLOY_SSH_KEY` | Private SSH key for passwordless login |

### 3.5 Mini PC SSH Setup

```bash
# On your Mac — generate a deploy key
ssh-keygen -t ed25519 -f ~/.ssh/codebite-deploy -N ""

# Copy public key to mini PC
ssh-copy-id -i ~/.ssh/codebite-deploy.pub <user>@<mini-pc-ip>

# Test
ssh -i ~/.ssh/codebite-deploy <user>@<mini-pc-ip> "echo ok"

# Paste the private key content into GitHub secret DEPLOY_SSH_KEY
cat ~/.ssh/codebite-deploy
```

---

## Phase 4: Future Enhancements

These are not needed immediately but worth keeping in mind.

### 4.1 Reverse Proxy with HTTPS (Caddy)

If you want to access CodeBite from outside your LAN or want HTTPS:

```yaml
# Add to docker-compose.prod.yml
caddy:
  image: caddy:2
  ports:
    - "80:80"
    - "443:443"
  volumes:
    - ./Caddyfile:/etc/caddy/Caddyfile
    - caddy_data:/data
```

Then the frontend container removes its port mapping and Caddy handles routing.

### 4.2 Judge0 Integration

Judge0 CE runs as a separate Docker Compose stack (it has its own Redis, Postgres, workers). Plan to either:
- Run Judge0 CE on the same mini PC with a separate compose file
- Use the hosted Judge0 API (if resource-constrained)

### 4.3 Monitoring

- `docker compose logs -f` for basic log tailing
- Consider Uptime Kuma (lightweight, self-hosted) for health checks and alerts

### 4.4 Backups

```bash
# Cron job to back up Postgres data
0 3 * * * docker exec codebite-postgres pg_dump -U codebite codebite | gzip > ~/backups/codebite-$(date +\%F).sql.gz
```

---

## Implementation Order (Checklist)

- [x] Create `backend/Dockerfile`
- [x] Create `frontend/Dockerfile` and `frontend/nginx.conf`
- [x] Create `infra/docker-compose.prod.yml` and `infra/.env.example`
- [x] Add `infra/.env` to `.gitignore`
- [x] Test full stack locally with `docker compose -f infra/docker-compose.prod.yml up --build`
- [ ] Set up mini PC (Docker, clone repo, create `.env`)
- [ ] Manual deploy and verify on mini PC
- [ ] Create `.github/workflows/ci.yml`
- [ ] Create `.github/workflows/deploy.yml`
- [ ] Configure GitHub secrets and SSH keys
- [ ] Push and verify CI/CD pipeline runs end-to-end
- [ ] (Optional) Add Caddy for HTTPS
- [ ] (Optional) Add Judge0 CE
- [ ] (Optional) Add Postgres backup cron
