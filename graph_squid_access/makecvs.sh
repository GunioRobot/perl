#!/bin/sh

CVS='/dev/shm/data.cvs'
TMP='/dev/shm/.tmp'
URL='http://189.2.128.194/squid/graph'
LIMITDAY=$((10#`date +%d`-1)) # Actual day of month - 1 day
DATE=$(date +%Y-%m)
i=0

while test $i -lt ${LIMITDAY}; do
	i=$((i+1))
	# To fix the problem with numeration: 1 != 01 (form used by squid-graph)
	if [ $i -lt 10 ]; then
		lynx -auth pceasy:#embratel# -dump ${URL}/${DATE}/0$i/ | grep "Total Accesses" | cut -d":" -f2 | cut -d" " -f2 > ${TMP}
	else
		lynx -auth pceasy:#embratel# -dump ${URL}/${DATE}/$i/ | grep "Total Accesses" | cut -d":" -f2 | cut -d" " -f2 > ${TMP}
	fi
	# Number of accesses
	ACCESSES=`head -n 1 $TMP`
	
	# To fix the problem with numeration: 1 != 01 (form used by squid-graph)
	if [ $i -lt 10 ]; then
		lynx -auth pceasy:#embratel# -dump ${URL}/${DATE}/0$i/ | grep "Total Cache Hits" | cut -d":" -f2 | cut -d" " -f2 > ${TMP}
	else
		lynx -auth pceasy:#embratel# -dump ${URL}/${DATE}/$i/ | grep "Total Cache Hits" | cut -d":" -f2 | cut -d" " -f2 > ${TMP}
	fi
	# N
	TRAFFIC=`head -n 1 $TMP`
	
	# Add to the cvs file
	echo $i,$ACCESSES,$TRAFFIC >> $CVS
done

# Move the CVS file to local folder to post-processing
mv $CVS .
# Clear temporary file
rm $TMP
