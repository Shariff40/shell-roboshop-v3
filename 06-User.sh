#!/bin/bash

app_name=User
source ./common.sh
check_root

app_setup
nodejs_setup
systemd_setup

total_time