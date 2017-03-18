#!/bin/bash

# Programa para realizar respaldos de documentacion

# Ambos comandos son equivalentes
current_pwd=`pwd`
current_pwd=$(pwd)


cd /usr/share/doc
echo Reporte: >> /tmp/reporte
date >> /tmp/reporte
pwd >> /tmp/reporte
du -sh .  >> /tmp/reporte

echo Path de ejecucion `pwd`

cd $current_pwd
