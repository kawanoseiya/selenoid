FROM alpine:3.8

ENV GOPATH=/go \
    PATH=/go/bin:/usr/local/go/bin:$PATH

WORKDIR /go/src

RUN apk --no-cache add --virtual build-dependencies bash gcc musl-dev openssl go git \
    && : \
    && : Install go 1.11 \
    && GOLANG_VERSION=1.11.1 \
    && GOLANG_SRC_URL=https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz \
    && GOLANG_SRC_SHA256=558f8c169ae215e25b81421596e8de7572bd3ba824b79add22fba6e284db1117 \
    && export GOROOT_BOOTSTRAP="$(go env GOROOT)" \
    && wget -q "$GOLANG_SRC_URL" -O golang.tar.gz \
    && echo "$GOLANG_SRC_SHA256  golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && cd /usr/local/go/src \
    && ./make.bash \
    && chmod -R 777 /go \
    && : \
    && : Clean up \
    && find /usr/local/go -depth -type d -name test -exec rm -rf {} \; \
    && find /usr/local/go -depth -type d -name testdata -exec rm -rf {} \; \
    && find / -depth -type f -name *_test.go -exec rm -f {} \; \
    && find / -depth -type f -name *README* -exec rm -f {} \; \
    && find /usr/local/go -depth -type d -name vendor -exec rm -rf {} \; \
    && find /usr/local/go -depth -type d -name go-build -exec rm -rf {} \; \
    && apk del --purge -r build-dependencies \
    && rm -rf /usr/local/go/doc /usr/local/go/api /usr/local/go/misc/trace \
        /usr/local/go/pkg/linux_amd64/vendor \
        /usr/local/go/pkg/linux_amd64/cmd/vendor \
        /usr/local/go/src/cmd/vendor/ \
        /usr/local/go/pkg/obj/go-build /usr/local/go/pkg/bootstrap \
        /go/src/* /root/.cache /var/cache/* /var/lib/apk* \
    && cd /usr/local/go/pkg/tool/linux_amd64/ \
    && rm -f [^acl]* a[^s]* cover \
    && rm -f /usr/local/go/bin/gofmt

CMD cd /usr/bin
RUN git clone https://github.com/aerokube/selenoid.git
RUN go build

RUN apk add -U ca-certificates tzdata mailcap && rm -Rf /var/cache/apk/*
COPY browsers.json /etc/browsers.json

EXPOSE 4444
ENTRYPOINT ["/usr/bin/selenoid", "-listen", ":4444", "-conf", "/etc/browsers.json", "-video-output-dir", "/opt/selenoid/video/"]
