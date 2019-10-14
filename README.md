This is my attempt to learn both how to get a dev environment for [netrunnerdb](https://github.com/alsciende/netrunnerdb) running and how to docker. It more-or-less works, but has some serious flaws. It may be useful for other people setting up a dev environment for netrunnerdb. It is absolutely 1000% not suitable for production.

It clones the relevant git repos inside the docker container. I know this is not ideal, but copying them didn't seem much better for dev purposes, and mounting them as volumes led to ugly permissions issues involving nrdb/var.

The Docker setup is a little clunky, but does result in no changes to the submodule repos from the running server. The database and app volumes are real docker volumes and will persist until you wipe them out.

All file changes should be picked up without restarting docker with the exception of .htaccess and app_dev.php since those are copied into the image.

You will need both docker and docker-compose.

First you have to actually fetch the submodules:

```sh
git submodule init
git submodule update
```

To get the containers running:

```sh
docker-compose build
docker-compose up -d
```

Now prepare the rest of the files for the images and set up the database:
```sh
./docker-first-run.sh
```

Then visit [localhost:8080](http://localhost:8080) to see your new, empty, debug-and-dev-mode netrunnerdb instance.

**NOTE:** If you get database errors in the last step, for instance when you rebuild the containers after some changes, it usually just means you haven't waited long enough for the database server to start up. Wait thirty seconds and try again.

To update the card data, first update the submodule for the cards, then run ./import-cards.sh while your docker image is running.
