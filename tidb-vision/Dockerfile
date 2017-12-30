FROM node:8

ARG repo="https://github.com/pingcap/tidb-vision.git"

RUN git clone ${repo} /home/node/tidb-vision

WORKDIR /home/node/tidb-vision

ARG branch=master

RUN git checkout ${branch} && npm install

ENV PD_ENDPOINT=localhost:9000

EXPOSE 8010

CMD ["npm", "start"]
