#!/usr/bin/env bash

d=; n=0; until [ "$d" = "20161201" ]; do ((n++)); d=$(date -d "today - $n days" +%Y%m%d); echo $d.export.CSV.zip >> fechas.txt;done

[ -d ./archivos ] || cat fechas.txt | parallel -j0 wget http://data.gdeltproject.org/events/\{\} -P ./archivos

zip 00000000.export.CSV.zip headers.csv && mv 00000000.export.CSV.zip ./archivos

parallel gunzip -c ::: $(ls ./archivos/*.export.CSV.zip) | awk '($2=="SQLDATE" || $8=="MEX" || $18=="MEX")  {print}' | tee -a salida.txt | csvsql --db sqlite:///gdelt.db --table mexico --insert -t 

awk -F "\t" '($57!="DATEADDED"){a[$57]+=$31;b[$57]+=1}END{for(i in a) print i "\t" b[i] "\t" a[i]/b[i]}' salida.txt >> gs.txt && sed -i "1iDate \t NumberOfOcurrences \t GoldsteinScale" gs.txt && cat gs.txt |  csvsql --db sqlite:///gdelt.db --table mexico_ts --insert -t

rm fechas.txt salida.txt gs.txt
