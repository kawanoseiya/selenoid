# Selenoid
[![Build Status](https://travis-ci.org/aandryashin/selenoid.svg?branch=master)](https://travis-ci.org/aandryashin/selenoid)
[![Coverage](https://codecov.io/github/aandryashin/selenoid/coverage.svg)](https://codecov.io/gh/aandryashin/selenoid)
[![Release](https://img.shields.io/github/release/aandryashin/selenoid.svg)](https://github.com/aandryashin/selenoid/releases/latest)

This repository contains a simplified [Go](http://golang.org/) implementation of original [Selenium](http://github.com/SeleniumHQ/selenium) hub code.

## Building
We use [godep](https://github.com/tools/godep) for dependencies management so ensure it's installed before proceeding with next steps. To build the code:

1. Checkout this source tree: ```$ git clone https://github.com/aandryashin/selenoid.git```
2. Download dependencies: ```$ godep restore```
3. Build as usually: ```$ go build```
4. Run compiled binary: ```$GOPATH/bin/selenoid```

## Running
To run Selenoid type:
```
$ docker pull selenium/standalone-firefox
$ selenoid -docker-image=selenium/standalone-firefox -driver-port=4444 -driver-path=/wd/hub
```
By default it listens on port 4444.

## Example containers
Example containers can be pulled from [Docker Hub](https://hub.docker.com/u/selenoid/):
```
$ docker pull selenoid/firefox_48.0
```
Also take a look at container [source files](http://github.com/vania-pooh/selenoid-containers).