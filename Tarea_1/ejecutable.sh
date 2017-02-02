#!/usr/bin/env bash

d=; n=0; until [ "$d" = "20161201" ]; do ((n++)); d=$(date -d "today - $n days" +%Y%m%d); echo $d.export.CSV.zip >> fechas.txt;done

[ -d ./archivos ] || cat fechas.txt | parallel -j0 wget http://data.gdeltproject.org/events/\{\} -P ./archivos

touch noticias.csv
cat headers.csv > noticias.csv
#csvsql --db sqlite:///gdelt.db --table mexico --insert -t headers.csv

sleep 1

#ls ./archivos/*.export.CSV.zip | parallel gunzip -c {} | awk '($8=="MEX" || $18=="MEX")  {print}' | csvsql --db sqlite:///gdelt.db --table mexico --insert -t

ls ./archivos/*.export.CSV.zip | parallel gunzip -c {} | awk '($8=="MEX" || $18=="MEX")  {print}' >> noticias.csv

csvsql --db sqlite:///gdelt.db --table mexico --insert -t noticias.csv

rm fechas.txt noticias.csv
