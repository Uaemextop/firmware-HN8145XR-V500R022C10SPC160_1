#/bin/sh
date

if [ -e /var/gmacdrv_fault ];
then
    cat /var/gmacdrv_fault;
fi

if [ -e /var/gmacdrv_collect ];
then
    cat /var/gmacdrv_collect;
fi

if [ -e /var/fttr_zg_seuTest ];
then
    cat /var/fttr_zg_seuTest;
fi

if [ -e /var/fttr_temp_record ];
then
    cat /var/fttr_temp_record;
fi

echo  "End to collect the data"

date
exit 0;