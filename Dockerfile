# Use a minimal Java 21 runtime image
FROM eclipse-temurin:21-jdk

LABEL authors="sudhin"

# Set working directory
WORKDIR /app

# Copy the jar (built already) into the container
COPY ./target/*.jar /app/app.jar

# Expose port your app uses
EXPOSE 8888

# ENTRYPOINT: run the jar
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
