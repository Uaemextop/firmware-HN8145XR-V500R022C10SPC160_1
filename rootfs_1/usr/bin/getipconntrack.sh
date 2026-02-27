#! /bin/sh

if [ 0 -ne $# ]; then
    echo "ERROR::input para is not right!"
    exit 1
fi

file=/var/nfct_cmd/nf_conntrack

if [ -f ${file} ] || [ -h ${file} ]; then
    rm -f ${file}
fi

touch ${file}

Bbspcmd nfct_get conntrack

for i in 1 2 3 4 5
do
    if [ -s ${file} ]; then
        break;
    fi
    sleep 1
done

usleep 10000

cat ${file}
rm -f ${file}

