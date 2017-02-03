sqlite3 gdelt.db "SELECT * FROM Mexico;" | awk -F "|" '{a[$57]+=$31}END{for(i in a) print i "\t" a[i]}' 
