# our node:alpine image and all its content gonna be referenced by the builder phase
FROM node:alpine as builder 

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

RUN npm run build

# the build phase has finished
# starting the run phase - it's gonna be an nginx image

FROM nginx

# well, we added this line (expose 80) because of elastic beans talk. he will map ports from outside to
# the docker container based on the expose instructions. in our example, he will map all the traffix to the port 80
EXPOSE 80

COPY --from=builder /app/build /usr/share/nginx/html

# static content must be placed under /usr/share/nginx/html to be served by nginx
# that's it. the default nginx command will start nginx for us
