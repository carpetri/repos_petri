 cut -d'"' -f2 titanic.csv
 grep '"' titanic.csv | cut -d'"' -f2 | cut -d',' -f2 | cut -d'.' -f1 | sort -k 1 | uniq -c
 grep "Mrs\." titanic.csv | cut -d'"' -f2 | cut -d"(" -f2 | cut -d')' -f1
 grep '"' titanic.csv | grep -v "Mrs\." | cut -d'"' -f2
 ##La respuesta de la broma es CUALQUIER COSA!