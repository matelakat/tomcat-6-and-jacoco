#!/bin/bash
set -eux

(
    cd jacoco-dl/
    wget -nc http://repo1.maven.org/maven2/org/jacoco/org.jacoco.agent/0.7.1.201405082137/org.jacoco.agent-0.7.1.201405082137.jar
)
JACOCO_INSTALL=$(find jacoco-dl -name "*.jar")
JACOCO_INSTALL=$(readlink -f "$JACOCO_INSTALL")


INSTALLED_JACOCOAGENT=$(find installed-jacoco -name "jacocoagent.jar")

if [ -z "$INSTALLED_JACOCOAGENT" ]; then
(
    cd installed-jacoco/
    unzip "$JACOCO_INSTALL"
)
fi

INSTALLED_JACOCOAGENT=$(find installed-jacoco -name "jacocoagent.jar")

./tomcat-stop.sh
sleep 5
rm -f *.exec

./webapp-make-deploy.sh

JAVA_OPTS="-javaagent:$INSTALLED_JACOCOAGENT" ./tomcat-start.sh

while [ "$(wget -qO - http://localhost:8080/webapp/SimpleServlet/PING)" != "OK" ]; do
    sleep 1
done

wget -qO - http://localhost:8080/webapp/SimpleServlet/BRANCH1

./tomcat-stop.sh
sleep 5

mv jacoco.exec branch1.exec

JAVA_OPTS="-javaagent:$INSTALLED_JACOCOAGENT" ./tomcat-start.sh

while [ "$(wget -qO - http://localhost:8080/webapp/SimpleServlet/PING)" != "OK" ]; do
    sleep 1
done

wget -qO - http://localhost:8080/webapp/SimpleServlet/BRANCH2

./tomcat-stop.sh
sleep 5

mv jacoco.exec branch2.exec

INSTALLED_MAVEN=$(find installed-maven -mindepth 1 -maxdepth 1 -type d)
INSTALLED_MAVEN=$(readlink -f $INSTALLED_MAVEN)
MVN=$INSTALLED_MAVEN/bin/mvn

(
    cd webapp/
    $MVN jacoco:merge
    $MVN jacoco:report
)

JACOCO_REPORT_DIR=$(find webapp -name jacoco -type d)
JACOCO_REPORT_DIR=$(readlink -f $JACOCO_REPORT_DIR)

cat << EOF

FIND THE COVERAGE REPORT AT:

$JACOCO_REPORT_DIR/index.html

EOF
