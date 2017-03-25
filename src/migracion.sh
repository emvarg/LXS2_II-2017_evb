#/bin/bash


## Definicion de variables
# Ruta a modificar
RUTA=../..
#Permisos de Directorios (D_) y Archivos (F_)
D_PERM=750
F_PERM=660
F_PERM_HARD=640
D_PERM_SOFT=664
F_PERM_SOFT=755

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

# Funcion para cambiar permisos. Primero se pasan los permisos
# a los directorios, luego a los archivos.
set_permisos()
{
        find $3 -type d -exec chmod $1 {} \;
        find $3 -type f -exec chmod $2 {} \;
}

set_especiales()
{

chown root:www-data -R $RUTA
for i in `ls $RUTA/*.txt`; do
        chmod 600 $i
done

chmod 640 $RUTA/robots.txt
chown root:root -R $RUTA/.git
chown root:root  $RUTA/.gitignore
find $RUTA -name "settings.php" -exec chmod 440 {} \;
}

# Esta funcion eventualmente se puede eliminar, eso si se crean
# los "archives" con la bandera -p para que preserve los permisos
set_permisos_files ()
{
        for i in `find $RUTA -name files`
        do
                find $i -type f -exec chmod 664 {} \;
                find $i -type d -exec chmod 755 {} \;
                chown www-data:www-data -R $i
        done
}

#Extraccion de los archivos de todos los sitios
descomprimir_files ()
{
for i in `find $RUTA -name "files.tar.gz"`
do
        TMP_PATH=`echo $i | rev | cut -d\/ -f1 --complement | rev`
        tar xf $i -C $TMP_PATH
done
}

# Instalacion de las bases de datos

install_dbs()
{

for i in `find $RUTA/sites -name "*.mysql" | grep www. `
do
        TMP_VAR=`echo $i | rev | cut -d\/ -f1 | rev| cut -d. -f1`
        echo "Creando base de datos $TMP_VAR"
        echo "create database $TMP_VAR;" | mysql -u root
done

echo "Configurando bases de datos"
mysql -u root < ../misc/bases.mysql

for i in `find $RUTA/sites -name "*.mysql" | grep www. `
do
        TMP_VAR=`echo $i | rev | cut -d\/ -f1 | rev| cut -d. -f1`
        echo "..... Instalando $TMP_VAR"
        mysql -u root $TMP_VAR < $i
done
}

install_apache_configs()
{
tar -pczf /etc/apache2/sites-available.tar.gz /etc/apache2/sites-available 2>> /tmp/error.log
rm /etc/apache2/sites-available/* 
rm /etc/apache2/sites-enabled/* 
cp ../apache2-configs/* /etc/apache2/sites-available/
cd /etc/apache2/sites-enabled
for i in `find ../sites-available -type f`
do 
        ln -s $i `echo $i | rev | cut -d\/ -f1 |rev`
done
cd -
a2enmod rewrite
service apache2 reload
}

################################################################################
# Inicio del programa de migracion
################################################################################

# Instalacion de dependencias
echo Instalando dependencias
if [[ `lsb_release -r | awk '{print $2}'` == 16.04 ]]
then
        echo Distro: Ubuntu 16.04
        apt-get -y install  mysql-server php7.0 php7.0-mysql php7.0-gd apache2 \
        libapache2-mod-php7.0 php7.0-curl mcrypt php7.0-mcrypt php7.0-xml imagemagick
else
        echo Distro: Ubuntu 14.04
        apt-get -y install  mysql-server php5 php5-mysql php5-gd apache2 \
        libapache2-mod-php5 php5-curl mcrypt php5-mcrypt php5-xmlrpc imagemagick
fi

echo "Respaldando permisos de modulos"
tar -pczf /tmp/modules.tar.gz $RUTA/sites/all/modules 2>> /tmp/error.log
echo "Configurando permisos en drupal"
set_permisos $D_PERM $F_PERM_HARD $RUTA
set_permisos $D_PERM $F_PERM $RUTA/sites
echo "Configurando permisos especiales"
set_especiales
echo "Iniciando descompresión de archivos files.tar.gz"
descomprimir_files
echo "Configuración de permisos para los archivos de los sitios"
set_permisos_files
ln -s $RUTA/sites/www.emate.ucr.ac.cr/files $RUTA/sites/default/files
echo "Instalación de módulos"
tar -xf /tmp/modules.tar.gz -C $RUTA
echo "#### Iniciando instalación de bases de datos ####"
install_dbs
echo "Instalación de archivos de configuración de apache2"
install_apache_configs

echo "Migración de sitios web AK7"
exit 0
