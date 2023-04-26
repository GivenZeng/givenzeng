#!/bin/bash

#用法 hour_range.sh '2018-07-19 10' '2018-07-20 10' 
#订正[start,end] 间的数据

beg_s=`date -d "$1" +%s`
end_s=`date -d "$2" +%s`
echo "处理时间范围：$beg_s 至 $end_s"

while [ "$beg_s" -le "$end_s" ];do
    hour=`date -d @$beg_s +"%Y-%m-%d %H"`;
    echo "当前时间：$hour, beg = $beg_s, end = $end_s"
    beg_s=$((beg_s+3600));
done