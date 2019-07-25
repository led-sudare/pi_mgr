#!/bin/sh
set -eu

echo "create Dockerfile.."
cat <<EOS > Dockerfile
FROM alpine
RUN apk update && apk add socat
EXPOSE 2375
CMD socat TCP-LISTEN:2375,reuseaddr,fork UNIX-CLIENT:/var/run/docker.sock
EOS
cname='docker-remote-api'
echo "Docker Build..."
sudo docker build ./ -t $cname

set +e
sudo docker container stop $cname
sudo docker container rm $cname
set -e

echo "Docker run.."
sudo docker run -d --init --name $cname -p 80:2375 --restart=always -v /var/run/docker.sock:/var/run/docker.sock $cname
