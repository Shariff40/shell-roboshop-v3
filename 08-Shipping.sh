#!/bin/bash

app_name=shipping
source ./common.sh
check_root

app_setup
java-setup
systemd_setup

total_time