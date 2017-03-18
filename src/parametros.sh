#!/bin/bash

argumentos=3

# Revisar distro
if [[ `lsb_release -r | awk '{print $2}'` == 16.04 || `lsb_release -r | awk '{print $2}'` == 14.04 ]]
then
        echo "Distribución soportada"
else
        echo "ERROR:
        Distribición _NO_ soportada, este script fue desarrollado para correr
        en las versiones de Ubuntu 14.04 o 16.04"
        exit 1
fi

# Revisar si el script se ejecuta como root
if [ $UID != 0 ]; then
        echo "Error:
        Este programa sólo puede ser ejecutado por root"
        exit 1
fi

# Si no existe el archivo con la clave de root para mysql
# se detiene la instalación.

if [[ !(-f /root/.my.cnf) ]]
then
        echo"Error:
        No se pueden instalar las bases de datos.
        Verifique que existe el archivo /root/.my.cnf con
        las credenciales de root"
        exit 1
fi


if [ $# -eq $argumentos ]
then
	echo El numero de parametros fue correcto
	if [ $1 = perro ]
	then
		echo El parametro '$1' fue $1
	fi
else
	echo El numero de parametros fue incorrecto
	echo Se pasaron $# argumentos
fi

echo fin de script
exit 0	
