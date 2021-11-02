#!/bin/bash

if [[ $EUID -ne 0 ]]; then
echo "script run not by user"
else
echo "script run by user" 
exit
fi
