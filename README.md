# Jenkins Agent Gradle

This project is a docker-based build agent with the capability of building Gradle. Specificaly:

- Gradle 7.6
- OpenJDK 17

More importantly, the process for building **and testing** this agent is fully automated.

# Locally

## Build

I wrote a script to run the underlying command:

```bash
$ ./build.sh 
+ docker build -t jvalentino2/jenkins-agent-gradle .
[+] Building 0.8s (13/13) FINISHED                                                                           
 => [internal] load build definition from Dockerfile                                                    0.0s
 => => transferring dockerfile: 830B                                                                    0.0s
 => [internal] load .dockerignore                                                                       0.0s
 => => transferring context: 2B                                                                         0.0s
 => [internal] load metadata for docker.io/jenkins/agent:latest-jdk11                                   0.8s
 => [auth] jenkins/agent:pull token for registry-1.docker.io                                            0.0s
 => [1/8] FROM docker.io/jenkins/agent:latest-jdk11@sha256:cbafd026949fd9a796eb3d125a4eaa83aa876ac13ba  0.0s
 => CACHED [2/8] RUN apt-get update &&      apt-get install -y gcc &&     apt-get install -y curl &&    0.0s
 => CACHED [3/8] RUN curl -fsSL https://services.gradle.org/distributions/gradle-7.6-all.zip -o gradle  0.0s
 => CACHED [4/8] RUN unzip -d /opt/gradle gradle.zip                                                    0.0s
 => CACHED [5/8] RUN export GRADLE_HOME                                                                 0.0s
 => CACHED [6/8] RUN apt-get update && apt-get install -y openjdk-17-jdk                                0.0s
 => CACHED [7/8] RUN apt-get update &&     apt-get install ca-certificates-java &&     apt-get clean &  0.0s
 => CACHED [8/8] RUN export JAVA_HOME                                                                   0.0s
 => exporting to image                                                                                  0.0s
 => => exporting layers                                                                                 0.0s
 => => writing image sha256:fdbaf2982f50b5122d471c8ffb951d019073e95e519bacccba233d7a1d95b157            0.0s
 => => naming to docker.io/jvalentino2/jenkins-agent-gradle      
```

The result is the image of `jvalentino2/jenkins-agent-gradle`.

## Run

If you want to open a temporary shell into an instance of this image, run the following command:

```bash
$ ./run.sh 
+ docker compose run --rm jenkins_agent_gradle
root@5e02d6963730:/home/jenkins# 
```

This opens a shell into container, where you can do things like verify the version of Gradle and Java in use:

```bash
root@5e02d6963730:/home/jenkins# gradle --version

Welcome to Gradle 7.6!

Here are the highlights of this release:
 - Added support for Java 19.
 - Introduced `--rerun` flag for individual task rerun.
 - Improved dependency block for test suites to be strongly typed.
 - Added a pluggable system for Java toolchains provisioning.

For more details see https://docs.gradle.org/7.6/release-notes.html


------------------------------------------------------------
Gradle 7.6
------------------------------------------------------------

Build time:   2022-11-25 13:35:10 UTC
Revision:     daece9dbc5b79370cc8e4fd6fe4b2cd400e150a8

Kotlin:       1.7.10
Groovy:       3.0.13
Ant:          Apache Ant(TM) version 1.10.11 compiled on July 10 2021
JVM:          17.0.4 (Debian 17.0.4+8-Debian-1deb11u1)
OS:           Linux 5.10.104-linuxkit aarch64
```

when done, just type:

```bash
root@5e02d6963730:/home/jenkins# exit
exit
~/workspaces/personal/jenkins-agent-gradle $ 
```

It will kill the container and put you back at your own shell.

## Test

It is important to know that this container can actually build a gradle project, so I script was included to launch the container and also run a gradle build on the project within the workspace. It will then check for the specific files and return a non-zero exit code if they are not found.

```bash
$ ./test.sh 
+ docker compose run --rm jenkins_agent_gradle sh -c 'cd workspace; ./test.sh'
+ cd example-java-gradle-lib-3
+ gradle clean build

Welcome to Gradle 7.6!

Here are the highlights of this release:
 - Added support for Java 19.
 - Introduced `--rerun` flag for individual task rerun.
 - Improved dependency block for test suites to be strongly typed.
 - Added a pluggable system for Java toolchains provisioning.

For more details see https://docs.gradle.org/7.6/release-notes.html

Starting a Gradle Daemon (subsequent builds will be faster)
> Task :lib:clean
> Task :lib:compileJava
> Task :lib:processResources NO-SOURCE
> Task :lib:classes
> Task :lib:jar
> Task :lib:assemble
> Task :lib:compileTestJava
> Task :lib:processTestResources NO-SOURCE
> Task :lib:testClasses
> Task :lib:test
> Task :lib:jacocoTestReport
> Task :lib:jacocoTestCoverageVerification

> Task :lib:pmdMain
Removed misconfigured rule: LoosePackageCoupling  cause: No packages or classes specified
4 PMD rule violations were found. See the report at: file:///home/jenkins/workspace/example-java-gradle-lib-3/lib/build/reports/pmd/main.html

> Task :lib:pmdTest
Removed misconfigured rule: LoosePackageCoupling  cause: No packages or classes specified
4 PMD rule violations were found. See the report at: file:///home/jenkins/workspace/example-java-gradle-lib-3/lib/build/reports/pmd/test.html

> Task :lib:check
> Task :lib:build

BUILD SUCCESSFUL in 16s
9 actionable tasks: 9 executed
+ echo ' '
 
+ echo Validation...
Validation...
+ '[' '!' -f lib/build/libs/lib.jar ']'
+ '[' '!' -f lib/build/test-results/test/TEST-example.java.gradle.lib.LibraryTest.xml ']'
+ '[' '!' -f lib/build/reports/jacoco/test/html/index.html ']'
+ '[' '!' -f lib/build/reports/pmd/main.html ']'
+ echo 'Validation Done'
Validation Done
$
```

This works by included the project of https://github.com/jvalentino/example-java-gradle-lib-3 in the workspace directory, where the workspace directory is mounted to the container volume via docker compose.

# On Jenkins

TBD