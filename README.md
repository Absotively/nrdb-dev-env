This is my attempt to learn both how to get a dev environment for [netrunnerdb](https://github.com/alsciende/netrunnerdb) running and how to docker. Happily, other people have fixed its worst flaws. It remains absolutely 1000% not suitable for production.

It has the relevant git repos as submodules, and mounts them as docker volumes, with some clunkiness due to symfony's use of a var directory inside the project directory. This results in no changes to the submodule repos from the running server. The database and app volumes are real docker volumes and will persist until you wipe them out.

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

**NOTE:** If you get database errors, it usually just means you haven't waited long enough for the database server to start up. Wait thirty seconds and try again.
