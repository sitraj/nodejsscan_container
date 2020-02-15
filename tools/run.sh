#!/bin/bash

cd /opt/test-src
pwd
echo "mongodb-org hold" | dpkg --set-selections
echo "mongodb-org-server hold" | dpkg --set-selections
echo "mongodb-org-shell hold" | dpkg --set-selections
echo "mongodb-org-mongos hold" | dpkg --set-selections
echo "mongodb-org-tools hold" | dpkg --set-selections
echo "START MONGO"
systemctl start mongod
systemctl daemon-reload
systemctl status mongod
systemctl enable mongod
## CREATE MONGO DB AUTOMATIC
npm install
npm run db:seed
# npm start
