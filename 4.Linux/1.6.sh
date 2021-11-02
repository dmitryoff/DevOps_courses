#!/bin/bash

echo "Input 1 syblol"

count=0
while (true); do
read SIGN
if [[ ${#SIGN} -le 1 ]]
then
break
fi
echo "Try again"
done

case "$SIGN" in
  [a-z]   ) echo "The letter in lower case";;
  [A-Z]   ) echo "The letter in upper case";;
  [0-9]   ) echo "Number";;
  *       ) echo "Punctuation mark, space or somesthing other ";;

esac  


