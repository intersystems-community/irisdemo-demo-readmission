FROM node:10

LABEL maintainer="Phillip Booth <phillip.booth@intersystems.com>"

EXPOSE 4200

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global

WORKDIR /home/node/app

# Adding Node App source code
ADD ./app/ /home/node/app

RUN npm install

CMD npm start