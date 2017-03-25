#!/bin/bash

contornos='_seg_contours.png'

procesamiento()
{
echo "
## Inicio del procesamiento de células ##
"
inicio=$(date)

for i in $(seq 13 4 97)
do
	./segmentation out/tmp1/ $1 $i

	for j in $(cat $1 | rev | cut -d \/ -f1 | rev | cut -d. -f1)
	do
		cp out/tmp1/$j$contornos out/segmentadas/$i-$j$contornos
	done
	echo "Lista la corrida para una ventana de $i"
done

fin=$(date)

echo '
*** Procesamiento completo ***
'
echo "Duración:
	Inicio: $inicio
	Fin:    $fin

"
}

conversion()
{
inicio=$(date)
echo "
## Inicio de la conversión a .gif##
"

for j in $(cat $1 | rev | cut -d \/ -f1 | rev |cut -d. -f1)
do
	echo "
	#### Conversión para los archivos:####"
	ls out/segmentadas/*-$j$contornos
	convert -delay 50 -loop 0 out/segmentadas/*-$j$contornos final/FINAL-$j.gif
	echo ".... $j.gif"
done


fin=$(date)

echo '
*** Conversión finalizada ***
'
echo "Duración:
	Inicio: $inicio
	Fin:    $fin

"
}

## Código principal

## Verificación de que existe la carpeta de salida
if [[ !(-d out) || !(-d out/tmp1) || !(-d out/segmentadas) ]]
then
	echo "Creación de carpetas de salida"
	mkdir -p out/{tmp1,segmentadas}
fi

# Ejecución del procesamiento de imagenes
procesamiento $1
# Creación de un .gif con el barrido de umbrales
conversion $1


