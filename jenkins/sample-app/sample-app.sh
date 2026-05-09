#!/bin/bash

echo ">> Killing containers"
docker kill $(docker ps -q)

echo ""
echo ">> Removing containers"
docker rm $(docker ps -aq)

echo ""
echo ">> Removing tempdir"
rm -rf tempdir

echo ""
echo ">> Building and running container"

mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

echo "FROM python:3.11-slim" > tempdir/Dockerfile

echo "RUN pip install --progress-bar off flask" >> tempdir/Dockerfile

echo "COPY  ./static /home/myapp/static/" >> tempdir/Dockerfile
echo "COPY  ./templates /home/myapp/templates/" >> tempdir/Dockerfile
echo "COPY  sample_app.py /home/myapp/" >> tempdir/Dockerfile

echo "EXPOSE 5050" >> tempdir/Dockerfile

echo "CMD python /home/myapp/sample_app.py" >> tempdir/Dockerfile

cd tempdir
docker build -t sampleapp .
docker run -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a 
