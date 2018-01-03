FROM node:8

ADD tidb-vision /home/node/tidb-vision

WORKDIR /home/node/tidb-vision

RUN npm install

ENV PD_ENDPOINT=localhost:9000

EXPOSE 8010

CMD ["npm", "start"]
