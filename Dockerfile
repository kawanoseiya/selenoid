FROM golang:1.12-alpine

RUN set -ex \
    && apk update \
    && apk --no-cache add --virtual build-dependencies git 

RUN cd /usr/bin/ \
    && git clone https://github.com/aerokube/selenoid.git \
    && chmod -R 777 selenoid \
    && cd selenoid \
    && go build

RUN apk add -U ca-certificates tzdata mailcap && rm -Rf /var/cache/apk/*
COPY browsers.json /etc/browsers.json

EXPOSE 4444
ENTRYPOINT ["/usr/bin/selenoid", "-listen", ":4444", "-conf", "/etc/browsers.json", "-video-output-dir", "/opt/selenoid/video/"]