#!/bin/bash

# Programa para realizar respaldos de documentacion


read -p "Ingrese ruta a respaldar: " dir

echo "Reporte:" >> /tmp/reporte
date >> /tmp/reporte
echo $dir >> /tmp/reporte
du -sh $dir  >> /tmp/reporte

exit 0
