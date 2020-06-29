#!/bin/bash
#run with ./convbin.sh AAAA-MM-DD

source /home/basegnss/rtkbase/settings.conf
cd ${datadir}

for i in $@
do
  echo "#####################################################"
  #find .zip
  zip=$(find . -maxdepth 1 -type f -mmin +1 -name "*$i*" -name "*.zip")
  echo "- Processing on	"$zip
  #find ubx file in zip and extract
  ubx=$(unzip -l $zip "*.ubx" | awk '/-----/ {p = ++p % 2; next} p {print $NF}')
  echo "- Extract	"$ubx
  unzip -o $zip $ubx
  #modify date (AAAA-MM-DD to AAA/MM/DD)
  fdate=$(echo $i| sed  -e 's,-,\/,g')
  #run convbin
  echo "- CREATE RINEX	"${i}-${mnt_name}.${fdate: (-8):2}"o"
  /usr/local/bin/convbin ${ubx} -v 2.11 -r ubx -hm ${mnt_name} \
			-f 2 -y R -y E -y J -y S -y C -y I      \
			-od -os -oi -ot -ti 30 -tt 0 -ro -TADJ=1  \
			-ts ${fdate} 00:01:00  -te ${fdate} 23:59:00 \
			-o ${i}-${mnt_name}.${fdate:(-8):2}o
  echo "- RINEX "${i}-${mnt_name}.${fdate: (-8):2}"o is build"
  echo "#####################################################"
  #remove ubx
  rm $ubx
done
