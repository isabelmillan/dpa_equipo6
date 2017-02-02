#!/usr/bin/env bash

d=; n=0; until [ "$d" = "20161201" ]; do ((n++)); d=$(date -d "today - $n days" +%Y%m%d); echo $d.export.CSV.zip >> fechas.txt;done

[ -d ./archivos ] || cat fechas.txt | parallel -j0 wget http://data.gdeltproject.org/events/\{\} -P ./archivos

csvsql --db sqlite:///gdelt.db --table mexico --insert headers.csv

ls ./archivos/*.export.CSV.zip | parallel gunzip -c {} | awk '($8=="MEX" || $18=="MEX")  {print}' | csvsql --db sqlite:///gdelt.db --table mexico --insert

rm fechas.txt
