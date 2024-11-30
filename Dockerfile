FROM openjdk:21-jdk as build
WORKDIR /workspace/app

COPY target/java.samples.spring.boot*.jar appliaction.jar

RUN ls -la

ENTRYPOINT ["java","-jar", "/workspace/app/appliaction.jar" ]