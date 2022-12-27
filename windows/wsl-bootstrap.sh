#!/bin/bash

sudo echo <<-WSL_CONF > /etc/wsl.conf
[boot]
systemd=true
WSL_CONF
