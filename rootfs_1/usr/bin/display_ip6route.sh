#!/bin/sh

eval "ip -6 rule"
a=`ip -6 rule | awk -F"lookup " '{print $2}'| sort -u`
for table in $a
do
	cmd="ip -6 route list table "$table
	echo "#"$cmd
	eval $cmd
	echo ""
done




