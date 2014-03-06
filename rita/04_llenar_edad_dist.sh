  #!/bin/bash

#para correr en paralelo divido el archivo
sed 1d rita.psv | split -l 500000
ls x* | parallel -j +0 --eta "Rscript gorda.R {}"
rm x*
