# angular-cli in a Container

Although it is not really difficult, it took me quite some time to use [angular-cli](https://github.com/angular/angular-cli) on my Mac in a docker container.

This project contains my initial thoughts for easily creating, developing and running an Angular 2 App with docker container.

## General Idea

This project provides 2 Dockerfiles. The first [Dockerfile](Dockerfile) is contained in root and responsible for setting up an image containing a specific version (currently this is v1.0.0-beta.28.3) of angular-cli. It also prepares a non-root user. However, this shouldn't be used until the initial project is created with `ng new`. Root permissions are required to create the project.

Once the initial project is created with base Dockerfile, both files from [docker-app-seed](docker-app-seed) can be copied into the newly created Angular 2 App. These files allow installing all dependencies inside a container and running project specific commands offered by angular-cli (e.g. `ng serve`).

## Creating a new Angular 2 App

You simply copy the [Dockerfile](Dockerfile) and call `docker build -t angular-cli:1.0.0-beta.28.3 .` in the same folder. This will create an image containing the appropriate angular-cli version.

This new image can now be used to create the basis for your new Angular 2 App. Simply call 

```
docker run -it --rm --name create-angular-project -v "$PWD":/home/app angular-cli:1.0.0-beta.28.3 ng new -sn APP_NAME
```

Obviously you should replace `APP_NAME` with the name of the app you like to build.

This finally creates your new app in a subfolder. With the `-sn` option we skip the installation of the complete tooling. This is important, because we don't want to have all the node modules installed in the bind-mounted host folder.

Instead we create another image, which stores the node modules on a separate volume. See [this article](http://jdlm.info/articles/2016/03/06/lessons-building-node-app-docker.html) for an excellent discussion. The next section shows you how to actually build the new image.

## Building a new image for development

Once the app is created with `ng new` we can switch into the folder and build an image with all dependencies. First you need to copy the `Dockerfile` as well as the `docker-compose.yml` file from the `docker-app-seed` folder into your newly created application folder. Once you copied the files you might want to adapt the `APP_NAME` in the `Dockerfile` and the service name in the `docker-compose.yml`.

Finally you can build the image, which compiles and serves your app with:

```
docker-compose build
```

## Serving your new App

Finally you can call `docker-compose up` to serve your new app. It will be accessible on `http://localhost:4200/`. You can see that everything works as expected, if a website with "app works" is shown in your browser.
