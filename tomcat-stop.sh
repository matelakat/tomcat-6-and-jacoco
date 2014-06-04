#!/bin/bash
set -eux

INSTALLED_SERVER_JRE=$(find installed-server-jre -mindepth 1 -maxdepth 1 -type d)
INSTALLED_TOMCAT=$(find installed-tomcat -mindepth 1 -maxdepth 1 -type d)
INSTALLED_TOMCAT=$(readlink -f $INSTALLED_TOMCAT)

JAVA_HOME=$INSTALLED_SERVER_JRE $INSTALLED_TOMCAT/bin/catalina.sh stop
