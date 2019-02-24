#!/bin/bash

set -e
set -u

CHOWN="chown -R www-data:www-data"

# Set up permissions and copy/link files on the volumes.
echo "Preparing /var/www/html/nrdb/app/config/"
for FILE in $(ls netrunnerdb/app/config/)
do
  BASE_FILE=$(basename ${FILE})
  docker exec -it nrdb-dev bash -c "ln -s /var/www/html/nrdb-app-config/${BASE_FILE} /var/www/html/nrdb/app/config/${BASE_FILE}"
done
docker exec -it nrdb-dev bash -c "cp /var/www/html/nrdb-app-config-parameters.yml /var/www/html/nrdb/app/config/parameters.yml"
docker exec -it nrdb-dev bash -c "${CHOWN} /var/www/html/nrdb/app/config"

# Link up files from web, minus bundles and app_dev.php
echo "Preparing /var/www/html/nrdb/web/"
for FILE in $(ls netrunnerdb/web/ | grep -v bundles | grep -v app_dev.php)
do
  BASE_FILE=$(basename ${FILE})
  docker exec -it nrdb-dev bash -c "ln -s /var/www/html/nrdb-web/${BASE_FILE} /var/www/html/nrdb/web/${BASE_FILE}"
done
docker exec -it nrdb-dev bash -c "${CHOWN} /var/www/html/nrdb/web"
docker exec -it nrdb-dev bash -c "mkdir /var/www/html/nrdb/web/bundles"
docker exec -it nrdb-dev bash -c "${CHOWN} /var/www/html/nrdb/web/bundles"

docker exec -it nrdb-dev bash -c "cp /var/www/html/nrdb-bin/* /var/www/html/nrdb/bin/"
docker exec -it nrdb-dev bash -c "${CHOWN} /var/www/html/nrdb/bin"
docker exec -it nrdb-dev bash -c "${CHOWN} /var/www/html/nrdb/var"
docker exec -it nrdb-dev bash -c "${CHOWN} /var/www/html/nrdb/vendor"

# Run composer install as www-data instead of root.
docker exec -it nrdb-dev bash -c "su -s /bin/bash www-data -c 'composer install'"

echo "Initializing the database and importing the card data."
docker exec -it nrdb-dev bash -c "php bin/console doctrine:schema:update --force; php bin/console app:import:std -f cards"

echo "TODO: import card images"

echo "All done!"
