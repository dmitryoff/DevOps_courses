#!/bin/bash

echo 'Input something:'
read -p "" -t 5 string

if [[ $string != "" ]]
then
echo $string
else
echo -e "\nTime is ove"
fi
