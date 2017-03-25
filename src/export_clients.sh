#!/bin/bash

# Este script se utiliza para hacer un respaldo de la estructura de
# configuración de los clientes de bacula. Para correr el script
# se debe estar en la misma ruta que clientes.

mkdir dump-configs && cd dump-configs

if  [ $? -ne 0 ]
then
	echo '
	Error en la creación de la carpeta dump-configs
	Este pude ser un problema de permisos o espacio. Revise los
	comandos df -lh y ademas ls -l'
	exit 1
fi

mkdir clientes

find ../clientes/ -name '*.conf' -exec cp --parents \{\} clientes \;

for i in "$(find ../clientes/ | grep pool | cut -d"/" -f2,3,4)"
do
	mkdir -p $i
done

exit 0
