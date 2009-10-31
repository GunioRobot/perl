#!/bin/sh

CSV="/dev/shm/data.csv"
TMP="/dev/shm/.tmp"
URL="http://192.168.168.100/squid/graph"
LIMITDAY=$((10#`date +%d`-1)) # Actual day of month - 1 day
DATE=$(date +%Y-%m)
i=0

while test $i -lt ${LIMITDAY}; do
	i=$((i+1))
	# To fix the problem with numeration: 1 != 01 (form used by squid-graph)
	if [ $i -lt 10 ]; then
		lynx -auth pen:pceasy -dump ${URL}/${DATE}/0$i/ | grep "Total Accesses" | cut -d":" -f2 | cut -d" " -f2 > ${TMP}
	else
		lynx -auth pen:pceasy -dump ${URL}/${DATE}/$i/ | grep "Total Accesses" | cut -d":" -f2 | cut -d" " -f2 > ${TMP}
	fi
	# Number of accesses
	ACCESSES=`head -n 1 $TMP`
	
	# To fix the problem with numeration: 1 != 01 (form used by squid-graph)
	if [ $i -lt 10 ]; then
		lynx -auth pen:pceasy -dump ${URL}/${DATE}/0$i/ | grep "Total Cache Hits" | cut -d":" -f2 | cut -d" " -f2 > ${TMP}
	else
		lynx -auth pen:pceasy -dump ${URL}/${DATE}/$i/ | grep "Total Cache Hits" | cut -d":" -f2 | cut -d" " -f2 > ${TMP}
	fi
	# N
	TRAFFIC=`head -n 1 $TMP`
	
	# Add to the csv file
	echo $i,$ACCESSES,$TRAFFIC >> $CSV
done

# Move the csv file to local folder to post-processing
mv $CSV .
# Clear temporary file
rm $TMP
