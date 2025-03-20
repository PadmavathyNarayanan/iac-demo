# Use OpenJDK as base image
FROM openjdk:11
WORKDIR /app
COPY target/myapp.jar myapp.jar
CMD ["java", "-jar", "myapp.jar"]
