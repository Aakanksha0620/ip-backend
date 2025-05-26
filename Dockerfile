# -------- Stage 1: Build --------
FROM gradle:8.4.0-jdk17 AS builder
WORKDIR /app

# Copy Gradle wrapper and project files
COPY build.gradle settings.gradle ./
COPY gradle gradle
COPY src src

# Build the project
RUN gradle build --no-daemon

# -------- Stage 2: Run --------
FROM openjdk:17-slim
WORKDIR /app

# Copy only the JAR from the builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Start the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
