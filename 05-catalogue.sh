#!/bin/bash

app_name=Catalouge
source ./common.sh
check_root

app_setup
nodejs_setup
system_setup

cp "$scripts_dir/mongo.repo" /etc/yum.repos.d/mongo.repo
validate $? "Adding mongo repo"

dnf install mongodb-mongosh -y &>> $logs_file
validate $? "installing MongoDB Client"


product_count=$(mongosh --host "mongodb.$domain_name" --quiet --eval 'db.getSiblingDB("$app_name").products.countDocuments()' 2>> "$logs_file")
validate $? "Connecting to MongoDB"

if [ "$product_count" -eq 0 ]; then
mongosh --host "mongodb.$domain_name" </app/db/master-data.js &>> $logs_file
validate $? "Loading products"
else
    echo -e "$(timestamp) [INFO] Products are already loaded...${Y}SKIPPING${N}"
fi

total_time