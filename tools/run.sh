#!/bin/bash
echo "mongodb-org hold" | dpkg --set-selections
echo "mongodb-org-server hold" | dpkg --set-selections
echo "mongodb-org-shell hold" | dpkg --set-selections
echo "mongodb-org-mongos hold" | dpkg --set-selections
echo "mongodb-org-tools hold" | dpkg --set-selections
echo "START MONGO"
# systemctl start mongod
# systemctl daemon-reload
# systemctl status mongod
# systemctl enable mongod
## CREATE MONGO DB AUTOMATIC
cd /opt/test-src
npm install
npm run db:seed
# npm start
