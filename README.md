This is my attempt to learn both how to get a dev environment for [netrunnerdb](https://github.com/alsciende/netrunnerdb) running and how to docker. It more-or-less works, but has some serious flaws. It may be useful for other people setting up a dev environment for netrunnerdb. It is absolutely 1000% not suitable for production.

It clones the relevant git repos inside the docker container. I know this is not ideal, but copying them didn't seem much better for dev purposes, and mounting them as volumes led to ugly permissions issues involving nrdb/var.

In addition, it copies modified versions of web/.htaccess and web/app_dev.php into the netrunnerdb working copy. This causes two problems: You have to remember to not commit these, and any upstream changes will not be seen in a dev environment created with this. I think the second is not likely to be a problem that often, as the originals appear to be provided by Symfony and unmodified, but the first thing is decidedly unfortunate.

To get the containers running:

    docker-compose build
    docker-compose up -d

Then start a bash shell in the main container (substituting the actual image name of the nrdb-dev image):

    docker exec -it image-name bash

And in that bash shell:

    php bin/console doctrine:schema:update --force
    php bin/console app:install:std -f cards

Then visit localhost:8080 to see your new, empty, debug-and-dev-mode netrunnerdb instance.
