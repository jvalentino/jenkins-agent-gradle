#!/bin/bash
set -x
cd example-java-gradle-lib-3
gradle clean build

echo " "
echo "Validation..."
[ ! -f lib/build/libs/lib.jar ] && echo "lib/build/libs/lib.jar does not exist." && exit 1
[ ! -f lib/build/test-results/test/TEST-example.java.gradle.lib.LibraryTest.xml ] && echo "lib/build/test-results/test/TEST-example.java.gradle.lib.LibraryTest.xml does not exist." && exit 1
[ ! -f lib/build/reports/jacoco/test/html/index.html ] && echo "lib/build/reports/jacoco/test/html/index.html does not exist." && exit 1
[ ! -f lib/build/reports/pmd/main.html ] && echo "lib/build/reports/pmd/main.html does not exist." && exit 1

echo "Validation Done"