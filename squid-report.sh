#!/bin/bash
set -e

[ -e squid-report ] || mkdir squid-report
sudo calamaris -a -o html /var/log/squid/access.log -F html,graph --output-path squid-report
xdg-open squid-report/index.html
