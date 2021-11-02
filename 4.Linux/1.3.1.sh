#!/bin/bash

echo "1-USD"
echo "2-EUR"
count=0
while [ $count -eq 0 ]
do
read N
if [[ $N -eq 1 ]]
then
wget -q -O - "https://myfin.by/currency/minsk" | grep -oP "span class=.?bl_usd_ex.?>\K.*?(?=<)"|awk  '{print "USD: "$1}'
count=$(( $count + 1 ))
elif [[ $N -eq 2 ]]
then 
wget -q -O - "https://myfin.by/currency/minsk" | grep -oP "span class=.?bl_eur_ex.?>\K.*?(?=<)"|awk  '{print "EUR: "$1}'
count=$(( $count + 1 ))
else
echo "Try again"
fi
done
