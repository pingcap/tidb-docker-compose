FROM node:8

WORKDIR /home/node
RUN git clone https://github.com/pingcap/tidb-vision.git
WORKDIR /home/node/tidb-vision
RUN npm install

ENV PD_ENDPOINT=localhost:9000

EXPOSE 8010

CMD ["npm", "start"]
