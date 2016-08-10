#!/bin/bash

_FROME=$(date -d "10 days ago" "+%s")
_OUTFILE=./out.csv

#echo $_FROME

source /root/bin/mobilealerts/credentials.sh
_DEVICEID=$_DEVICEID1

# rain sensor
_DEVICEID=$_DEVICEID1
curl -s -i -k  -X 'POST' \
	-b "PhoneID=$PHONEID" \
 	--data-binary $"deviceid=$_DEVICEID&vendorid=C7BB7FBE-BCEB-48D0-9A49-764A24A6E545&appbundle=de.synertronixx.remotemonitor&pagesize=2500"\
 	'http://measurements.mobile-alerts.eu/Home/MeasurementDetails' | 
	grep -i -e '</\?TABLE\|</\?TD\|</\?TR\|</\?TH' |
	sed 's/^[\ \t]*//g' |
	tr -d '\n\r' |
	sed 's/<\/TR[^>]*>/\n/Ig' |
	sed 's/<\/\?\(TABLE\|TR\)[^>]*>//Ig' |
	sed 's/^<T[DH][^>]*>\|<\/\?T[DH][^>]*>$//Ig' |
	sed 's/<\/T[DH][^>]*><T[DH][^>]*>/;/Ig' |
	tail -n +2 |
	sed 's/ mm//g' |
	sed 's/\([0-9][0-9]\).\([0-9][0-9]\).\([0-9][0-9][0-9][0-9]\)/\3-\2-\1/' | # put the date in the right format
	sed 's/^;//g' > $_OUTFILE
echo -e ".separator ';' \n.import $_OUTFILE sensor_rain" | sqlite3 /root/bin/mobilealerts/mobilealerts.db

# temp sensor
_DEVICEID=$_DEVICEID0
curl -s -i -k  -X 'POST' \
	-b "PhoneID=$PHONEID" \
 	--data-binary $"deviceid=$_DEVICEID&vendorid=C7BB7FBE-BCEB-48D0-9A49-764A24A6E545&appbundle=de.synertronixx.remotemonitor&pagesize=2500"\
 	'http://measurements.mobile-alerts.eu/Home/MeasurementDetails' | 
	grep -i -e '</\?TABLE\|</\?TD\|</\?TR\|</\?TH' |
	sed 's/^[\ \t]*//g' |
	tr -d '\n\r' |
	sed 's/<\/TR[^>]*>/\n/Ig' |
	sed 's/<\/\?\(TABLE\|TR\)[^>]*>//Ig' |
	sed 's/^<T[DH][^>]*>\|<\/\?T[DH][^>]*>$//Ig' |
	sed 's/<\/T[DH][^>]*><T[DH][^>]*>/;/Ig' |
	tail -n +2 |
	sed 's/ C//g' |
	sed 's/%//g' |
	sed 's/\([0-9][0-9]\).\([0-9][0-9]\).\([0-9][0-9][0-9][0-9]\)/\3-\2-\1/' | # put the date in the right format
	sed 's/^;//g' > $_OUTFILE
echo -e ".separator ';' \n.import $_OUTFILE sensor_temp" | sqlite3 /root/bin/mobilealerts/mobilealerts.db
cp $_OUTFILE temp.csv

# wind sensor
_DEVICEID=$_DEVICEID2
curl -s -i -k  -X 'POST' \
	-b "PhoneID=$PHONEID" \
 	--data-binary $"deviceid=$_DEVICEID&vendorid=C7BB7FBE-BCEB-48D0-9A49-764A24A6E545&appbundle=de.synertronixx.remotemonitor&pagesize=2500"\
 	'http://measurements.mobile-alerts.eu/Home/MeasurementDetails' | 
	grep -i -e '</\?TABLE\|</\?TD\|</\?TR\|</\?TH' |
	sed 's/^[\ \t]*//g' |
	tr -d '\n\r' |
	sed 's/<\/TR[^>]*>/\n/Ig' |
	sed 's/<\/\?\(TABLE\|TR\)[^>]*>//Ig' |
	sed 's/^<T[DH][^>]*>\|<\/\?T[DH][^>]*>$//Ig' |
	sed 's/<\/T[DH][^>]*><T[DH][^>]*>/;/Ig' |
	tail -n +2 |
	sed 's/ m\/s//g' |
	sed 's/\([0-9][0-9]\).\([0-9][0-9]\).\([0-9][0-9][0-9][0-9]\)/\3-\2-\1/' | # put the date in the right format
	sed 's/^;//g' > $_OUTFILE
echo -e ".separator ';' \n.import $_OUTFILE sensor_wind" | sqlite3 /root/bin/mobilealerts/mobilealerts.db
cp $_OUTFILE wind.csv

# 	--data-binary $"deviceid=$_DEVICEID&vendorid=C7BB7FBE-BCEB-48D0-9A49-764A24A6E545&appbundle=de.synertronixx.remotemonitor&fromepoch=$_FROME&toepoch=$_TOE&from=$_FROM&to=$_TO&pagesize=250"\
unset _PHONEID
unset _DEVICEID

