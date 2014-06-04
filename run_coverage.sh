#!/bin/bash
set -eux

./tomcat-stop.sh
./webapp-make-deploy.sh
./tomcat-start.sh

while [ "$(wget -qO - http://localhost:8080/webapp/SimpleServlet/PING)" != "OK" ]; do
    sleep 1
done

