
#CARLOS PETRICIOLI

#nombres de la base
egrep -o "\".*\"" ../../../lecture_2/data/train.csv  | egrep -o -v "\(.*\)" |  cut -d'"' -f2 > nombres.txt
# primer nombre
egrep -o "\".*\"" ../../../lecture_2/data/train.csv | egrep -o "\(.*\)" | cut -d'(' -f2 | cut -d')' -f1 > nombres2.txt

#titulos
egrep -o "\".*\"" ../../../lecture_2/data/train.csv | egrep "\(.*\)" | egrep -o "[A-Z].*\." | cut -d',' -f2 | cut -d'.' -f1 > titulos.txt

# merge sin apodos
paste -d'.' titulos.txt nombres2.txt | egrep -v "\".*\"" > nombres4.txt

# los de apondos para unir despues
egrep -o "\".*\"" ../../../lecture_2/data/train.csv | egrep "\(.*\".*\".*\)" | cut -d'"' -f2 | cut -d'(' -f1 > nombres3.txt
cat nombres.txt nombres3.txt > nombres1.txt
rm nombres.txt nombres3.txt nombres2.txt titulos.txt
cut -d'.' -f2 nombres1.txt | cut -d' ' -f2 > nombres01
cut -d'.' -f2 nombres4.txt | cut -d' ' -f1 > nombres02
cat nombres01 nombres02 > nombres
rm nombres01 nombres02

# a contar
echo "Nombres distintos: "
sort nombres | uniq -c | wc -l
echo "Número por nombre: "
sort nombres | uniq -c | sort -r | head


#PREGINTA 2
#fuera raros
awk '{ sub(",\"","|"); print }' train.csv | awk '{ sub("\",", "|" ); print }' | cut -d"|" -f1 | sed 1d > raro1
awk '{ sub(",\"",",|"); print }' train.csv | awk '{ sub("\",", "|" ); print }' | cut -d"|" -f3 | sed 1d > raro2
paste -d"," raro1 raro2 > subtrain.csv
rm raro1 raro2

#fuera raros
awk '{ sub(",\"","|"); print }' test.csv | awk '{ sub("\",", "|" ); print }' | cut -d"|" -f1 | sed 1d > raro1
awk '{ sub(",\"",",|"); print }' test.csv | awk '{ sub("\",", "|" ); print }' | cut -d"|" -f3 | sed 1d > raro2
paste -d"," raro1 raro2 > subtest.csv
rm raro1 raro2

echo "Estadisticos por columna TRAIN"
awk -F"," '
{ for (i=1; i<=11; ++i){
	sum[i] += $i; 
	sumsq[i]+=$i*$i; 
	if(min[i]=="" && $i != "")
		{min[i]=max[i]=$i}; 
		if($i!="" && $i>max[i])
			{max[i]=$i}; 
			if($i!="" && $i<min[i])
				{min[i]=$i};
					if($i=="")
						{count[i] += 1}
					};
					j=11}
END { for (i=1; i <= j; ++i) printf "Suma: %s \t Desviacion Estandar: %s \t Minimo: %s \t Maximo: %s \t Faltantes: %s \n", sum[i], sqrt(sumsq[i]/NR - (sum[i]/NR)**2), min[i], max[i], count[i]; }
' subtrain.csv

echo "Estadisticos por columna TEST"
awk -F"," '
{ for (i=1; i<=11; ++i){
	sum[i] += $i; 
	sumsq[i]+=$i*$i; 
	if(min[i]=="" && $i != "")
		{min[i]=max[i]=$i}; 
		if($i!="" && $i>max[i])
			{max[i]=$i}; 
			if($i!="" && $i<min[i])
				{min[i]=$i};
					if($i=="")
						{count[i] += 1}
					};
					j=11}
END { for (i=1; i <= j; ++i) printf "Suma: %s \t Desviacion Estandar: %s \t Minimo: %s \t Maximo: %s \t Faltantes: %s \n", sum[i], sqrt(sumsq[i]/NR - (sum[i]/NR)**2), min[i], max[i], count[i]; }
' subest.csv

# PREG 3
echo "\nPREGUNTA 3\n Análisis descriptivo univariado"  >> salida
echo '\nEdad'  >> salida
awk -F',' '{sum += $4; sumsq+=$4*$4; if(min=="" && $4 != "") {min=max=$4}; if($4!="" && $4>max) {max=$4}; if($4!="" && $4<min) {min=$4}; if($4==""){count += 1} } 
END {print "Registros: " NR, "\nFaltantes: " count, "\nMinimo:" min, "\nMaximo: "max, "\nPromedio: " sum/NR, "\nDesviacion Estandar: "sqrt(sumsq/NR - (sum/NR)**2)}' subtest.csv >> salida
echo '\nEsposas' >> salida
awk -F',' '{sum += $5; sumsq+=$5*$5; if(min=="" && $5 != "") {min=max=$5}; if($5!="" && $5>max) {max=$5}; if($5!="" && $5<min) {min=$5}; if($5==""){count += 1} } 
END {print "Registros: " NR, "\nFaltantes: " count, "\nMinimo:" min, "\nMaximo: "max, "\nPromedio: " sum/NR, "\nDesviacion Estandar: "sqrt(sumsq/NR - (sum/NR)**2)}' subtest.csv >> salida
echo '\nPapas y niños' >> salida
awk -F',' '{sum += $6; sumsq+=$6*$6; if(min=="" && $6 != "") {min=max=$6}; if($6!="" && $6>max) {max=$6}; if($6!="" && $6<min) {min=$6}; if($6==""){count += 1} } 
END {print "Registros: " NR, "\nFaltantes: " count, "\nMinimo:" min, "\nMaximo: "max, "\nPromedio: " sum/NR, "\nDesviacion Estandar: "sqrt(sumsq/NR - (sum/NR)**2)}' subtest.csv >> salida
echo '\nPasaje' >> salida
awk -F',' '{sum += $8; sumsq+=$8*$8; if(min=="" && $8 != "") {min=max=$8}; if($8!="" && $8>max) {max=$8}; if($8!="" && $8<min) {min=$8}; if($8==""){count += 1} } 
END {print "Registros: " NR, "\nFaltantes: " count, "\nMinimo:" min, "\nMaximo: "max, "\nPromedio: " sum/NR, "\nDesviacion Estandar: "sqrt(sumsq/NR - (sum/NR)**2)}' subtest.csv >> salida
echo "\nClases: " >> salida 
cut -d',' -f1 subtest.csv | sort | uniq -c >> salida 
echo "\nSexo: " >> salida 
cut -d',' -f2 subtest.csv | sort | uniq -c >> salida 
echo "\nPuerto: " >> salida 
cut -d',' -f9 subtest.csv | sort | uniq -c >> salida 

cat salida

rm subtest.csv subtrain.csv