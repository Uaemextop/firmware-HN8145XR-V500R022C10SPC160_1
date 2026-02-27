#! /bin/sh

if [ $# -ne 1 ];then
    echo "ERROR::input para is empty!";
    return 1;
elif [ ${#1} -ne 16 ];then
    echo "ERROR::input length is not right!";
    return 1;
elif expr "$1" : [0-9a-zA-Z]*$ > /dev/null;then
    ampcmd reset ontbysn $1;
    return $?;
else
    echo "ERROR::input para is not right!"
    return 1;
fi