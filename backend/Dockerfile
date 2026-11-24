FROM eclipse-temurin:21-jdk-jammy AS build
WORKDIR /workspace
COPY gradlew build.gradle settings.gradle ./
COPY gradle gradle
COPY src src
RUN ./gradlew --no-daemon bootJar -x test \
    && mv build/libs/*-SNAPSHOT.jar /ada5.jar

FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=build /ada5.jar /app/ada5.jar
ENV SPRING_PROFILES_ACTIVE=production
USER 10001:10001
EXPOSE 8090
ENTRYPOINT ["java", "-XX:MaxRAMPercentage=45", "-jar", "/app/ada5.jar"]
