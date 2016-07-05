#!/bin/bash
set -eux

(
cd tomcat-dl/
wget -nc https://archive.apache.org/dist/tomcat/tomcat-6/v6.0.41/bin/apache-tomcat-6.0.41.tar.gz
)

TOMCAT_INSTALL=$(find tomcat-dl -name "*.tar.gz")
TOMCAT_INSTALL=$(readlink -f $TOMCAT_INSTALL)

SERVER_JRE_INSTALL=$(find server-jre/ -name "*.tar.gz")

[ -n "$SERVER_JRE_INSTALL" ]

SERVER_JRE_INSTALL=$(readlink -f $SERVER_JRE_INSTALL)
INSTALLED_SERVER_JRE=$(find installed-server-jre -mindepth 1 -maxdepth 1 -type d)

if [ -z "$INSTALLED_SERVER_JRE" ]; then
(
    cd installed-server-jre/
    EXTRACTED_JRE=$(find -mindepth 1 -maxdepth 1 -type d)
    if [ -z "$EXTRACTED_JRE" ] ; then
        tar -xzf $SERVER_JRE_INSTALL
    fi
)
fi

INSTALLED_TOMCAT=$(find installed-tomcat -mindepth 1 -maxdepth 1 -type d)

if [ -z "$INSTALLED_TOMCAT" ]; then
(
    cd installed-tomcat/
    tar -xzf "$TOMCAT_INSTALL"
)
fi

INSTALLED_TOMCAT=$(find installed-tomcat -mindepth 1 -maxdepth 1 -type d)
INSTALLED_TOMCAT=$(readlink -f $INSTALLED_TOMCAT)

JAVA_HOME=$INSTALLED_SERVER_JRE $INSTALLED_TOMCAT/bin/catalina.sh start
