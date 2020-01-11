# React APP

## commands

### Dev

Build image :

    $ docker build -f Dockerfile.dev -t react-app-travis-aws:dev .

In this line, we will have an issue if we did not use the '-v /app/node_modules' argument. Because when building the image the node modules
inside the container will be overriden because of 'COPY . .' from the docker file.

-v /app/node_modules : to say don't remove or map this folder from the container.

    $ docker run -p 3000:3000 -v /app/node_modules -v $(pwd):/app react-app-travis-aws

Any time we change the code, theses changes will be propagated to the container and then to your browser.

or you can use the docker-compose.yaml file :

    $ docker-compose up

    $ docker-compose up --build

    $ docker-compose down

we are attaching to the standard in (stdin), standard out (stdout) and standard error (stderr) of the primary process of the container (the process with id 1).

    $ docker attach [CONTAINER_ID]

To see what's the primary process. Run a shell command on the container and type the command ps.

This is our development environment using docker. Every time we change the source code of the app or the tests, we gonna see these changes immediately on your browser (for the .js files) and on the console used to run docker-compose for tests (.test.js files)

### Production

    $ docker build -t react-app-travis-aws:prod .

    $ docker run -p 8080:80 react-app-travis-aws:prod
