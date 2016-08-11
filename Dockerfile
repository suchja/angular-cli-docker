FROM node:5.12

# prepare a user which runs everything locally! - required in child images!
RUN useradd --user-group --create-home --shell /bin/false app

ENV HOME=/home/app
WORKDIR $HOME

RUN npm install -g angular-cli@1.0.0-beta.11-webpack.2 && npm cache clean

EXPOSE 4200
