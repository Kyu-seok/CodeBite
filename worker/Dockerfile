FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app
COPY gradle/ gradle/
COPY gradlew build.gradle settings.gradle ./
COPY common/ common/
COPY worker/build.gradle worker/build.gradle
RUN ./gradlew :worker:dependencies --no-daemon || true
COPY worker/src/ worker/src/
RUN ./gradlew :worker:bootJar --no-daemon

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/worker/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
