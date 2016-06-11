#!/bin/bash


_FROM="03.06.2016+00%3A00"
_FROME=1464904805
_TO="03.06.2016+23%3A59"
_TOE=1464991140

source ./credentials.sh

curl -i -s -k  -X 'POST' \
	-b "PhoneID=$PHONEID" \
 	--data-binary $"deviceid=$_DEVICEID&vendorid=C7BB7FBE-BCEB-48D0-9A49-764A24A6E545&appbundle=de.synertronixx.remotemonitor&fromepoch=$_FROME&toepoch=$_TOE&from=$_FROM&to=$_TO&pagesize=250"\
 	'http://measurements.mobile-alerts.eu/Home/MeasurementDetails' | \
	grep -i -e '</\?TABLE\|</\?TD\|</\?TR\|</\?TH' | \
	sed 's/^[\ \t]*//g' \
	| tr -d '\n\r' \
	| sed 's/<\/TR[^>]*>/\n/Ig' \
	| sed 's/<\/\?\(TABLE\|TR\)[^>]*>//Ig' \
	| sed 's/^<T[DH][^>]*>\|<\/\?T[DH][^>]*>$//Ig' \
	| sed 's/<\/T[DH][^>]*><T[DH][^>]*>/;/Ig'

unset _PHONEID
unset _DEVICEID

