#!/bin/bash

THROWS=700
count=1


while [ $count -le $THROWS ]; do
  number=$((1 + RANDOM % 6))
  if [[ $number -eq 1 ]]
  then
  ones=$(( $ones + 1 ))
  elif [[ $number -eq 2 ]]
  then
  twos=$(( $twos + 1 ))
  elif [[ $number -eq 3 ]]
  then
  trees=$(( $trees + 1 ))
  elif [[ $number -eq 4 ]]
  then
  fours=$(( $fours + 1 ))
  elif [[ $number -eq 5 ]]
  then
  fives=$(( $fives + 1 ))
  elif [[ $number -eq 6 ]]
  then
  sixes=$(( $sixes + 1 ))
  fi
  count=$(( $count + 1))
done

echo "units = $ones"
echo "twos  = $twos"
echo "trees = $trees"
echo "fours = $fours"
echo "fives = $fives"
echo "sixes = $sixes"
