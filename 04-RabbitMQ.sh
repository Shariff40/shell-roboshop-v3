#!/bin/bash

source ./common.sh

check_root

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
validate $? "Adding rabbitmq repo"

dnf install rabbitmq-server -y &>> $logs_file
validate $? "Installing erlang and rabbitmq-server"

systemctl Starting rabbitmq-server &>> $logs_file
systemctl Enabling rabbitmq-server &>> $logs_file
validate $? "start and enable rabbitmq-server"
 
rabbitmqctl list_users | grep -qw "roboshop"
if [ $? -ne 0 ]; then
      rabbitmqctl add_user roboshop roboshop123 &>> $logs_file
      validate $? "creating rabbitmq user for roboshop"
else
    echo -e "$(timestamp) [INFO] rabbitmq user already exists.. ${Y}SKIPPING${N}"
fi
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $logs_file
validate $? "creating rabbitmq user for roboshop"

total_time