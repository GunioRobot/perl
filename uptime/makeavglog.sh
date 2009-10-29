#!/bin/sh

# Igor Lins <snake@bsd.com.br>
# Created 2009-10-20, has be done in 45 minutes
# 	2009-10-24, get avg data from uptime in one line

# Licensed under GPL v2 (?)

	#echo -n `date +%H:%M`,
	#echo -n `uptime | cut -d" " -f12 | tr -d [:blank:]`
	#echo -n `uptime | cut -d" " -f13 | tr -d [:blank:]`
	#echo `uptime | cut -d" " -f14 | tr -d [:blank:]`

echo `date +%H:%M`,`uptime | sed -e 's/.*average: //g'` | tr -d [:blank:]
