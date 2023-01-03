FROM jenkins/agent:latest-jdk11
USER root

# Gradle 7.6
RUN apt-get update &&  \
    apt-get install -y gcc && \
    apt-get install -y curl && \
    apt-get install -y unzip

RUN curl -fsSL https://services.gradle.org/distributions/gradle-7.6-all.zip -o gradle.zip
RUN unzip -d /opt/gradle gradle.zip
ENV GRADLE_HOME /opt/gradle/gradle-7.6
RUN export GRADLE_HOME
ENV PATH="${PATH}:/opt/gradle/gradle-7.6/bin"

# Handle using OpenJDK 17 as the Gradle runtime
RUN apt-get update && apt-get install -y openjdk-17-jdk

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-arm64
RUN export JAVA_HOME