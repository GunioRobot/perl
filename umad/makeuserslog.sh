#!/bin/sh

# Igor Lins <snake@bsd.com.br>
# Created 2009-10-27, based on LAG, has be done in 1h20m

# Licensed under GPL v2 (?)

M_IP="192.168.168.101" # Mikrotik IP
FILE="/dev/shm/mikrotik.html"
THE_PATH="/var/share/snake/shell_script/mk-users"

# Dump the page
links -dump http://${M_IP}:809/graphs/ > ${FILE}

echo `date +%H:%M`,`grep -e "access.*queue" ${FILE} | sed -e "s/[[:alpha:]]//g" | sed -e "s/[[:blank:]]//g" | sed -e "s/\://g"`
rm ${FILE}
