FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app
COPY gradle/ gradle/
COPY gradlew build.gradle settings.gradle ./
COPY common/ common/
COPY backend/build.gradle backend/build.gradle
# The Gradle distribution and dependencies live in a BuildKit cache that outlasts the layers, so
# a deploy downloads neither again; the backend and worker builds share it (Gradle locks its cache).
RUN --mount=type=cache,target=/root/.gradle ./gradlew :backend:dependencies --no-daemon || true
COPY backend/src/ backend/src/
RUN --mount=type=cache,target=/root/.gradle ./gradlew :backend:bootJar --no-daemon

FROM eclipse-temurin:17-jre-jammy
RUN apt-get update && apt-get install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=build /app/backend/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
