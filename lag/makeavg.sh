#!/bin/sh

avg(){
	# Only output the avg, without spaces
	uptime | sed -e 's/.*average: //g' | tr -d [:blank:]
}

# Output in `csv' format: DATE,AVG-1,AVG-5,AVG-15
echo `date +%H:%M`,`avg`
