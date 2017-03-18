#!/bin/bash

# Programa para realizar respaldos de documentacion

# Ambos comandos son equivalentes

#read -p "Ingrese ruta a respaldar: " dir
echo "Ingrese ruta a respaldar: "
read dir

echo "Reporte:" >> /tmp/reporte
date >> /tmp/reporte
echo $dir >> /tmp/reporte
du -sh $dir  >> /tmp/reporte

echo Path de ejecucion `pwd`

exit 0
