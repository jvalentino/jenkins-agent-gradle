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

# we can't go higher than JDK 11 or Gradle starts to break