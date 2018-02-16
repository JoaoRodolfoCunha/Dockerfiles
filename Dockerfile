FROM node:8-alpine

ARG NG_CLI_VERSION=1.5.4
ARG USER_HOME_DIR="/tmp"
ARG APP_DIR="/app"
ARG USER_ID=1000

RUN set -xe \
    && mkdir -p $USER_HOME_DIR \
    && chown $USER_ID $USER_HOME_DIR \
    && chmod a+rw $USER_HOME_DIR \
    && chown -R node /usr/local/lib /usr/local/include /usr/local/share /usr/local/bin \
    && (cd "$USER_HOME_DIR"; su node -c "npm install -g @angular/cli@$NG_CLI_VERSION; npm install -g yarn; npm cache clean --force")

WORKDIR $APP_DIR

COPY . $APP_DIR

EXPOSE 4200

FROM nginx:alpine
COPY ./dist /usr/share/nginx/html
EXPOSE 80 443
ENTRYPOINT ["nginx","-g","daemon off;"]