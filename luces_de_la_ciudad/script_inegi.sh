#! /bin/bash
# Installar innoextract http://constexpr.org/innoextract/
# sudo add-apt-repository ppa:arx/release
# sudo apt-get update
# sudo apt-get install innoextract
# chmod +x download-census-shp.sh
# En mac instalar tambien rename 'brew install rename', 
# Esto hace un script shps con todos los shapefiles

 
# Para hacer compatibles las coordenadas
PROJECCION="+proj=longlat +ellps=WGS84 +no_defs +towgs84=0,0,0"
WGET="wget -w 5 --random-wait --tries=10 "
 
declare -a files=("ageb_urb" "eje_vial" "estatal" "loc_rur" "loc_urb"
    "manzanas" "municipal" "servicios_a" "servicios_l" "servicios_p")
 
declare -a estados=("ags" "bc" "bcs" "camp" "coah" "col" "chis" "chih" 
    "df" "dgo" "gto" "gro" "hgo" "jal" "mex" "mich" "mor" "nay" "nl" "oax" 
    "pue" "qro" "qroo" "slp" "sin" "son" "tab" "tamps" "tlax" "ver" "yuc" 
    "zac");
 
# Con gdal se hace la conversion de coordenadas (tambien installar eso)
# tambien tener cuidado con el encoding
function reproject {
  for i in "${files[@]}"
  do
    ./ogr2ogr.py $1/$2_$i.shp "$1"/$i.shp -t_srs "$PROJECCION"
    rm "$1"/$i*
  done
  # rename
  cd $1/tablas
  rename "s/^cpv2010/$2_cpv2010/" cpv2010*
  rm -rf cpv2010*
  cd ../../..
}
 
for i in {1..32}
do
   if [ $i -lt 10 ]
   then
     FILENUM="0$i"
   else
     FILENUM="$i"
   fi
   $WGET "http://www.inegi.org.mx/sistemas/consulta_resultados/scince2010.aspx?_file=/sistemas/consulta_resultados/scince2010/Scince2010_$FILENUM.exe&idusr=80085" -O ${estados[$i-1]}_scince.exe
   innoextract --lowercase --silent ${estados[$i-1]}_scince.exe 
   mkdir -p shps/${estados[$i-1]}
   cp -r app/$FILENUM/* shps/${estados[$i-1]}
   rm -rf app
   rm -rf tmp
   rm -rf ${estdos[$i - 1]}_scince.exe 
   reproject shps/${estados[$i - 1]} ${estados[$i - 1]}
   sleep 20
done
