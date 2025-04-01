#!/bin/bash

# Hacer que el script se detenga si algún comando falla
set -e

# Importar la base de datos MySQL
echo "Importando la base de datos..."
sudo mysql -u root < /vagrant/wp-database.sql
sudo systemctl restart mysql

# Descargar WordPress
echo "Descargando WordPress..."
wget https://wordpress.org/latest.tar.gz

# Extraer WordPress
echo "Extrayendo WordPress..."
tar -xvzf latest.tar.gz

# Mover archivos de WordPress al directorio web
echo "Moviendo archivos de WordPress al directorio web..."
sudo mv wordpress/* /var/www/html/

# Copiar el archivo de configuración de WordPress
echo "Copiando wp-config.php..."
sudo cp /vagrant/wp-config.php /var/www/html/

# Ajustar permisos de los archivos
echo "Ajustando permisos de los archivos y directorios..."
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

# Eliminar el archivo index.html predeterminado de Apache
echo "Eliminando index.html predeterminado..."
sudo rm /var/www/html/index.html || true

# Habilitar el módulo de reescritura en Apache
echo "Habilitando módulo de reescritura de Apache..."
sudo a2enmod rewrite

# Reiniciar Apache
echo "Reiniciando Apache..."
sudo systemctl restart apache2

echo "¡Configuración de WordPress completada con éxito! ingresa a http://localhost:8080/"
