#!/bin/bash

_FROM=$(date  -v-2d -v-1H "+%d.%m.%Y+%H:00:00")
_TO=$(date -v-1H "+%d.%m.%Y+%H:59:59")
_FROME=$(date -j -f "%d.%m.%Y+%H:%M:%S" $_FROM "+%s")
_TOE=$(date -j -f "%d.%m.%Y+%H:%M:%S" $_TO "+%s")
_OUTFILE=./out.csv

echo $_FROM
echo $_TO
#echo $_FROME
#echo $_TOE

source ./credentials.sh
_DEVICEID=$_DEVICEID1

curl -s -i -k  -X 'POST' \
	-b "PhoneID=$PHONEID" \
 	--data-binary $"deviceid=$_DEVICEID&vendorid=C7BB7FBE-BCEB-48D0-9A49-764A24A6E545&appbundle=de.synertronixx.remotemonitor&fromepoch=$_FROME&toepoch=$_TOE&from=$_FROM&to=$_TO&pagesize=250"\
 	'http://measurements.mobile-alerts.eu/Home/MeasurementDetails' | 
	grep -i -e '</\?TABLE\|</\?TD\|</\?TR\|</\?TH' |
	gsed 's/^[\ \t]*//g' |
	tr -d '\n\r' |
	gsed 's/<\/TR[^>]*>/\n/Ig' |
	gsed 's/<\/\?\(TABLE\|TR\)[^>]*>//Ig' |
	gsed 's/^<T[DH][^>]*>\|<\/\?T[DH][^>]*>$//Ig' |
	gsed 's/<\/T[DH][^>]*><T[DH][^>]*>/;/Ig' |
	tail -n +2 |
	gsed 's/ mm//g' |
	gsed 's/\([0-9][0-9]\).\([0-9][0-9]\).\([0-9][0-9][0-9][0-9]\)/\3-\2-\1/' | # put the date in the right format
	gsed 's/^;//g' > $_OUTFILE

unset _PHONEID
unset _DEVICEID

echo -e ".separator ';' \n.import $_OUTFILE rain_sensor" | sqlite3 /root/bin/mobilealerts/mobilealerts.db
