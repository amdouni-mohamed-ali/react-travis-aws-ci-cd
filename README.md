# React APP

In this example we will build a simple react application (Hello world app) using the create-react-app. The most important thing i will show is :

    - how to create a dockerfile for the dev platform
    - how to create a dockerfile fot the production platform
    - how to create a docker compose file to automate the running of the dev platform
    - how to add the travis config file to run tests and deploy on aws

This example was taken from the course of  Stephen Grider. You can find it on Udemy :

-  https://www.udemy.com/course/docker-and-kubernetes-the-complete-guide/

## Install

### Development

After cloning the repo, you can build the image using :

    $ docker build -f Dockerfile.dev -t react-app-travis-aws:dev .

    $ docker run -p 3000:3000 -v /app/node_modules -v $(pwd):/app react-app-travis-aws:dev

In this line, we will have an issue if we did not use the '-v /app/node_modules' argument. Because when building the image the node modules inside the container will be overriden because of 'COPY . .' from the docker file.

-v /app/node_modules : to say don't remove or map this folder from the container.

Any time we change the code, theses changes will be propagated to the container and then to your browser.

or you can use the docker-compose.yaml file :

To run it use :

    $ docker-compose up

To build and run :

    $ docker-compose up --build

To stop the app :

    $ docker-compose down

Note that for using docker compose we will run two containers, one to start the app and the second to run tests.

When i used docker compose i tried to connect stdin of the tests container so i can use its console to re-run the tests for example but it doesn't work.

    $ docker attach [CONTAINER_ID]

Why ? : because we are attaching to the standard in (stdin), standard out (stdout) and standard error (stderr) of the primary process of the container (the process with id 1). The primary process in this `npm` (id 1) and not `npm run test`. Actually, when the container runs, it will start two processes the root process which is npm and a second which is npm run test.

To see what's the primary process. Run a shell command on the container and type the command ps.

This is our development environment using docker. Every time we change the source code of the app or the tests, we gonna see these changes immediately on your browser (for the .js files) and on the console used to run docker-compose for tests (.test.js files)

### Production

To build and run the production image, run these commands :

    $ docker build -t react-app-travis-aws:prod .

    $ docker run -p 8080:80 react-app-travis-aws:prod

Before deploying this application, I have created a travis account from here :

- [Travis CI](https://travis-ci.org/)

and i added this repo to travis (check the travis config file `.travis.yml` for more details).

To deploy this app to my amazon platform i've :

1. created a new elastic beans talk application
2. created a new user to be used by travis to deploy the app
3. created two environment variables from travis settings to store the key and the secret
4. used these data (key and the secret) in the travis file
5. each time i accept a pull request now travis will launch jobs to test the app and deploy it to aws
