#!/bin/bash

source ./common.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "Adding mongo repo"

dnf install mongodb-org -y &>>$logs_file
validate $? "Install mongoDB"

systemctl enable mongod &>>$logs_file
systemctl start mongod &>>$logs_file
validate $? "Enable and start mongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validate $? "Updating remote connections in mongoDB"

systemctl restart mongod &>>$logs_file
validate $? "Restarting mongoDB"

total_time