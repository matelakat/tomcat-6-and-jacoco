#!/bin/bash
set -eux

INSTALLED_SERVER_JRE=$(find installed-server-jre -mindepth 1 -maxdepth 1 -type d)

INSTALLED_TOMCAT=$(find installed-tomcat -mindepth 1 -maxdepth 1 -type d)
INSTALLED_TOMCAT=$(readlink -f $INSTALLED_TOMCAT)

(
cd maven-dl/
wget -nc https://archive.apache.org/dist/maven/binaries/apache-maven-3.2.1-bin.tar.gz
)
MAVEN_INSTALL=$(find maven-dl/ -name "*.tar.gz")
MAVEN_INSTALL=$(readlink -f $MAVEN_INSTALL)

INSTALLED_MAVEN=$(find installed-maven -mindepth 1 -maxdepth 1 -type d)

if [ -z "$INSTALLED_MAVEN" ]; then
(
    cd installed-maven/
    tar -xzf "$MAVEN_INSTALL"
)
fi

INSTALLED_MAVEN=$(find installed-maven -mindepth 1 -maxdepth 1 -type d)
INSTALLED_MAVEN=$(readlink -f $INSTALLED_MAVEN)

MVN=$INSTALLED_MAVEN/bin/mvn

(
cd webapp
$MVN clean
$MVN compile
$MVN package
)

WARFILE=$(find webapp/ -name "*.war")
rm -rf $INSTALLED_TOMCAT/webapps/webapp

cp $WARFILE $INSTALLED_TOMCAT/webapps/
