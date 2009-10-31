#!/bin/sh

M_IP="192.168.168.101" # Mikrotik IP
FILE="/dev/shm/mikrotik.html"

users(){
	# Use grep and sed to `clean' the file and output only the users number
	grep -e "access.*queue" ${FILE} | sed -e "s/[[:alpha:]]//g" | sed -e "s/[[:blank:]]//g" | sed -e "s/\://g"
}

# Dump the page
links -dump http://${M_IP}:809/graphs/ > ${FILE}

# Output in `csv' format: DATE,USERS
echo `date +%H:%M`,`users`

rm ${FILE}
