#!/bin/bash
mkdir -p tempdir/myapp/static
mkdir -p tempdir/myapp/templates
cp Flask_app/flask_app.py tempdir/myapp/
cp Flask_app/static/style.css tempdir/myapp/static/
cp Flask_app/templates/index.html tempdir/myapp/templates/
cat <<EOF > tempdir/myapp/Dockerfile
FROM python:3.8-alpine
RUN apk update && apk add --no-cache build-base
RUN pip install Flask
WORKDIR /home/myapp
COPY . /home/myapp
EXPOSE 8080
CMD ["python", "flask_app.py"]
EOF
cd tempdir/myapp
docker build -t tp1_np .
docker run -d --name run_tp1_np -p 8080:8080 tp1_np
docker ps -a