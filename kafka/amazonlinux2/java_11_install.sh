#!/bin/bash

curl -L https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.rpm -o java11.rpm
yum localinstall java11.rpm -y
