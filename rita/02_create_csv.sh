  #!/bin/bash
  
 ls *.bz2 | parallel -j +0 --eta 'bzcat {} > {.}'

header=$(head -1 2002.csv)
rm rita.csv
echo $header >> rita.csv

for year in {1987..2008}
  do
    cat $year.csv | sed '1d' | iconv -f utf-8 -t utf-8 -c  >> rita.csv
  done

#checo que se haya hecho bn comparando contra la lista de aviones y aeropuertos
#Para checar que esté limpia la cola de los aviones hay q hacer join con la basede aviones

ls rita.csv | parallel -j +0 --eta 'cat {} | sed 1d | cut -d',' -f11 | sort | uniq  > {.}.txt'
cat rita.txt | sort | uniq > cola.csv
rm rita.txt

sed 1d carriers.csv | awk 'BEGIN {count = 1 ; FS = "," }; {print count++"|"$1}' > aerolineas.psv
sed 1d plane-data.csv | cut -d',' -f1 | awk 'BEGIN {count = 1}; {print count++"|"$1}' > aviones.psv
sed 1d airports.csv | awk 'BEGIN {count = 1 ; FS = "," }; {print count++"|"$1}' > aeropuertos.psv
