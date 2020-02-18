FROM golang:1.12-alpine

WORKDIR /usr/bin/

RUN set -ex \
    && apk update \
    && apk --no-cache add --virtual build-dependencies git bash

RUN cd /usr/bin/ \
    && git clone https://github.com/aerokube/selenoid.git \
    && chmod -R 777 /usr/bin/selenoid \
    && cd selenoid \
    && go build

RUN apk add -U ca-certificates tzdata mailcap && rm -Rf /var/cache/apk/*
COPY browsers.json /etc/browsers.json

RUN chmod -R u+x /usr/bin/selenoid/selenoid

EXPOSE 4444
ENTRYPOINT ["/usr/bin/selenoid/selenoid", "-listen", ":4444", "-conf", "/etc/browsers.json", "-video-output-dir", "/opt/selenoid/video/"]