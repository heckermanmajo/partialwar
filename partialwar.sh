#!/bin/bash

current_version="v01"

path_to_this_script=$(readlink -f $0)
without_script_name=${path_to_this_script%/*}
echo $without_script_name

love_path=$without_script_name/love

$love_path $without_script_name/$current_version