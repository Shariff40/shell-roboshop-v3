#!/bin/bash

app_name=catalogue
source ./common.sh
check_root

app_setup
nodejs_setup
systemd_setup

cp "$scripts_dir/mongo.repo" /etc/yum.repos.d/mongo.repo
validate $? "Adding mongo repo"

dnf install mongodb-mongosh -y &>> $logs_file
validate $? "installing MongoDB Client"


product_count=$(mongosh --host "mongodb.$DOMAIN_NAME" --quiet --eval 'db.getSiblingDB("catalogue").products.countDocuments()' 2>> "$logs_file")
validate $? "Connecting to MongoDB"

if [ "$product_count" -eq 0 ]; then
mongosh --host "mongodb.$DOMAIN_NAME" </app/db/master-data.js &>> $logs_file
validate $? "Loading products"
else
    echo -e "$(timestamp) [INFO] Products are already loaded...${Y}SKIPPING${N}"
fi

restart
total_time