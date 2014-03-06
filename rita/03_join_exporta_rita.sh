#!/bin/bash
#para hacer el join y correr en paralelox
sed 1d rita.csv | split -l 500000
ls x* | parallel -j +0 --eta "Rscript join_avion.R {}"
ls *_join | parallel -j +0 --eta "Rscript join_aerop.r {}"
ls *_join | parallel -j +0 --eta "Rscript join_carriers.r {}"
cat *_join > rita.good
cat *_fix > rita.fix
rm x*
rm rita.csv

ls rita.good | parallel -j +0 --eta "cat {} | sed 's/\"//g' > {.}.psv"
rm rita.good
ls rita.fix | parallel -j +0 --eta "cat {} | sed 's/\"//g' > {.}fixme.psv"
rm rita.fix

#creo rita.psv archivo final para procesar con R
cat *.psv > rita.psv

